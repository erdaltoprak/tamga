//
//  SessionManager.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import SwiftUI

final class SessionManager: ObservableObject {
    
    @ObservedObject var userSettings = UserSettings.shared
    
    enum CurrentState {
        case loggedIn
        case loggedOut
        case onboarding
    }
    
    @Published private(set) var currentState: CurrentState?
    
    func signIn() {
        currentState = .loggedIn
        userSettings.hasCompletedLogin = true
    }
    
    func signOut() {
        currentState = .loggedOut
        userSettings.hasCompletedLogin = false
    }
    
    func completeOnboarding() {
        currentState = .loggedOut
        userSettings.hasSeenOnboarding = true
    }
    
    func resetOnboarding() {
        currentState = .onboarding
        userSettings.hasSeenOnboarding = false
        
    }
    
    func completeLogin() {
        currentState = .loggedIn
        userSettings.hasCompletedLogin = true
    }
    
    func configureCurrentState() {
        let hasCompletedOnboarding = userSettings.hasSeenOnboarding
        let hasCompletedLogin = userSettings.hasCompletedLogin
        
        if !hasCompletedOnboarding {
            currentState = .onboarding
        } else if hasCompletedLogin {
            currentState = .loggedIn
        } else {
            currentState = .loggedOut
        }
    }
    
    
    
}

