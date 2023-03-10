//
//  ThemeView.swift
//  Tamga
//
//  Created by Erdal Toprak on 10/03/2023.
//

import SwiftUI

struct ThemeView: View {
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
        List {
            Section(header: Text("Color Scheme")) {
                Button(action: { self.userSettings.preferredColorScheme = "system" }) {
                    HStack {
                        Text("System")
                        Spacer()
                        if userSettings.preferredColorScheme == "system" {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                }
                
                Button(action: { self.userSettings.preferredColorScheme = "dark" }) {
                    HStack {
                        Text("Dark")
                        Spacer()
                        if userSettings.preferredColorScheme == "dark" {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                }
                
                Button(action: { self.userSettings.preferredColorScheme = "light" }) {
                    HStack {
                        Text("Light")
                        Spacer()
                        if userSettings.preferredColorScheme == "light" {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Theme")
    }
    
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
    }
}
