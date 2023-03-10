//
//  LoginView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import FluidGradient
import KeychainAccess
import CodeScanner

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var session: SessionManager
    @ObservedObject var userSettings = UserSettings.shared
    @ObservedObject var relayManager = NostrRelayManager.shared
    @State private var animateGradient = true
    @State private var tempKey = ""
    @State private var isScanningQrCode = false
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    var backgroundView: some View {
        
        FluidGradient(blobs: [.red, .teal, .indigo],
                      highlights: [.orange, .red, .indigo],
                      speed: 0.7,
                      blur: 0.75)
          .background(.quaternary)
          .edgesIgnoringSafeArea(.all)
        
    }
    
    var body: some View {
        ZStack {
            
            VStack{
                
                Spacer()
                
                VStack(spacing: 0) {
                    Image(uiImage: .init(named: "icon1") ?? .init())
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 100, height: 100)
                      .cornerRadius(min(40, 80) / 2)
                      .padding(.bottom, 20)
//                    Text("🤝")
//                        .font(.system(size: 150))
                    
                    Text("Let's start")
                        .font(.system(size: 35,
                                      weight: .heavy,
                                      design: .rounded))
                    
                    Text("Enter your existing private key to continue. \n Your keys are stored locally using the device's keychain.")
                        .padding()
                        .font(.system(size: 18,
                                      weight: .regular,
                                      design: .rounded))
                    
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom, 20)
                
                VStack(spacing: 0){
                    HStack{
                        
                        
                        TextField("nsec...", text: $tempKey)
                            .multilineTextAlignment(.leading)
                        
                        
                        Button(action: {
                            isScanningQrCode = true
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                        }
                    }
                    .padding()
//                    .padding(.bottom, 8)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .background(.black, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .frame(width: 350, height: 50)

                }
                .padding(.bottom, 30)
                
                VStack{
                    
                    Button(action: {
                        HapticsManager.shared.hapticNotify(.success)
                        let url = URL(string: userSettings.moreNostrInfo)
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }) {
                        Text("Learn more")
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .frame(width: 185, height: 54)
                    .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .transition(.scale.combined(with: .opacity))
                    
                    
                    Button("Login") {
                        tempKey = tempKey.trimmingCharacters(in: .whitespaces)
                        NostrKey.shared.keyConversion(key: tempKey)
                        tempKey = ""
                        session.signIn()
                        HapticsManager.shared.hapticNotify(.success)
                        let contact = Profile(context: viewContext)
                        contact.id = keychain["publicHexKey"]
                        contact.isMainUser = true
                        contact.isOfflineProfile  = false
                        contact.lastProfileUpdate = 0
                        NostrRelayManager.shared.forceReconnect()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            userSettings.lastContactUpdateDate = 0
                            relayManager.retreiveFromRelay(pubkey: keychain["publicHexKey"]!)
                        }
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
                    .background(!NostrKey.shared.isValidString(key: tempKey) ? Color.red : Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .foregroundColor(.black)
                    .disabled(!NostrKey.shared.isValidString(key: tempKey))
                    .onTapGesture {
                        if !NostrKey.shared.isValidString(key: tempKey) {
                            HapticsManager.shared.hapticNotify(.error)
                        }
                    }
                }
                
                Spacer()
                
                VStack{
                    HStack{
                        Text("Tamga help & keys safety")
                            .font(.caption)
                    }
                    .contentShape(Rectangle())
                }
                .onTapGesture {
                    let url = URL(string: userSettings.tamgaHelp)
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
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
        .onAppear{
            AppCoreData.shared.deleteAllData()
            AppCoreData.shared.deleteAllBadgeData()
        }
        .sheet(isPresented: $isScanningQrCode) {
            NavigationStack{
                HStack{
                    CodeScannerView(codeTypes: [.qr], simulatedData: "", completion: handleScan)
                        
                }
                .navigationTitle("Scan Private Key")
                .ignoresSafeArea(.all)
            }


        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isScanningQrCode = false

        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            let prefix = "nostr:"
            let result = details[0].hasPrefix(prefix) ? String(details[0].dropFirst(prefix.count)) : details[0]
            tempKey = result

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SessionManager())
    }
}

