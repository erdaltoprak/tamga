//
//  AboutView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct AboutView: View {
    
    @ObservedObject var userSettings = UserSettings.shared
    @State private var showCopyAlert = false
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 10){
                
                List{
                    Section{
                        HStack(alignment: .center, spacing: 8) {
                            Image("changelog")
                                .resizable()
                                .frame(width: 30, height: 30)
                            NavigationLink("Changelog", destination: ChangelogView())
                        }
                        
                        HStack(alignment: .center, spacing: 8) {
                            Image("thanksto")
                                .resizable()
                                .frame(width: 30, height: 30)
                            NavigationLink("Thanks To", destination: ThanksToView())
                        }
                        
                        
                        HStack(alignment: .center, spacing: 8) {
                            Image("twitter")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("@ErdalxToprak")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if UIApplication.shared.canOpenURL(URL(string: "twitter://user?screen_name=\(userSettings.erdalTwitter)")! as URL) {
                                UIApplication.shared.open(URL(string: "twitter://user?screen_name=\(userSettings.erdalTwitter)")!)
                            } else {
                                UIApplication.shared.open(URL(string: "https://twitter.com/\(userSettings.erdalTwitter)")!)
                            }
                        }
                        
                        
                        HStack(alignment: .center, spacing: 8) {
                            Image("nostr")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("nostr: Erdal")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if UIApplication.shared.canOpenURL(URL(string: "nostr://\(userSettings.erdalNpub)")! as URL) {
                                UIApplication.shared.open(URL(string: "nostr://\(userSettings.erdalNpub)")!)
                            } else {
                                HapticsManager.shared.hapticNotify(.success)
                                self.showCopyAlert = true
                                UIPasteboard.general.string = userSettings.erdalNpub
                            }
                        }
                        
                        HStack(alignment: .center, spacing: 8) {
                            Image("nostr")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("nostr: Tamga")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if UIApplication.shared.canOpenURL(URL(string: "nostr://\(userSettings.tamgaNpub)")! as URL) {
                                UIApplication.shared.open(URL(string: "nostr://\(userSettings.tamgaNpub)")!)
                            } else {
                                HapticsManager.shared.hapticNotify(.success)
                                self.showCopyAlert = true
                                UIPasteboard.general.string = userSettings.tamgaNpub
                            }
                        }
                        
                        
                    }
                }
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(InsetGroupedListStyle())
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
    }
}


struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

