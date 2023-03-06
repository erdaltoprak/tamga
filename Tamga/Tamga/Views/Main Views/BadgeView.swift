//
//  BadgesView.swift
//  Tamga
//
//  Created by Erdal Toprak on 05/03/2023.
//

import SwiftUI
import KeychainAccess

struct BadgeView: View {
    @EnvironmentObject var session: SessionManager
    @ObservedObject var userSettings = UserSettings.shared
    @ObservedObject var relayManager = NostrRelayManager.shared
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var badgeList : FetchedResults<Badge>
    
    var body: some View {
        NavigationView{
            
            
            
            ScrollView {
                if badgeList.count > 0 {
                    LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)], spacing: 3) {
                        ForEach(badgeList, id: \.badgeUniqueName){ badge in

                            NavigationLink(destination: BadgeDetailView(badge: badge)){
                                AsyncImage(
                                    url: URL(string: badge.badgePicture ?? ""),
                                    content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                            .clipped()
                                            .aspectRatio(1, contentMode: .fit)
                                    },
                                    placeholder: {
                                        Image("nostrProfile1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                            .clipped()
                                            .aspectRatio(1, contentMode: .fit)

                                    }
                                )
                            }
                        }
                    }
                }
                else {
                    ScrollView{
                        HStack{
                            VStack{
                                Text("😭 No badges found")
                            }
                        }
                    }
                    
                }

            }
            
            
//                        List{
//                            if badgeList.count > 0 {
//                                ForEach(badgeList, id: \.badgeUniqueName){ badge in
//                                    Section{
//                                        Text(badge.badgeUniqueName ?? "badgeUniqueName")
//                                        Text(badge.badgeName ?? "badgeName")
//                                        Text(badge.badgeCreator ?? "badgeCreator")
//                                        Text(badge.badgeDescription ?? "badgeDescription")
//                                        Text(badge.badgePicture ?? "badgePicture")
//                                    }
//                                }
//                            }
//                            else {
//                                Text("no badges")
//                            }
//
//                        }
            
            
            .navigationTitle("\(badgeList.count) Badges")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        
                        Button(action: {
                            
                            AppCoreData.shared.deleteAllBadgeData()
                            NostrRelayManager.shared.forceReconnect()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                userSettings.lastContactUpdateDate = 0
                                relayManager.retreiveBadgeFromRelay2(pubkey: keychain["publicHexKey"]!)
                            }
                            
                            
                        }) {
                            Text("Pull badges")
                            Image(systemName: "arrow.down.circle")
                                .resizable()
                        }
                        
                        Button(action: {
                            if let url = URL(string: "\(userSettings.nostrBadges)\(keychain["publicHexKey"]!)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Check badges on the web")
                            Image(systemName: "arrow.up.forward.app")
                                .resizable()
                        }
                        
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 21))
                    }
                }
            }
        }
        
    }
}

struct BadgesView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
