//
//  ContactListView.swift
//  NostrID
//
//  Created by Erdal Toprak on 07/02/2023.
//

import SwiftUI

struct ContactListView: View {
    
    @ObservedObject var userSettings = UserSettings.shared
    @State private var searchText = ""
    
    let contactsList : FetchedResults<Profile>
    let onDeletePerson: (Profile) -> Void
    
    var body: some View {
        ScrollView{
            ForEach(contactsList){ contact in
                if contact.id != userSettings.publicHexKey {
                    NavigationLink(destination: ProfileDetailView(profile: contact, isProfileTab: false)){
                        HStack(alignment: .top){
                            
                            
                            AsyncImage(
                                url: URL(string: contact.profilePicture!),
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
                                Text(contact.profileDescription ?? "Description")
                                    .font(.subheadline)
                                Spacer(minLength: 5)
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