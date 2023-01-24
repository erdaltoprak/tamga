//
//  SessionManager.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import SwiftUI

final class SessionManager: ObservableObject {
    
    @AppStorage("publicKey") var publicKey : String?
    
    enum CurrentState {
        case loggedIn
        case loggedOut
        case onboarding
    }
    
    @Published private(set) var currentState: CurrentState?
    
    func signIn() {
        currentState = .loggedIn
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasCompletedLogin)
    }
    
    func signOut() {
        currentState = .loggedOut
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.hasCompletedLogin)
    }
    
    func completeOnboarding() {
        currentState = .loggedOut
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasSeenOnboarding)
    }
    
    func resetOnboarding() {
        currentState = .onboarding
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.hasSeenOnboarding)

    }
    
    func completeLogin() {
        if !publicKey!.isEmpty{
            currentState = .loggedIn
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasCompletedLogin)
        }
        else {
            publicKey = "a3913c4e32dfc84999cdfb3e709e5af22bf2fc4b0fe080c37cc4aa70fc769ee4"
            currentState = .loggedIn
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasCompletedLogin)
        }
    }
    
    func configureCurrentState() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: UserDefaultKeys.hasSeenOnboarding)
        let hasCompletedLogin = UserDefaults.standard.bool(forKey: UserDefaultKeys.hasCompletedLogin)

        if !hasCompletedOnboarding {
            currentState = .onboarding
        } else if hasCompletedLogin {
            currentState = .loggedIn
        } else {
            currentState = .loggedOut
        }
    }

    
    
}

