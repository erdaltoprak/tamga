//
//  NostrProfile.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation


class NostrProfile : Identifiable, ObservableObject{
    @Published var id: String
    @Published var handle: String?
    @Published var displayName: String?
    @Published var description: String?
    @Published var profilePicture: String?
    @Published var profileBanner: String?

    init(id: String, handle: String?, displayName: String?, description: String?, profilePicture: String?, profileBanner: String?) {
        self.id = id
        self.handle = handle ?? ""
        self.displayName = displayName ?? ""
        self.description = description ?? ""
        self.profilePicture = profilePicture ?? ""
        self.profileBanner = profileBanner ?? ""
    }

}
