//
//  HomeView.swift
//  NostrID
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
                            }
                        }
                        .tag(0)
                    
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person.fill")
                            }
                        }
                        .tag(1)
                    
                    SettingsView()
                        .tabItem {
                            VStack {
                                Image(systemName: "gearshape")
                            }
                        }
                        .tag(2)
                    
                }
                .onChange(of: selection) { value in
                    hapticPlay(.light)
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
