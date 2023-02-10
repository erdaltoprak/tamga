//
//  LoginView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import BetterSafariView

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var session: SessionManager
    @ObservedObject var userSettings = UserSettings.shared
    @State private var animateGradient = true
    @State private var tempKey = ""
    @State private var moreNostrInfo : Bool = false
    
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
                    
                    Text("Enter your existing private key to continue. You can get more informations by clicking below.  (Read-Only Beta)")
                        .padding()
                        .font(.system(size: 18,
                                      weight: .regular,
                                      design: .rounded))
                    
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom, 20)
                
                VStack(spacing: 0){
                    TextField("Private Key", text: $tempKey)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(.black, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.bottom, 8)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 30)
                
                VStack{
                    
                    Button(action: {
                        self.moreNostrInfo = true
                        HapticsManager.shared.hapticNotify(.success)
                    }) {
                        Text("Learn more")
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(width: 185, height: 54)
                    .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .transition(.scale.combined(with: .opacity))
                    .safariView(isPresented: $moreNostrInfo) {
                        SafariView(
                            url: URL(string: userSettings.moreNostrInfo)!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.clear)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
                    
                    
                    Button("Login") {
                        tempKey = tempKey.trimmingCharacters(in: .whitespaces)
                        KeyConvert.shared.keyConversion(key: tempKey)
                        tempKey = ""
                        session.signIn()
                        HapticsManager.shared.hapticNotify(.success)
                        let contact = Profile(context: viewContext)
                        contact.id = userSettings.publicHexKey
                        contact.isMainUser = true
                        contact.isOfflineProfile  = false
                        contact.lastProfileUpdate = 0
                        do {
                            try viewContext.save()
//                            contact.retreiveProfile()
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.horizontal, 65)
                    .padding(.vertical, 15)
                    .background(!KeyConvert.shared.isValidString(key: tempKey) ? Color.red : Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .foregroundColor(.black)
                    .disabled(!KeyConvert.shared.isValidString(key: tempKey))
                    .onTapGesture {
                        if !KeyConvert.shared.isValidString(key: tempKey) {
                            HapticsManager.shared.hapticNotify(.error)
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

