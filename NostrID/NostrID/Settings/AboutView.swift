//
//  AboutView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct AboutView: View {
    
    let twitter1 = URL(string: "twitter://user?screen_name=\(UserDefaultKeys.personnalTwitter)")!
    let TwitterWebURL1 = URL(string: "https://twitter.com/\(UserDefaultKeys.personnalTwitter)")!
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
                            if UIApplication.shared.canOpenURL(twitter1 as URL) {
                                UIApplication.shared.open(twitter1)
                            } else {
                                UIApplication.shared.open(TwitterWebURL1)
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
                                hapticNotify(.success)
                                self.showCopyAlert = true
                                UIPasteboard.general.string = UserDefaultKeys.personnalNostr
                        }
                        
                        HStack(alignment: .center, spacing: 8) {
                            Image("nostr")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("nostr: NostrID")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                                hapticNotify(.success)
                                self.showCopyAlert = true
                                UIPasteboard.general.string = UserDefaultKeys.nostridNostr
                        }
                        
                        
                    }
                }
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(GroupedListStyle())
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

