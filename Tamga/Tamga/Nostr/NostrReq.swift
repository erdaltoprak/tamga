//
//  NostrReq.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import SwiftUI
import KeychainAccess

struct NostrReq {
//    @ObservedObject var userSettings = UserSettings.shared
    
    static let shared = NostrReq()
    private init() {}
    
    func createReq(pubkey: String) -> String {
        let req =
        """
        [
          "REQ",
          "\(UUID())",
          {
            "kinds": [
              0,3,30008
            ],
            "authors": [
              "\(pubkey)"
            ]
          }
        ]
        """
        return req
    }
    
    func createContactReq(pubkey: String) -> String {
        let req =
        """
        [
          "REQ",
          "\(UUID())",
          {
            "kinds": [
              0
            ],
            "authors": [
              "\(pubkey)"
            ]
          }
        ]
        """
        return req
    }
    
    // Badge informations from creator
    func createBadgeReq(pubkey: String) -> String {
        print("func createBadgeReq")
        let req =
        """
        [
          "REQ",
          "\(UUID())",
          {
            "kinds": [
              30009
            ],
            "authors": [
              "\(pubkey)"
            ]
          }
        ]
        """
        return req
    }
    
    // Badge list from user
    func createRetreiveBadgeReq(pubkey: String) -> String {
        print("func createBadgeReq")
        let req =
        """
        [
          "REQ",
          "\(UUID())",
          {
            "kinds": [
              30008
            ],
            "authors": [
              "\(pubkey)"
            ]
          }
        ]
        """
        return req
    }

    
}
