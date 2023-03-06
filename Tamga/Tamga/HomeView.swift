//
//  HomeView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @State private var selection = 0
    @EnvironmentObject var session: SessionManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var contactsList : FetchedResults<Profile>
    
    var body: some View {
        VStack{
            HStack{
                
                TabView(selection: $selection){
                    
                    ContactView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person.crop.square.filled.and.at.rectangle.fill")
                                Text("Contacts")
                            }
                        }
                        .tag(0)
                    
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person.fill")
                                Text("Profile")
                            }
                        }
                        .tag(1)
                    
                    BadgeView()
                        .tabItem {
                            VStack {
                                Image(systemName: "rosette")
                                Text("Badges")
                            }
                        }
                        .tag(2)
                    
//                    SettingsView()
//                        .tabItem {
//                            VStack {
//                                Image(systemName: "bookmark.square.fill")
//                                Text("Bookmarks")
//                            }
//                        }
//                        .tag(3)
                    
                    SettingsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                        }
                        .tag(4)
                    
                }
                .onChange(of: selection) { value in
                    HapticsManager.shared.hapticPlay(.light)
                }
                .onAppear {
                    if #available(iOS 15.0, *) {
                        let appearance = UITabBarAppearance()
                        UITabBar.appearance().scrollEdgeAppearance = appearance
                    }
                }
            }
        }
    }
    
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
                .environmentObject(SessionManager())
        }
    }
}
