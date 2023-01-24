//
//  SettingsView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import LocalAuthentication
import ConfettiSwiftUI


struct SettingsView: View {
    
    @EnvironmentObject var session: SessionManager
    @AppStorage(UserDefaultKeys.hapticsEnabled) private var isHapticsEnabled: Bool = true
    @State private var counter = 0
    
    var body: some View {
        NavigationView{
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10){
                    
                    List{
                        Section{
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "key")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                NavigationLink("Keys", destination: KeysView())
                            }
                            
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "bolt.fill")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                NavigationLink("Relays", destination: RelaysView())
                            }

                        }
                        
                        Section{
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "square.split.bottomrightquarter.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                NavigationLink("App Icon", destination: AppIconView())
                            }
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "water.waves")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Toggle("Enable Haptics", isOn: $isHapticsEnabled)
                            }
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "faceid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Toggle("Face ID", isOn: .constant(false))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Section{
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                NavigationLink("About", destination: AboutView())
                            }
                        }
                        
                        Section(){
                            Button("Logout", role: .destructive){
                                session.signOut()
                                hapticNotify(.warning)
                            }
                            Button("Reset", role: .destructive){
                                counter += 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    session.resetOnboarding()
                                    hapticNotify(.warning)
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(GroupedListStyle())
            .confettiCannon(counter: $counter, num:1, confettis: [.text("😭"), .text("😔"), .text("👋")], confettiSize: 30, repetitions: 100, repetitionInterval: 0.1)
            
        }
    }

    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
                .environmentObject(SessionManager())
        }
    }
}

