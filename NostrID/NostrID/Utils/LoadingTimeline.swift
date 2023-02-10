//
//  LoadingTimeline.swift
//  NostrID
//
//  Created by Erdal Toprak on 22/01/2023.
//

import SwiftUI

struct LoadingTimeline: View {
//    let profile = NostrProfile(id: "0x123456789", lastProfileUpdate: 0, handle: "NostrID", displayName: "NostrID", description: "Welcome to NostrID 👋👋", profilePicture: "", profileBanner: "")
//    let profile2 = NostrProfile(id: "0x123456789", lastProfileUpdate: 0, handle: "NostrID", displayName: "NostrID", description: "Welcome to NostrID 👋👋", profilePicture: "", profileBanner: "")
//    let profile3 = NostrProfile(id: "0x123456789", lastProfileUpdate: 0, handle: "NostrID", displayName: "NostrID", description: "Welcome to NostrID 👋👋", profilePicture: "", profileBanner: "")
//    let profile4 = NostrProfile(id: "0x123456789", lastProfileUpdate: 0, handle: "NostrID", displayName: "NostrID", description: "Welcome to NostrID 👋👋", profilePicture: "", profileBanner: "")
//    let profile5 = NostrProfile(id: "0x123456789", lastProfileUpdate: 0, handle: "NostrID", displayName: "NostrID", description: "Welcome to NostrID 👋👋", profilePicture: "", profileBanner: "")
//    
//    var contactsList = [NostrProfile]()
    
    init() {
//        contactsList.append(profile)
//        contactsList.append(profile2)
//        contactsList.append(profile3)
//        contactsList.append(profile4)
//        contactsList.append(profile5)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
//                    ForEach(contactsList, id: \.id) { contact in
//                        HStack(alignment: .top){
//                            AsyncImage(
//                                url: URL(string: contact.profilePicture!),
//                                content: { image in
//                                    image.resizable()
//                                        .frame(maxWidth: 60, maxHeight: 60)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                },
//                                placeholder: {
//                                    Image("nostrProfile1")
//                                        .resizable()
//                                        .frame(maxWidth: 60, maxHeight: 60)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    
//                                }
//                            )
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text(contact.displayName!)
//                                    .font(.headline)
//                                Text("@\(contact.handle!)")
//                                    .font(.subheadline)
//                                Spacer(minLength: 5)
//                                Text(contact.description!)
//                                    .font(.footnote)
//                                
//                            }
//                            Spacer()
//                        }
//                        
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        
//                        
//                    }
            }
        }
    }
    
    struct LoadingTimeline_Previews: PreviewProvider {
        static var previews: some View {
            LoadingTimeline()
        }
    }
}
