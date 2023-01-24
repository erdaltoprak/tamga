//
//  NostrReq.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import SwiftUI

struct NostrReq {
    @AppStorage(UserDefaultKeys.publicKey) var publicKey: String?
    
    static let shared = NostrReq()
    private init() {}
    
    func createReq() -> String {
        let req =
        """
        [
          "REQ",
          "\(UUID())",
          {
            "kinds": [
              0,3
            ],
            "authors": [
              "\(publicKey ?? "")"
            ]
          }
        ]
        """
        return req
    }
    
}
