//
//  NostrProfile.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject{
    
    public func retreiveProfile(){
        print("Inside function")
        NostrRelayManager.shared.retreiveFromRelay(pubkey: self.id!)
    }
    
}



