//
//  TamgaApp.swift
//  Tamga
//
//  Created by Erdal Toprak on 01/03/2023.
//

//import SwiftUI
//
//@main
//struct TamgaApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}


import SwiftUI

@main
struct TamgaApp: App {
    
    @StateObject private var session = SessionManager()
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some Scene {
        WindowGroup {
            TamgaMainApp()
                .environmentObject(session)
                .environment(\.managedObjectContext, AppCoreData.shared.viewContext)
                .preferredColorScheme(userSettings.colorScheme)
        }
    }
}
