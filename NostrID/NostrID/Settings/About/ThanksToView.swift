//
//  ThanksToView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct ThanksToView: View {
    var body: some View {
        List{
            Text("Nostr")
            Text("Damus.io")
            Text("ConfettiSwiftUI")
            Text("Starscream")
        }
        .navigationTitle("Thanks To")
    }
}

struct ThanksToView_Previews: PreviewProvider {
    static var previews: some View {
        ThanksToView()
    }
}

