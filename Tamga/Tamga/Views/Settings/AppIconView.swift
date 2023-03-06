//
//  AppIcon.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct AppIconView: View {
    
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
            HStack(alignment: .top, spacing: 12) {
                List{
                    VStack(alignment: .leading, spacing: 10){

                        HStack{
                            Image(uiImage: .init(named: "icon1") ?? .init())
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 80, height: 80)
                              .cornerRadius(min(40, 80) / 2)

                            Text("Identity Void")
                                .padding(5)

                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            HapticsManager.shared.hapticPlay(.light)
                            userSettings.currentAppIcon = "AppIcon1"
                            UIApplication.shared.setAlternateIconName(nil)
                        }

                        Divider()

                        HStack{
                            Image(uiImage: .init(named: "icon2") ?? .init())
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 80, height: 80)
                              .cornerRadius(min(40, 80) / 2)

                            Text("Eternal Key")
                                .padding(5)

                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            HapticsManager.shared.hapticPlay(.light)
                            userSettings.currentAppIcon = "AppIcon2"
                            UIApplication.shared.setAlternateIconName(userSettings.currentAppIcon)
                        }
                        
                        Divider()
                        
                        
                    }
                }

            }
            .navigationTitle("App Icon")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(InsetGroupedListStyle())
    }
    
    struct AppIcon_Previews: PreviewProvider {
        static var previews: some View {
            AppIconView()
        }
    }
}

