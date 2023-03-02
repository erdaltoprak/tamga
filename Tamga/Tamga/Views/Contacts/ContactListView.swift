//
//  ContactListView.swift
//  Tamga
//
//  Created by Erdal Toprak on 07/02/2023.
//

import SwiftUI
import KeychainAccess

struct ContactListView: View {
    
    @ObservedObject var userSettings = UserSettings.shared
    @State private var searchText = ""
    let keychain = Keychain(service: "com.erdaltoprak.tamga")
    let contactsList : FetchedResults<Profile>
    let onDeletePerson: (Profile) -> Void
    
    var body: some View {
        ScrollView{
            ForEach(contactsList){ contact in
                if contact.id != keychain["publicHexKey"]! {
                    NavigationLink(destination: ContactDetailView(profile: contact, isProfileTab: false)){
                        HStack(alignment: .top){
                            
                            
                            AsyncImage(
                                url: URL(string: contact.profilePicture ?? ""),
                                content: { image in
                                    image.resizable()
                                        .frame(maxWidth: 60, maxHeight: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.black))
                                },
                                placeholder: {
                                    Image("nostrProfile1")
                                        .resizable()
                                        .frame(maxWidth: 60, maxHeight: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.black))
                                    
                                }
                            )
                            
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("@\(contact.profileHandle ?? "Handle")")
                                    .font(.headline)
                                    .background(contact.isOfflineProfile ? Color.blue : nil)
                                Text(contact.profileName ?? "DisplayName")
                                    .font(.subheadline)
                                HStack {
                                    let contactNpub = NostrKey.shared.bech32_pubkey(contact.id  ?? "")
                                    Image(systemName: "key")
                                        .font(.system(size: 12))
                                    Text(String(contactNpub?.prefix(10) ?? "") + "..." + String(contactNpub?.suffix(10) ?? ""))
                                        .font(.system(size: 12))
                                }
                                Spacer(minLength: 5)
//                                Divider()
                            }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .padding()
                        .frame(maxWidth: .infinity)
            
                    }
                }
                else if contactsList.count == 1 && searchText.isEmpty{
                    Text("Refresh to fetch your contacts,")
                    Text("or change your search request!")
                }
            }
            .onDelete{ indexSet in
                indexSet.map{contactsList[$0]}.forEach(onDeletePerson)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
        .navigationTitle("\(contactsList.count-1) Contacts")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search by @handle"))
        .disableAutocorrection(true)
        .onChange(of: searchText){ newValue in
            var filteredNewValue = newValue.replacingOccurrences(of: "@", with: "")
            filteredNewValue = filteredNewValue.trimmingCharacters(in: .whitespacesAndNewlines)
            contactsList.nsPredicate = filteredNewValue.isEmpty ? nil : NSPredicate(format: "profileHandle CONTAINS[c] %@", filteredNewValue)
        }
        
        
    }
}
