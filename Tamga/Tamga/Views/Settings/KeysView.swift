//
//  KeysView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import UIKit
import KeychainAccess

struct KeysView: View {
    
    @ObservedObject var userSettings = UserSettings.shared
    
//    @AppStorage(UserDefaultKeys.publicKey) var publicKey: String?
    @State private var showCopyAlert = false
    @State private var revealPrivateKey = false
    @State private var isPopoverVisible = false
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    
    var body: some View {
        ZStack{
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0){
                    
                    List{
                        
                        Section("Public key"){
                            
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Hex : \(keychain["publicHexKey"]!)")
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                UIPasteboard.general.string = keychain["publicHexKey"]!
                                self.showCopyAlert = true
                                HapticsManager.shared.hapticNotify(.success)
                            }
                            
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Npub : \(keychain["publicNpubKey"]!)")
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                UIPasteboard.general.string = keychain["publicNpubKey"]!
                                self.showCopyAlert = true
                                HapticsManager.shared.hapticNotify(.success)
                            }
                        }
                        
                        
                        Section("Private key") {
                            // Private key content
                            Toggle(isOn: $revealPrivateKey) {
                                Text("Show Private Key") // Add switch to reveal private key
                            }
                            if revealPrivateKey {
                                Text("🚨 Sharing your private key online or on untrusted applications will compromise your account!")
                                    .foregroundColor(Color.red)
                                
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "key")
                                        .resizable()
                                        .frame(width: 12, height: 20)
                                    Text("Hex : \(keychain["privateHexKey"]!)")
                                        .padding(.leading, 5)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    UIPasteboard.general.string = keychain["privateHexKey"]!
                                    self.showCopyAlert = true
                                    HapticsManager.shared.hapticNotify(.success)
                                }
                                
                                HStack(alignment: .center, spacing: 8) {
                                    VStack{
                                        Image(systemName: "key")
                                            .resizable()
                                            .frame(width: 12, height: 20)
                                        Image(systemName: "qrcode")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    Text("Nsec : \(keychain["privateNsecKey"]!)")
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    isPopoverVisible = true
                                }
                                

                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Keys")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(InsetGroupedListStyle())
        }
        .overlay{
            if showCopyAlert{
                CheckmarkPopover()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.spring().delay(1)) {
                                self.showCopyAlert = false
                            }
                        }
                    }
            }
        }
        .popover(isPresented: $isPopoverVisible) {
            QrCodeView(key: keychain["privateNsecKey"]!)
        }
    }
    
    struct KeysView_Previews: PreviewProvider {
        static var previews: some View {
            KeysView()
        }
    }
}

