//
//  NostrBadge.swift
//  Tamga
//
//  Created by Erdal Toprak on 05/03/2023.
//

import Foundation
import CoreData
import KeychainAccess

@objc(Badge)
public class Badge: NSManagedObject{
    
    public func retreiveBadge(pubkey: String){
        print("func retreiveBadge")
        NostrRelayManager.shared.retreiveBadgeFromRelay(pubkey: pubkey)
    }
    
}
