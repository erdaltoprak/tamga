//
//  NostrManager.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import Starscream
import SwiftUI

// A Nostr Response is a list of Nostr Event
// The NostrManager queries (Nostr Events) the user profile once (except refresh) to gather all the data related to tag p (for following aka "Contacts") and user profile info
// The NostrManager instanciates the Websocket


final class NostrManager: ObservableObject {
    
    @AppStorage(UserDefaultKeys.publicKey) var publicKey: String!
    @AppStorage(UserDefaultKeys.relay) var relay: String!
    let timeout: TimeInterval = 10
    static let shared = NostrManager()
    
    private init() {}
    
    func setup() {
        let start = Date()
        print("===================")
        print("NOSTRMANAGER CHECKS")
        print(publicKey!)
        print(relay!)
        print("===================")
        print("CONNECT WEBSOCKET")
        WebSocketManager.shared.connect()
        print("===================")

    }
    
    func release(){
        print("===================")
        print("RELEASE RELAY")
        WebSocketManager.shared.disconnect()
    }
}
