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
