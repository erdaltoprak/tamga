//
//  ChangelogView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct ChangelogView: View {
    var body: some View {
        List{
            Section{
                Text("🆕 1.0 (build 7)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Added login with QR Code")
                Text("Added generate private key QR Code")
                Text("Added dark mode toggle")
            }
            
            Section{
                Text("🆕 1.0 (build 5)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Fixed login key checks")
                Text("Added Tamga help links")
                Text("Added Badge view")
            }
            
            Section{
                Text("1.0 (build 4)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("List of the current features:")
                Text("easy onboarding")
                Text("nsec key conversion")
                Text("key storage in keychain")
                Text("contacts saved offline")
                Text("contacts list and detailed view")
                Text("contacts search by handle")
                Text("qr code generation for contacts")
                Text("contact quick actions submenu in toolbar")
                
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Changelog")
        
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
    }
}
