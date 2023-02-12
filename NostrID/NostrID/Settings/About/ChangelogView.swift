//
//  ChangelogView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct ChangelogView: View {
    var body: some View {
        List{
            Text("Added back the \"profile\" title in the profile tab")
            Text("Improved the profile view to include external links to check/see the nostr account")
            Text("Persistent data available offline \nSearch bar for contact \nMultiple relay management \nDamus partial integration with url schemes \nNew third icon \nPrivate key (nsec/hex) handling")
            Text("First Testflight Release")
        }
        .navigationTitle("Changelog")
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
    }
}
