//
//  ThanksToView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct ThanksToView: View {
    var body: some View {
        List{
            Text("Nostr")
            Text("Nostr.Band")
            Text("Damus")
            Text("ConfettiSwiftUI")
            Text("Starscream")
            Text("Secp256k1")
            Text("FluidGradient")
            Text("KeychainAccess")
            Text("CodeScanner")
        }
        .navigationTitle("Thanks To")
    }
}

struct ThanksToView_Previews: PreviewProvider {
    static var previews: some View {
        ThanksToView()
    }
}

