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
    @AppStorage("lastContactUpdateDate") var lastContactUpdateDate: Int = 0
    

    // Links
    @AppStorage("erdalNpub") var erdalNpub: String = "npub15wgncn3jmlyynxwdlvl8p8j67g4l9lztplsgpsmucj48plrknmjqeyx2t2"
    @AppStorage("tamgaNpub") var tamgaNpub: String = "npub15mlge99zsy0jqhe2zx3sp24tmuuuktcvg86vxdnjhaqvysyyjc3s4jf28p"
    @AppStorage("erdalTwitter") var erdalTwitter: String = "ErdalxToprak"
    @AppStorage("moreNostrInfo") var moreNostrInfo: String = "https://nostr.how"
    @AppStorage("nostrband") var nostrband: String = "https://nostr.band"
    @AppStorage("tamgaHelp") var tamgaHelp: String = "https://tamga.pages.dev/help/"
    @AppStorage("nostrBadges") var nostrBadges: String = "https://badges.page/p/"
    
    // QoL Settings
    @AppStorage("currentAppIcon") var currentAppIcon: String = "AppIcon1"
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = true
    @AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
    
    
}

extension UserSettings {
    var colorScheme: ColorScheme? {
        switch preferredColorScheme {
        case "dark":
            return .dark
        case "light":
            return .light
        default:
            return nil
        }
    }
}

