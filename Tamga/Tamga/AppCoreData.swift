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
        } catch {
            viewContext.rollback()
            print("public func deleteAllData()")
            print(error)
        }
    }
    
    public func deleteAllData2(){
        let fetchRequest = Profile.fetchRequest()
        let profiles = try? viewContext.fetch(fetchRequest)
        for profile in profiles ?? [] {
            viewContext.delete(profile)
        }
        do {
            try viewContext.save()
            print("public func deleteAllData()")
        } catch {
            viewContext.rollback()
            print(error)
        }
    }
    
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
            print("public func deleteAllData()")
        } catch {
            viewContext.rollback()
            print(error)
        }
    }

    
    var viewContext: NSManagedObjectContext{
        persistentContainer.viewContext
    }
}
