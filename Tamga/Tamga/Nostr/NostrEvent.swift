//
//  NostrEvent.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import SwiftUI
import KeychainAccess

final class NostrEvent: ObservableObject {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var userSettings = UserSettings.shared
    @FetchRequest(sortDescriptors: []) private var contactsList : FetchedResults<Profile>
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    
    static let shared = NostrEvent()
    
    public init() {}
    
    public func setup(){}
    
    public func nostrResponseParse(response : String) {
        do {
            let eventResponse = try JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: [])
            print(eventResponse)
            if let response = eventResponse as? [Any] {
                let eventType = response[0]
                switch eventType as! String {
                case "EVENT":
                    print("EVENT")
                    nostrEventParse(content: eventResponse as! [Any])
                case "EOSE":
                    print("EOSE")
                case "NOTICE":
                    print("NOTICE")
                default:
                    print("OTHER")
                }
            }
            
        } catch {
            print("Error parsing JSON: \(error)")
        }
        print("========================")
    }
    
    
    private func nostrEventParse(content: [Any]){
        print("RECU CONTENT")
        if let dictionary = content[2] as? [String: Any], let kind = dictionary["kind"] as? Int {
            switch kind {
            case 0:
                print("kind 0 - profile")
                nostrEventKindZero(pubkey: (dictionary["pubkey"] as? String)! ,createdAt: (dictionary["created_at"] as? Int)!, content: (dictionary["content"] as? String)!)
            case 3:
                print("kind 3 - contacts")
                // Only the user should have to parse/add contacts
                nostrEventKindThree(pubkey: (dictionary["pubkey"] as? String)! ,createdAt: (dictionary["created_at"] as? Int)!, content: (dictionary["tags"] as? [[String]])!, relay: (dictionary["content"] as? String)!)
            case 30008:
                print("kind 30 008 - badge list")
                nostrEventKind30008(pubkey : (dictionary["pubkey"] as? String)!, content : (dictionary["tags"] as? [[String]])!)
            case 30009:
                print("kind 30 009 - badge information")
                nostrEventKind30009(pubkey : (dictionary["pubkey"] as? String)!, content : (dictionary["tags"] as? [[String]])!)
            default:
                print("kind ? - other")
            }
        }
    }
    
    // As a reminder, kind 0 is the profile information
    private func nostrEventKindZero(pubkey : String, createdAt: Int, content : String){
        print("func nostrEventKindZero")
        print(content)
        do{
            let contentProfile = try JSONSerialization.jsonObject(with: content.data(using: .utf8)!, options: [])
            print("PROFILE FUNCTION FOR KEY \(pubkey)")
            print(contentProfile)
            if let contentProfile = contentProfile as? [String: Any] {
                AppCoreData.shared.updatePerson(
                    id: pubkey,
                    lastProfileUpdate: Int32(createdAt),
                    profileName: contentProfile["display_name"] as? String ?? "",
                    profileHandle: contentProfile["name"] as? String ?? "",
                    profileDescription: contentProfile["about"] as? String ?? "",
                    profilePicture: contentProfile["picture"] as? String ?? "",
                    profileBanner: contentProfile["banner"] as? String ?? "",
                    profileWebsite: contentProfile["website"] as? String ?? "",
                    profileLud16: contentProfile["lud16"] as? String ?? "",
                    profileLud06: contentProfile["lud06"] as? String ?? "",
                    profileNip05: contentProfile["nip05"] as? String ?? ""
                )
            }

        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        
    }
    
    // As a reminder, kind 3 is the profile contacts
    // Only the app user should reach this function (for now)
    //        The tag in contents looks like this:
    //        [
    //          "p",
    //          "a3913c4e32dfc84999cdfb3e709e5af22bf2fc4b0fe080c37cc4aa70fc769ee4"
    //        ],
    // Missing feature : multiple relay fetching according to latest update
    // We use a relay archiver for the moment
    private func nostrEventKindThree(pubkey : String, createdAt: Int, content : [[String]], relay: String){
        print("inside-relay")
        print(relay)
        print("func nostrEventKindThree")
        print(content)
        print("Previous contact date \(userSettings.lastContactUpdateDate)")
            print("Adding relay list to a contact")
            print(relay)
            AppCoreData.shared.updatePersonRelay(
                id: pubkey,
                lastProfileUpdate: Int32(createdAt),
                profileRelays: relay
            )

        if pubkey == keychain["publicHexKey"]! {
            print("Only user can add contacts !")
            for tag in content {
                if let tagType = tag[0] as? String, let tagValue = tag[1] as? String {
                        print("CONTACTS ???")
                        print(content)
                        print("New contact date \(userSettings.lastContactUpdateDate)")
                        AppCoreData.shared.addPerson(id: tagValue, isOfflineProfile: false, isMainUser: false, lastProfileUpdate: Int32(createdAt), profileName: "", profileHandle: "", profileDescription: "", profilePicture: "", profileBanner: "", profileWebsite: "", profileLud16: "", profileLud06: "", profileNip05: "")
                
                    
                }
            }
        }
    }
    
    // Add a badge
    private func nostrEventKind30008(pubkey : String, content : [[String]]){
        print("func nostrEventKind30008")
        print(content)

//        if pubkey == keychain["publicHexKey"]! {
//            print("Only user can add contacts !")
            for tag in content {
                if tag[0] == "a" {
                    print("Inide Badge A Tag")
                    let badgeInformation = tag[1].split(separator: ":")

                    if let kind = badgeInformation.first, let creator = badgeInformation.dropFirst().first, let name = badgeInformation.dropFirst(2).first {
                        
                        AppCoreData.shared.addBadge(id: pubkey, badgeUniqueName: String(name), badgeCreator: String(creator))
                        
                        
                    }
                }
            }
//        }
    }
    
    // Update a badge
    private func nostrEventKind30009(pubkey : String, content : [[String]]){
        print("func nostrEventKind30009")
        print(content)
        
        var badgeUniqueName : String = ""
        var badgeDescription : String = ""
        var badgeName : String = ""
        var badgePicture : String = ""
        
//        if pubkey == keychain["publicHexKey"]! {
//            print("Only user can add contacts !")
            for tag in content {
                if let tagType = tag[0] as? String, let tagValue = tag[1] as? String {
                    print("Inide Badge Information Tag")
                    if tagType == "name" {
                        if !tagValue.isEmpty{
                            badgeName = tagValue
                        }
                    }
                    else if tagType == "description" {
                        if !tagValue.isEmpty{
                            badgeDescription = tagValue
                        }
                    }
                    else if tagType == "image" {
                        if !tagValue.isEmpty{
                            badgePicture = tagValue
                        }
                    }
                    else if tagType == "d" {
                        if !tagValue.isEmpty{
                            badgeUniqueName = tagValue
                        }
                    }
                }
            }
            
        AppCoreData.shared.updateBadge(badgeUniqueName: badgeUniqueName, badgeCreator: pubkey, badgeDescription: badgeDescription, badgeName: badgeName, badgePicture: badgePicture)
//        }
    }
    
}
