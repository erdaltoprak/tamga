//
//  NostrIDApp.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

@main
struct NostrIDApp: App {
    
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            NostrIDMainApp()
                .environmentObject(session)
                .environment(\.managedObjectContext, AppCoreData.shared.viewContext)
        }
    }
}
