//
//  NostrKey.swift
//  Tamga
//  Added / Modified by Erdal Toprak on 26/02/2023.
//
//  Bech32.swift
//  Modified by William Casarin in 2022
//  Created by Evolution Group Ltd on 12.02.2018.
//  Copyright © 2018 Evolution Group Ltd. All rights reserved.
//
//  Base32 address format for native v0-16 witness outputs implementation
//  https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
//  Inspired by Pieter Wuille C++ implementation

import Foundation
import secp256k1
import CommonCrypto
import SwiftUI
import KeychainAccess

struct NostrKey {
    
    /// Bech32 checksum implementation
    fileprivate let gen: [UInt32] = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
    /// Bech32 checksum delimiter
    fileprivate let checksumMarker: String = "1"
    /// Bech32 character set for encoding
    fileprivate let encCharset: Data = "qpzry9x8gf2tvdw0s3jn54khce6mua7l".data(using: .utf8)!
    /// Bech32 character set for decoding
    fileprivate let decCharset: [Int8] = [
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
         15, -1, 10, 17, 21, 20, 26, 30,  7,  5, -1, -1, -1, -1, -1, -1,
         -1, 29, -1, 24, 13, 25,  9,  8, 23, -1, 18, 22, 31, 27, 19, -1,
         1,  0,  3, 16, 11, 28, 12, 14,  6,  4,  2, -1, -1, -1, -1, -1,
         -1, 29, -1, 24, 13, 25,  9,  8, 23, -1, 18, 22, 31, 27, 19, -1,
         1,  0,  3, 16, 11, 28, 12, 14,  6,  4,  2, -1, -1, -1, -1, -1
    ]
    
    @ObservedObject var userSettings = UserSettings.shared
    
    static let shared = NostrKey()
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    private init() {}
    
    func keyConversion(key: String){
        if key.hasPrefix("nsec"), let keypair = try? KeyPair(bech32PrivateKey: key) {
//            userSettings.privateNsecKey = keypair.bech32PrivateKey
//            userSettings.publicNpubKey = keypair.bech32PublicKey
//            userSettings.privateHexKey = keypair.privateKey
//            userSettings.publicHexKey = keypair.publicKey
            
            keychain["privateNsecKey"] = keypair.bech32PrivateKey
            keychain["publicNpubKey"] = keypair.bech32PublicKey
            keychain["privateHexKey"] = keypair.privateKey
            keychain["publicHexKey"] = keypair.publicKey
            
        } else if let keypair = try? KeyPair(privateKey: key)  {
//            userSettings.privateNsecKey = keypair.bech32PrivateKey
//            userSettings.publicNpubKey = keypair.bech32PublicKey
//            userSettings.privateHexKey = keypair.privateKey
//            userSettings.publicHexKey = keypair.publicKey
            
            keychain["privateNsecKey"] = keypair.bech32PrivateKey
            keychain["publicNpubKey"] = keypair.bech32PublicKey
            keychain["privateHexKey"] = keypair.privateKey
            keychain["publicHexKey"] = keypair.publicKey
            
        }
    }
    
    func isValidString(key: String) -> Bool {
        let strippedString = key.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
        if strippedString.hasPrefix("nsec") {
            return true
        } else {
            return false
        }
    }
    
    
    
        /// Find the polynomial with value coefficients mod the generator as 30-bit.
    public func bech32_polymod(_ values: Data) -> UInt32 {
            var chk: UInt32 = 1
            for v in values {
                let top = (chk >> 25)
                chk = (chk & 0x1ffffff) << 5 ^ UInt32(v)
                for i: UInt8 in 0..<5 {
                    chk ^= ((top >> i) & 1) == 0 ? 0 : gen[Int(i)]
                }
            }
            return chk
        }


    /// Expand a HRP for use in checksum computation.
    func bech32_expand_hrp(_ s: String) -> Data {
        var left: [UInt8] = []
        var right: [UInt8] = []
        for x in Array(s) {
            let scalars = String(x).unicodeScalars
            left.append(UInt8(scalars[scalars.startIndex].value) >> 5)
            right.append(UInt8(scalars[scalars.startIndex].value) & 31)
        }
        return Data(left + [0] + right)
    }
        
    /// Verify checksum
    public func bech32_verify(hrp: String, checksum: Data) -> Bool {
        var data = bech32_expand_hrp(hrp)
        data.append(checksum)
        return bech32_polymod(data) == 1
    }
        
    /// Create checksum
    public func bech32_create_checksum(hrp: String, values: Data) -> Data {
        var enc = bech32_expand_hrp(hrp)
        enc.append(values)
        enc.append(Data(repeating: 0x00, count: 6))
        let mod: UInt32 = bech32_polymod(enc) ^ 1
        var ret: Data = Data(repeating: 0x00, count: 6)
        for i in 0..<6 {
            ret[i] = UInt8((mod >> (5 * (5 - i))) & 31)
        }
        return ret
    }
        
    public func bech32_encode(hrp: String, _ input: [UInt8]) -> String {
        let table: [Character] = Array("qpzry9x8gf2tvdw0s3jn54khce6mua7l")
        let bits = eightToFiveBits(input)
        let check_sum = bech32_checksum(hrp: hrp, data: bits)
        let separator = "1"
        return "\(hrp)" + separator + String((bits + check_sum).map { table[Int($0)] })
    }

    func bech32_checksum(hrp: String, data: [UInt8]) -> [UInt8] {
        let values = bech32_expand_hrp(hrp) + data
        let polymod = bech32_polymod(values + [0,0,0,0,0,0]) ^ 1
        var result: [UInt32] = []
        for i in (0..<6) {
            result.append((polymod >> (5 * (5 - UInt32(i)))) & 31)
        }
        return result.map { UInt8($0) }
    }

    func bech32_convert_bits(outbits: Int, input: Data, inbits: Int, pad: Int) -> Data? {
        let maxv: UInt32 = ((UInt32(1)) << outbits) - 1;
        var val: UInt32 = 0
        var bits: Int = 0
        var out = Data()
        
        for i in (0..<input.count) {
            val = (val << inbits) | UInt32(input[i])
            bits += inbits;
            while bits >= outbits {
                bits -= outbits;
                out.append(UInt8((val >> bits) & maxv))
            }
        }
        
        if pad != 0 {
            if bits != 0 {
                out.append(UInt8(val << (outbits - bits) & maxv))
            }
        } else if 0 != ((val << (outbits - bits)) & maxv) || bits >= inbits {
            return nil
        }
        
        return out
    }

    func eightToFiveBits(_ input: [UInt8]) -> [UInt8] {
        guard !input.isEmpty else { return [] }
        
        var outputSize = (input.count * 8) / 5
        if ((input.count * 8) % 5) != 0 {
            outputSize += 1
        }
        var outputArray: [UInt8] = []
        for i in (0..<outputSize) {
            let devision = (i * 5) / 8
            let reminder = (i * 5) % 8
            var element = input[devision] << reminder
            element >>= 3
            
            if (reminder > 3) && (i + 1 < outputSize) {
                element = element | (input[devision + 1] >> (8 - reminder + 3))
            }
            
            outputArray.append(element)
        }
        
        return outputArray
    }
        
        /// Decode Bech32 string
    public func bech32_decode(_ str: String) throws -> (hrp: String, data: Data)? {
        guard let strBytes = str.data(using: .utf8) else {
            throw Bech32Error.nonUTF8String
        }
        guard strBytes.count <= 90 else {
            throw Bech32Error.stringLengthExceeded
        }
        var lower: Bool = false
        var upper: Bool = false
        for c in strBytes {
            // printable range
            if c < 33 || c > 126 {
                throw Bech32Error.nonPrintableCharacter
            }
            // 'a' to 'z'
            if c >= 97 && c <= 122 {
                lower = true
            }
            // 'A' to 'Z'
            if c >= 65 && c <= 90 {
                upper = true
            }
        }
        if lower && upper {
            throw Bech32Error.invalidCase
        }
        guard let pos = str.range(of: checksumMarker, options: .backwards)?.lowerBound else {
            throw Bech32Error.noChecksumMarker
        }
        let intPos: Int = str.distance(from: str.startIndex, to: pos)
        guard intPos >= 1 else {
            throw Bech32Error.incorrectHrpSize
        }
        guard intPos + 7 <= str.count else {
            throw Bech32Error.incorrectChecksumSize
        }
        let vSize: Int = str.count - 1 - intPos
        var values: Data = Data(repeating: 0x00, count: vSize)
        for i in 0..<vSize {
            let c = strBytes[i + intPos + 1]
            let decInt = decCharset[Int(c)]
            if decInt == -1 {
                throw Bech32Error.invalidCharacter
            }
            values[i] = UInt8(decInt)
        }
        let hrp = String(str[..<pos]).lowercased()
        guard bech32_verify(hrp: hrp, checksum: values) else {
            throw Bech32Error.checksumMismatch
        }
        let out = Data(values[..<(vSize-6)])
        guard let converted = bech32_convert_bits(outbits: 8, input: out, inbits: 5, pad: 0) else {
            return nil
        }
        return (hrp, converted)
    }

    public enum Bech32Error: LocalizedError {
        case nonUTF8String
        case nonPrintableCharacter
        case invalidCase
        case noChecksumMarker
        case incorrectHrpSize
        case incorrectChecksumSize
        case stringLengthExceeded
        
        case invalidCharacter
        case checksumMismatch
        
        public var errorDescription: String? {
            switch self {
            case .checksumMismatch:
                return "Checksum doesn't match"
            case .incorrectChecksumSize:
                return "Checksum size too low"
            case .incorrectHrpSize:
                return "Human-readable-part is too small or empty"
            case .invalidCase:
                return "String contains mixed case characters"
            case .invalidCharacter:
                return "Invalid character met on decoding"
            case .noChecksumMarker:
                return "Checksum delimiter not found"
            case .nonPrintableCharacter:
                return "Non printable character in input string"
            case .nonUTF8String:
                return "String cannot be decoded by utf8 decoder"
            case .stringLengthExceeded:
                return "Input string is too long"
            }
        }
    }
 
    func bech32_pubkey(_ pubkey: String) -> String? {
        guard let bytes = hex_decode(pubkey) else {
            return nil
        }
        return bech32_encode(hrp: "npub", bytes)
    }


    func hex_decode(_ str: String) -> [UInt8]?
    {
        if str.count == 0 {
            return nil
        }
        var ret: [UInt8] = []
        let chars = Array(str.utf8)
        var i: Int = 0
        for c in zip(chars, chars[1...]) {
            i += 1

            if i % 2 == 0 {
                continue
            }

            guard let c1 = char_to_hex(c.0) else {
                return nil
            }

            guard let c2 = char_to_hex(c.1) else {
                return nil
            }

            ret.append((c1 << 4) | c2)
        }

        return ret
    }

    func char_to_hex(_ c: UInt8) -> UInt8?
    {
        // 0 && 9
        if (c >= 48 && c <= 57) {
            return c - 48 // 0
        }
        // a && f
        if (c >= 97 && c <= 102) {
            return c - 97 + 10;
        }
        // A && F
        if (c >= 65 && c <= 70) {
            return c - 65 + 10;
        }
        return nil;
    }

    
}



    
  


public struct KeyPair {
    typealias PrivateKey = secp256k1.Signing.PrivateKey
    typealias PublicKey = secp256k1.Signing.PublicKey
    
    private let _privateKey: PrivateKey
    
    var schnorrSigner: secp256k1.Signing.SchnorrSigner {
        return _privateKey.schnorr
    }
    
    var schnorrValidator: secp256k1.Signing.SchnorrValidator {
        return _privateKey.publicKey.schnorr
    }
    
    public var publicKey: String {
        return Data(_privateKey.publicKey.xonly.bytes).hex()
    }
    
    public var privateKey: String {
        return _privateKey.rawRepresentation.hex()
    }
    
    public var bech32PrivateKey: String {
        return NostrKey.shared.bech32_encode(hrp: "nsec", _privateKey.rawRepresentation.bytes)
    }

    public var bech32PublicKey: String {
        return NostrKey.shared.bech32_encode(hrp: "npub", _privateKey.publicKey.xonly.bytes)
    }
    
    public init() throws {
        _privateKey = try PrivateKey()
    }
    
    public init(privateKey: String) throws {
        self = try .init(privateKey: try Data(hex: privateKey))
    }
    
    public init(privateKey: Data) throws {
        self._privateKey = try PrivateKey(rawRepresentation: privateKey)
    }

    public init(bech32PrivateKey: String) throws {
        let decoded = try NostrKey.shared.bech32_decode(bech32PrivateKey)
        guard let privateKeyHex = decoded?.data.hex() else {
            throw KeyPairError.bech32DecodeFailed
        }
        if decoded?.hrp == "nsec" {
            self = try .init(privateKey: privateKeyHex)
        } else {
            throw KeyPairError.bech32DecodeFailed
        }
    }

    public enum KeyPairError: Error {
        case bech32DecodeFailed
    }
}

public extension KeyPair {
    
    static func bech32PrivateKey(fromHex privateKey: String) -> String? {
        guard let bytes = try? Data(hex: privateKey).bytes else {
            return nil
        }
        return NostrKey.shared.bech32_encode(hrp: "nsec", bytes)
    }

    static func bech32PublicKey(fromHex publicKey: String) -> String? {
        guard let bytes = try? Data(hex: publicKey).bytes else {
            return nil
        }
        return NostrKey.shared.bech32_encode(hrp: "npub", bytes)
    }
    
    static func decryptDirectMessageContent(withPrivateKey privateKey: String?, pubkey: String, content: String) -> String? {
        guard let privateKey else {
            return nil
        }
        guard let sharedSecret = get_shared_secret(privkey: privateKey, pubkey: pubkey) else {
            return nil
        }
        guard let dat = decode_dm_base64(content) else {
            return nil
        }
        guard let dat = aes_decrypt(data: dat.content, iv: dat.iv, shared_sec: sharedSecret) else {
            return nil
        }
        return String(data: dat, encoding: .utf8)
    }
    
    static func encryptDirectMessageContent(withPrivatekey privateKey: String?, pubkey: String, content: String) -> String? {
        
        guard let privateKey = privateKey else {
            return nil
        }
        
        guard let sharedSecret = get_shared_secret(privkey: privateKey, pubkey: pubkey) else {
            return nil
        }
        
        let utf8Content = Data(content.utf8).bytes
        var random = Data(count: 16)
        random.withUnsafeMutableBytes { (rawMutableBufferPointer) in
            let bufferPointer = rawMutableBufferPointer.bindMemory(to: UInt8.self)
            if let address = bufferPointer.baseAddress {
                _ = SecRandomCopyBytes(kSecRandomDefault, 16, address)
            }
        }
        
        let iv = random.bytes
        
        guard let encryptedContent = aes_encrypt(data: utf8Content, iv: iv, shared_sec: sharedSecret) else {
            return nil
        }
        
        return encode_dm_base64(content: encryptedContent.bytes, iv: iv)
        
    }

    static func get_shared_secret(privkey: String, pubkey: String) -> [UInt8]? {
        guard let privkey_bytes = try? privkey.bytes else {
            return nil
        }
        guard var pk_bytes = try? pubkey.bytes else {
            return nil
        }
        pk_bytes.insert(2, at: 0)
        
        var publicKey = secp256k1_pubkey()
        var shared_secret = [UInt8](repeating: 0, count: 32)

        var ok =
            secp256k1_ec_pubkey_parse(
                try! secp256k1.Context.create(),
                &publicKey,
                pk_bytes,
                pk_bytes.count) != 0

        if !ok {
            return nil
        }

        ok = secp256k1_ecdh(
            try! secp256k1.Context.create(),
            &shared_secret,
            &publicKey,
            privkey_bytes, {(output,x32,_,_) in
                memcpy(output,x32,32)
                return 1
            }, nil) != 0

        if !ok {
            return nil
        }

        return shared_secret
    }

    struct DirectMessageBase64 {
        let content: [UInt8]
        let iv: [UInt8]
    }

    static func encode_dm_base64(content: [UInt8], iv: [UInt8]) -> String {
        let content_b64 = base64_encode(content)
        let iv_b64 = base64_encode(iv)
        return content_b64 + "?iv=" + iv_b64
    }

    static func decode_dm_base64(_ all: String) -> DirectMessageBase64? {
        let splits = Array(all.split(separator: "?"))

        if splits.count != 2 {
            return nil
        }

        guard let content = base64_decode(String(splits[0])) else {
            return nil
        }

        var sec = String(splits[1])
        if !sec.hasPrefix("iv=") {
            return nil
        }

        sec = String(sec.dropFirst(3))
        guard let iv = base64_decode(sec) else {
            return nil
        }

        return DirectMessageBase64(content: content, iv: iv)
    }

    static func base64_encode(_ content: [UInt8]) -> String {
        return Data(content).base64EncodedString()
    }

    static func base64_decode(_ content: String) -> [UInt8]? {
        guard let dat = Data(base64Encoded: content) else {
            return nil
        }
        return dat.bytes
    }

    static func aes_decrypt(data: [UInt8], iv: [UInt8], shared_sec: [UInt8]) -> Data? {
        return aes_operation(operation: CCOperation(kCCDecrypt), data: data, iv: iv, shared_sec: shared_sec)
    }

    static func aes_encrypt(data: [UInt8], iv: [UInt8], shared_sec: [UInt8]) -> Data? {
        return aes_operation(operation: CCOperation(kCCEncrypt), data: data, iv: iv, shared_sec: shared_sec)
    }

    static func aes_operation(operation: CCOperation, data: [UInt8], iv: [UInt8], shared_sec: [UInt8]) -> Data? {
        let data_len = data.count
        let bsize = kCCBlockSizeAES128
        let len = Int(data_len) + bsize
        var decrypted_data = [UInt8](repeating: 0, count: len)

        let key_length = size_t(kCCKeySizeAES256)
        if shared_sec.count != key_length {
            assert(false, "unexpected shared_sec len: \(shared_sec.count) != 32")
            return nil
        }

        let algorithm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)

        var num_bytes_decrypted :size_t = 0

        let status = CCCrypt(operation,  /*op:*/
                             algorithm,  /*alg:*/
                             options,    /*options:*/
                             shared_sec, /*key:*/
                             key_length, /*keyLength:*/
                             iv,         /*iv:*/
                             data,       /*dataIn:*/
                             data_len, /*dataInLength:*/
                             &decrypted_data,/*dataOut:*/
                             len,/*dataOutAvailable:*/
                             &num_bytes_decrypted/*dataOutMoved:*/
        )

        if UInt32(status) != UInt32(kCCSuccess) {
            return nil
        }

        return Data(bytes: decrypted_data, count: num_bytes_decrypted)

    }
    
}

extension Data {
    enum DecodingError: Error {
        case oddNumberOfCharacters
        case invalidHexCharacters([Character])
    }
    
    func hex() -> String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
    
    init(hex: String) throws {
        guard hex.count.isMultiple(of: 2) else { throw DecodingError.oddNumberOfCharacters }
        
        self = .init(capacity: hex.utf8.count / 2)

        for pair in hex.unfoldSubSequences(ofMaxLength: 2) {
            guard let byte = UInt8(pair, radix: 16) else {
                let invalidCharacters = Array(pair.filter({ !$0.isHexDigit }))
                throw DecodingError.invalidHexCharacters(invalidCharacters)
            }
            
            append(byte)
        }
    }
}

private extension Collection {
    func unfoldSubSequences(ofMaxLength maxSequenceLength: Int) -> UnfoldSequence<SubSequence, Index> {
        sequence(state: startIndex) { current in
            guard current < endIndex else { return nil }
            
            let upperBound = index(current, offsetBy: maxSequenceLength, limitedBy: endIndex) ?? endIndex
            defer { current = upperBound }
            
            return self[current..<upperBound]
        }
    }
}


