//
//  OnboardingManager.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let content: String
}

extension OnboardingItem: Equatable {}

final class OnboardingManager: ObservableObject {
    
    @Published private(set) var items: [OnboardingItem] = []
    
    func load() {
        items = [
            .init(emoji: "👋",
                  title: "Welcome to NostrID",
                  content: "NostrID is a nostr client that allows you to manage your followings, profile and much more. \n\n Nostr (Notes and Other Stuff Transmitted by Relays) is an open protocol that is able to create a censorship-resistant global \"social\" network once and for all. \n\n"),
            .init(emoji: "❤️",
                  title: "Support the project",
                  content: "The nostr initiative is still in active development and evolving everyday. \n\n If you want to contribute you can join the repository at github.com/nostr-protocol/ \n\n\n\n")
        ]
    }
}
