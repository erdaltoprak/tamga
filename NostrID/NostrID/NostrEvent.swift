//
//  NostrEvent.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation


final class NostrEvent: ObservableObject {
    
    @Published var contacts = [NostrProfile]()
    @Published var profile : NostrProfile
    @Published var isReady = false
    
    static let shared = NostrEvent()
    
    private init() {
        
        profile = NostrProfile(id: "", handle: "", displayName: "", description: "", profilePicture: "", profileBanner: "")
        
    }
    
    
    
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
                    NostrManager.shared.release()
                case "NOTICE":
                    print("NOTICE")
                default:
                    print("SOMETHING ELSE???")
                }
            }
            
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        print("============END============")
    }
    
    
    private func nostrEventParse(content: [Any]){
        print("RECU CONTENT")
        
        if let dictionary = content[2] as? [String: Any], let kind = dictionary["kind"] as? Int {
            switch kind {
            case 0:
                print("kind 0 - profile")
                nostrEventKindZero(pubkey: (dictionary["pubkey"] as? String)! ,content: (dictionary["content"] as? String)!)
            case 3:
                print("kind 3 - contacts")
                nostrEventKindThree(pubkey: (dictionary["pubkey"] as? String)! ,content: (dictionary["tags"] as? [[String]])!)
            default:
                print("kind ? - other")
            }
        }
    }
    
    private func nostrEventKindZero(pubkey : String, content : String){
        do{
            let contentProfile = try JSONSerialization.jsonObject(with: content.data(using: .utf8)!, options: [])
            print("PROFILE")
            print(contentProfile)
            if let contentProfile = contentProfile as? [String: Any] {
                
                profile = NostrProfile(id: pubkey, handle: contentProfile["name"] as? String ?? "", displayName: contentProfile["display_name"] as? String ?? "", description: contentProfile["about"] as? String ?? "", profilePicture: contentProfile["picture"] as? String ?? "", profileBanner: contentProfile["banner"] as? String ?? "")
                
                isReady = true
                
            }
            
            
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
    
    private func nostrEventKindThree(pubkey : String, content : [[String]]){
        do{
            print("CONTACTS")
            print(content)
            for tag in content {
                if let tagType = tag[0] as? String, let tagValue = tag[1] as? String {
                    let contact = NostrProfile(id: tagValue, handle: nil, displayName: nil, description: nil, profilePicture: nil, profileBanner: nil)
                    contacts.append(contact)
                }
            }
            
            
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        
    }
    
    
    
}
