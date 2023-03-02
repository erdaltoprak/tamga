//
//  UserSettings.swift
//  Tamga
//
//  Created by Erdal Toprak on 01/02/2023.
//

import Foundation
import SwiftUI
import KeychainAccess

class UserSettings: ObservableObject {
    
    static let shared = UserSettings()
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    private init() {}
    
    // State Settings
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("hasCompletedLogin") var hasCompletedLogin: Bool = false
    @AppStorage("currentAppIcon") var currentAppIcon: String = "AppIcon1"
    
    // User Keys
//    @AppStorage("publicHexKey") var publicHexKey: String = ""
//    @AppStorage("privateHexKey") var privateHexKey: String = ""
//    @AppStorage("publicNpubKey") var publicNpubKey: String = ""
//    @AppStorage("privateNsecKey") var privateNsecKey: String = ""
    @AppStorage("lastContactUpdateDate") var lastContactUpdateDate: Int = 0
    

    // About App Links
    @AppStorage("erdalNpub") var erdalNpub: String = "npub15wgncn3jmlyynxwdlvl8p8j67g4l9lztplsgpsmucj48plrknmjqeyx2t2"
    @AppStorage("tamgaNpub") var tamgaNpub: String = "npub15mlge99zsy0jqhe2zx3sp24tmuuuktcvg86vxdnjhaqvysyyjc3s4jf28p"
    @AppStorage("erdalTwitter") var erdalTwitter: String = "ErdalxToprak"
    @AppStorage("moreNostrInfo") var moreNostrInfo: String = "https://nostr.how"
    @AppStorage("nostrband") var nostrband: String = "https://nostr.band"
    
    // QoL Settings
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = true
    
    
//    func reset(){
//        publicHexKey = ""
//        privateHexKey = ""
//        publicNpubKey = ""
//        privateNsecKey = ""
//        NostrEvent.shared.profile = NostrProfile(id: "", lastProfileUpdate: 0, handle: "", displayName: "", description: "", profilePicture: "", profileBanner: "")
//        NostrEvent.shared.contacts.removeAll()
//        NostrManager.shared.relaysList.removeAll()
//        NostrManager.shared.defaultRelays.removeAll()
//        
//        for relay in NostrManager.shared.relaysList {
//            relay.disconnect()
//        }
//        
//    }
    
}


