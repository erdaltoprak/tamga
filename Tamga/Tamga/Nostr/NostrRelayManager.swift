//
//  NostrRelayManager.swift
//  Tamga
//
//  Created by Erdal Toprak on 31/01/2023.
//

import Foundation
import SwiftUI
import KeychainAccess

final class NostrRelayManager: ObservableObject {
    
    @ObservedObject var userSettings = UserSettings.shared
    static let shared = NostrRelayManager()
    @Published var relaysList = [Relay]()
    var defaultRelays = [String]()
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    private let defaults = UserDefaults.standard
    private let defaultRelaysKey = "defaultRelaysKey"

    
    private init() {}
    
    public func setup(){
        if let savedRelays = defaults.array(forKey: defaultRelaysKey) as? [String] {
            defaultRelays = savedRelays
        } else {
            defaultRelays = ["wss://relay.nostr.band"]
        }
        for relay in defaultRelays {
            var url : URL = URL(string: relay)!
            if !relaysList.contains(where: { $0.url == url }) {
                relaysList.append(Relay(url: url))
            }
            else {
                print("Relay already present, cannot add it")
            }
        }
    }
    
    public func forceReconnect(){
        for relay in relaysList{
            relay.disconnect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                relay.connect()
            }
        }
    }
    
    public func saveDefaultRelays() {
        defaults.set(defaultRelays, forKey: defaultRelaysKey)
    }
    
    public func addDefaultRelay(_ relay: String) {
        defaultRelays.append(relay)
        saveDefaultRelays()
    }
    
    public func deleteRelay(at offsets: IndexSet) {
        let relaysToDelete = offsets.map { self.relaysList[$0] }
        self.relaysList.remove(atOffsets: offsets)
        self.defaultRelays = self.defaultRelays.filter { relay in
            !relaysToDelete.contains(where: { $0.url.absoluteString == relay })
        }
        if relaysList.count == 0 {
            addDefaultRelay("wss://relay.nostr.band")
        }
        self.saveDefaultRelays()
    }
    
    public func retreiveFromRelay(pubkey: String){
        for relay in relaysList{
            if relay.connectionState == 3{
                print("RELAY ===> \(relay.url)")
                if pubkey == keychain["publicHexKey"]!{
                    let message = NostrReq.shared.createReq(pubkey: pubkey)
                    relay.sendMessage(message)
                }
                else {
                    let message = NostrReq.shared.createContactReq(pubkey: pubkey)
                    relay.sendMessage(message)
                }

            }

        }
    }
    

}
