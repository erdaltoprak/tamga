//
//  AppCoreData.swift
//  Tamga
//
//  Created by Erdal Toprak on 07/02/2023.
//

import Foundation
import CoreData
import KeychainAccess

class AppCoreData{
    
    static let shared = AppCoreData()
    private var persistentContainer: NSPersistentContainer
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "AppCoreData")
        
        persistentContainer.loadPersistentStores{description, error in
            if let error{
                fatalError("Unable to init core data stack: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPerson(withID id: String) -> Profile? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let person = try context.fetch(fetchRequest).first
            return person
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
            return nil
        }
    }
    
    public func addPerson(id: String, isOfflineProfile: Bool, isMainUser: Bool, lastProfileUpdate: Int32, profileName: String, profileHandle: String, profileDescription: String, profilePicture: String, profileBanner: String, profileWebsite: String, profileLud16: String, profileLud06: String,  profileNip05: String){
        if fetchPerson(withID: id) == nil{
            let contact = Profile(context: viewContext)
            contact.id = id
            contact.isOfflineProfile = isOfflineProfile
            contact.isMainUser = isMainUser
            contact.lastProfileUpdate = Int32(lastProfileUpdate)
            contact.profileName = profileName
            contact.profileHandle = profileHandle
            contact.profileDescription = profileDescription
            contact.profilePicture = profilePicture
            contact.profileBanner = profileBanner
            contact.profileWebsite = profileWebsite
            contact.profileLud16 = profileLud16
            contact.profileLud06 = profileLud06
            contact.profileNip05 = profileNip05
//            contact.profileRelays = profileRelays
            viewContext.insert(contact)
            do {
                try viewContext.save()
                contact.retreiveProfile()
            } catch {
                viewContext.rollback()
                print(error.localizedDescription)
            }
        }
    }
    
    public func updatePerson(id: String, lastProfileUpdate: Int32, profileName: String, profileHandle: String, profileDescription: String, profilePicture: String, profileBanner: String, profileWebsite: String, profileLud16: String, profileLud06: String, profileNip05: String){
//        let contact = fetchPerson(withID: id)
        if let contact = fetchPerson(withID: id) {
            contact.lastProfileUpdate = Int32(lastProfileUpdate)
            contact.profileName = profileName
            contact.profileHandle = profileHandle
            contact.profileDescription = profileDescription
            contact.profilePicture = profilePicture
            contact.profileBanner = profileBanner
            contact.profileWebsite = profileWebsite
            contact.profileLud16 = profileLud16
            contact.profileLud06 = profileLud06
            contact.profileNip05 = profileNip05
//            contact.profileRelays = profileRelays
            do {
                if viewContext.hasChanges{
                    try viewContext.save()
                }
            } catch {
                viewContext.rollback()
                print(error)
            }
        }
    }
    
    public func updatePersonRelay(id: String, lastProfileUpdate: Int32, profileRelays: String){
//        let contact = fetchPerson(withID: id)
        if let contact = fetchPerson(withID: id) {
            contact.lastProfileUpdate = Int32(lastProfileUpdate)
            contact.profileRelays = profileRelays
            do {
                if viewContext.hasChanges{
                    try viewContext.save()
                }
            } catch {
                viewContext.rollback()
                print(error)
            }
        }
    }
    
    // Delete in nostrEvent function
    public func removePerson(id: String) {
//        let contact = fetchPerson(withID: id)
        if let contact = fetchPerson(withID: id) {
            viewContext.delete(contact)
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print(error)
            }
        }
    }
    
    // Delete in a view
    public func deletePerson(person: Profile) {
        
        viewContext.delete(person)
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error)
        }
    }
    
    public func deleteAllData(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Profile.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? viewContext.execute(batchDeleteRequest)
        do {
            try viewContext.save()
            keychain["privateNsecKey"] = nil
            keychain["publicNpubKey"] = nil
            keychain["privateHexKey"] = nil
            keychain["publicHexKey"] = nil
        } catch {
            viewContext.rollback()
            print("public func deleteAllData()")
            print(error)
        }
    }
    
//    public func deleteAllData2(){
//        let fetchRequest = Profile.fetchRequest()
//        let profiles = try? viewContext.fetch(fetchRequest)
//        for profile in profiles ?? [] {
//            viewContext.delete(profile)
//        }
//        do {
//            try viewContext.save()
//            print("public func deleteAllData()")
//        } catch {
//            viewContext.rollback()
//            print(error)
//        }
//    }
    
    public func deleteAllDataExceptProfile(){
        let fetchRequest = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id != %@", keychain["publicHexKey"]!)
        let profiles = try? viewContext.fetch(fetchRequest)
        for profile in profiles ?? [] {
            if profile.isMainUser == false{
                viewContext.delete(profile)
            }
        }
        do {
            try viewContext.save()
            print("func deleteAllDataExceptProfile()")
        } catch {
            viewContext.rollback()
            print(error)
        }
    }
    
    public func deleteAllBadgeData(){
        let fetchRequest = Badge.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id != %@", keychain["publicHexKey"]!)
        let badges = try? viewContext.fetch(fetchRequest)
        for badge in badges ?? [] {
                viewContext.delete(badge)
        }
        do {
            try viewContext.save()
            print("func deleteAllBadgeData")
        } catch {
            viewContext.rollback()
            print("func rollback deleteAllBadgeData")
            print(error)
        }
    }
    
    // ===============================
    // Badges
    
    // badge owner perspective
    func fetchBadges(withID id: String, badgeUniqueName: String, badgeCreator: String) -> Badge? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Badge>(entityName: "Badge")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND badgeUniqueName == %@ AND badgeCreator == %@", id, badgeUniqueName, badgeCreator)
        
        do {
            let badge = try context.fetch(fetchRequest).first
            return badge
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
            return nil
        }
    }

    
    public func addBadge(id: String, badgeUniqueName: String, badgeCreator: String){
        print("func addBadge")
        if fetchBadges(withID: id, badgeUniqueName: badgeUniqueName, badgeCreator: badgeCreator) == nil{
            let badge = Badge(context: viewContext)
            badge.id = id
            badge.badgeCreator = badgeCreator
            badge.badgeUniqueName = badgeUniqueName
            viewContext.insert(badge)
//            badge.retreiveBadge(pubkey: badgeCreator)
            do {
                try viewContext.save()
                badge.retreiveBadge(pubkey: badgeCreator)
            } catch {
                viewContext.rollback()
                print(error.localizedDescription)
            }
        }
    }
    
    // badge creator perspective (to update the information of all badge holders from a creator / bage-name)
    public func updateBadge(badgeUniqueName: String, badgeCreator: String, badgeDescription: String, badgeName: String, badgePicture: String){
        print("func updateBadge")
        let fetchRequest = NSFetchRequest<Badge>(entityName: "Badge")
        let context = persistentContainer.viewContext
        do {
            let objects = try context.fetch(fetchRequest)
            
            for object in objects {
                print(object)
                if object.badgeUniqueName == badgeUniqueName && object.badgeCreator == badgeCreator {
                    print("badgeUniqueName")
                    object.badgeName = badgeName
                    object.badgeDescription = badgeDescription
                    object.badgePicture = badgePicture
                }
            }
            if viewContext.hasChanges{
                try viewContext.save()
            }
        } catch {
            viewContext.rollback()
            print(error)
        }
        
    
        
    }

    
    
    // ===============================
    
    var viewContext: NSManagedObjectContext{
        persistentContainer.viewContext
    }
}
