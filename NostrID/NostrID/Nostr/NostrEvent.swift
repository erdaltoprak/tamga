//
//  NostrEvent.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import SwiftUI


final class NostrEvent: ObservableObject {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var userSettings = UserSettings.shared
    @FetchRequest(sortDescriptors: []) private var contactsList : FetchedResults<Profile>
    
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
                nostrEventKindThree(pubkey: (dictionary["pubkey"] as? String)! ,createdAt: (dictionary["created_at"] as? Int)!, content: (dictionary["tags"] as? [[String]])!)
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
                AppCoreData.shared.updatePerson(id: pubkey, lastProfileUpdate: Int32(createdAt), profileName: contentProfile["display_name"] as? String ?? "", profileHandle: contentProfile["name"] as? String ?? "", profileDescription: contentProfile["about"] as? String ?? "", profilePicture: contentProfile["picture"] as? String ?? "", profileBanner: contentProfile["banner"] as? String ?? "")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        
    }
    
    // As a reminder, kind 3 is the profile contacts
    // Only the app user should reach this function
    //        The tag in contents looks like this:
    //        [
    //          "p",
    //          "a3913c4e32dfc84999cdfb3e709e5af22bf2fc4b0fe080c37cc4aa70fc769ee4"
    //        ],
    private func nostrEventKindThree(pubkey : String, createdAt: Int, content : [[String]]){
        print("func nostrEventKindThree")
        print(content)
        print("Previous contact date \(userSettings.lastContactUpdateDate)")
        for tag in content {
            if let tagType = tag[0] as? String, let tagValue = tag[1] as? String {
                if createdAt >= userSettings.lastContactUpdateDate {
                    userSettings.lastContactUpdateDate = createdAt
//                    if contactsList.count > 1 {}
                    print("New contact date \(userSettings.lastContactUpdateDate)")
                    AppCoreData.shared.addPerson(id: tagValue, isOfflineProfile: false, isMainUser: false, lastProfileUpdate: Int32(createdAt), profileName: "", profileHandle: "", profileDescription: "", profilePicture: "", profileBanner: "")
                }
            }
        }
    }
}
