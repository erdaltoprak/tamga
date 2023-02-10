//
//  KeyConvert.swift
//  NostrID
//
//  Created by Erdal Toprak on 01/02/2023.
//

import Foundation
import NostrKit
import SwiftUI

struct KeyConvert {
    
    @ObservedObject var userSettings = UserSettings.shared
    
    static let shared = KeyConvert()
    private init() {}

    func keyConversion(key: String){
        if key.hasPrefix("nsec"), let keypair = try? KeyPair(bech32PrivateKey: key) {
            userSettings.privateNsecKey = keypair.bech32PrivateKey
            userSettings.publicNpubKey = keypair.bech32PublicKey
            userSettings.privateHexKey = keypair.privateKey
            userSettings.publicHexKey = keypair.publicKey
        } else if let keypair = try? KeyPair(privateKey: key)  {
            userSettings.privateNsecKey = keypair.bech32PrivateKey
            userSettings.publicNpubKey = keypair.bech32PublicKey
            userSettings.privateHexKey = keypair.privateKey
            userSettings.publicHexKey = keypair.publicKey
        }
        print(userSettings.privateNsecKey, userSettings.publicNpubKey, userSettings.privateHexKey, userSettings.publicHexKey)
    }
    
    func isValidString(key: String) -> Bool {
        let strippedString = key.trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .joined()
        if strippedString.hasPrefix("nsec") {
            return strippedString.count == 63
        } else {
            return strippedString.count == 64
        }
    }
    
}
