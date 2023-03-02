//
//  HomeView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selection = 0
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        VStack{
            HStack{
                
                TabView(selection: $selection){
                    
                    ContactView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person.text.rectangle.fill")
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
                    
                    SettingsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "gearshape")
                                Text("Settings")
                            }
                        }
                        .tag(2)
                    
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
