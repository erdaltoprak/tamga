//
//  LoginView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var session: SessionManager
    @State private var animateGradient = true
    @AppStorage(UserDefaultKeys.publicKey) private var publicKey: String = UserDefaultKeys.publicKey
    @AppStorage(UserDefaultKeys.relay) private var relay: String = UserDefaultKeys.relay
    
    static let hexRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{64}$", options: .caseInsensitive)
    
    static func isValidHex(_ hex: String) -> Bool {
        let range = NSRange(location: 0, length: hex.utf16.count)
        return hexRegex.firstMatch(in: hex, options: [], range: range) != nil
    }
    
    
    var backgroundView: some View {
        LinearGradient(colors: [.purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            .hueRotation(.degrees(animateGradient ? 45 : 0))
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
    }
    
    var body: some View {
        ZStack {
            
            VStack{
                
                
                VStack(spacing: 0) {
                    Text("🤝")
                        .font(.system(size: 150))
                    
                    Text("Let's start")
                        .font(.system(size: 35,
                                      weight: .heavy,
                                      design: .rounded))
                    
                    Text("Enter your existing public hex key, and choose your favorite relay to start seeing your nostr friends and profile. If your public key starts with \"npub\" you can convert if by clicking below. (Read-Only Alpha)")
                        .padding()
                        .font(.system(size: 18,
                                      weight: .regular,
                                      design: .rounded))
                    
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom, 20)
                
                VStack(spacing: 0){
                    TextField("Public Key", text: $publicKey)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(.black, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.bottom, 8)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    TextField("Relay", text: $relay)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(.black, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .padding(.bottom, 8)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            hapticPlay(.rigid)
                        }
                }
                .padding(.bottom, 30)
                
                VStack{
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "\(UserDefaultKeys.moreNostrInfo)")!)
                    }) {
                        Text("Learn more")
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(width: 185, height: 54)
                    .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .transition(.scale.combined(with: .opacity))
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "\(UserDefaultKeys.nostreKeyConvert)")!)
                    }) {
                        Text("Convert Key")
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.horizontal, 34)
                    .padding(.vertical, 15)
                    .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .transition(.scale.combined(with: .opacity))
                    
                    
                    Button("Login") {
                        relay = relay.trimmingCharacters(in: .whitespaces)
                        publicKey = publicKey.trimmingCharacters(in: .whitespaces)
                        session.signIn()
                        hapticNotify(.success)
                        
                        
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.horizontal, 65)
                    .padding(.vertical, 15)
                    .background(publicKey.isEmpty || publicKey == "Enter Your Public Key" || !LoginView.isValidHex(publicKey) ? Color.red : Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .foregroundColor(.black)
                    .disabled(publicKey.isEmpty || publicKey == "Enter Your Public Key" || !LoginView.isValidHex(publicKey))
                    .onTapGesture {
                        if publicKey.isEmpty || publicKey == "Enter Your Public Key" || !LoginView.isValidHex(publicKey) {
                            hapticNotify(.error)
                        }
                    }
                }
                
            }

            
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
          )
        .background(backgroundView)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SessionManager())
    }
}

