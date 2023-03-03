//
//  ContactView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import CoreData
import KeychainAccess

struct ContactView: View {
    @EnvironmentObject var session: SessionManager
    @ObservedObject var relayManager = NostrRelayManager.shared
    @ObservedObject var userSettings = UserSettings.shared
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    // Core Data
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var contactsList : FetchedResults<Profile>
    @State private var isPresented : Bool = false
    

    var body: some View {
        NavigationView{
            VStack{
                ContactListView(contactsList: contactsList, onDeletePerson: AppCoreData.shared.deletePerson)
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $isPresented, content: {
                AddContactView()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
//                        Button(action: {
//                            isPresented = true
//                        }) {
//                            Text("Add Contact")
//                            Image(systemName: "person.crop.circle.badge.plus")
//                                .resizable()
//                        }
                        Button(action: {
                            AppCoreData.shared.deleteAllDataExceptProfile()
                            NostrRelayManager.shared.forceReconnect()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                userSettings.lastContactUpdateDate = 0
                                relayManager.retreiveFromRelay(pubkey: keychain["publicHexKey"]!)
                            }
                            
                        }) {
                            Text("Pull Contacts")
                            Image(systemName: "arrow.down.circle")
                                .resizable()
                        }
//                        Button(action: {
//
//                        }) {
//                            Text("Push Contacts")
//                            Image(systemName: "arrow.up.circle")
//                                .resizable()
//                        }
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 21))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear{
                if contactsList.count > 0 && !keychain["publicHexKey"]!.isEmpty{
                    relayManager.setup()
                }
            }

        }
    }
        
        
        struct ContactView_Previews: PreviewProvider {
            static var previews: some View {
                ContactView()
            }
        }
        
        
        
        
    }
