//
//  AddContactView.swift
//  Tamga
//
//  Created by Erdal Toprak on 07/02/2023.
//

import SwiftUI

struct AddContactView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var id : String = ""
    @State private var isMainUser : Bool = false
    @State private var isOfflineProfile : Bool = false
    @State private var lastProfileUpdate : Int32 = 0
    @State private var profileName : String = ""
    @State private var profileHandle : String = ""
    @State private var profileDescription : String = ""
    @State private var profilePicture : String = ""
    @State private var profileBanner : String = ""
    
    
    
    private func save(){
        let contact = Profile(context: viewContext)
        contact.id = id
        contact.isMainUser  = isMainUser
        contact.isOfflineProfile  = isOfflineProfile
        contact.lastProfileUpdate = lastProfileUpdate
        contact.profileName = profileName
        contact.profileHandle = profileHandle
        contact.profileDescription = profileDescription
        contact.profilePicture = profilePicture
        contact.profileBanner = profileBanner
        do {
            try viewContext.save()
            contact.retreiveProfile()
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("id", text: $id)
                Toggle("isMainUser", isOn: $isMainUser)
                Toggle("isOfflineProfile", isOn: $isOfflineProfile)
                TextField("lastProfileUpdate", value: $lastProfileUpdate, formatter: NumberFormatter())
                TextField("profileName", text: $profileName)
                TextField("profileHandle", text: $profileHandle)
                TextField("profileDescription", text: $profileDescription)
                TextField("profilePicture", text: $profilePicture)
                TextField("profileBanner", text: $profileBanner)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Add", action: {
                        save()
                    })
                }
            }
        }
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView()
    }
}
