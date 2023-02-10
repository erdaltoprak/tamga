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
            Text("Persistent data available offline \n Search bar for contact \n Multiple relay management \n Damus partial integration with url schemes \n New third icon \n Private key (nsec/hex) handling")
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
