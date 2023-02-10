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
            Text("Nostr.Band")
            Text("Damus.io")
            Text("ConfettiSwiftUI")
            Text("BetterSafariView")
            Text("Starscream")
            Text("NostrKit")
            Text("secp256k1")
            Text("swift-crypto")
        }
        .navigationTitle("Thanks To")
    }
}

struct ThanksToView_Previews: PreviewProvider {
    static var previews: some View {
        ThanksToView()
    }
}

