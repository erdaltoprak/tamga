//
//  ContentView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI

struct NostrIDMainApp: View {
    
    @EnvironmentObject var session : SessionManager
    
    var body: some View {
        ZStack{
            switch session.currentState {
            case .loggedIn:
                HomeView()
                    .transition(.opacity)
            case .loggedOut:
                LoginView()
                    .transition(.opacity)
            case .onboarding:
                OnboardingView()
                    .transition(.opacity)
            default:
                /// Splash screen
                Color.black.ignoresSafeArea()
            }
        }
        .animation(.easeInOut, value: session.currentState)
        .onAppear(perform: session.configureCurrentState)
    }
}

struct NostrIDMainApp_Previews: PreviewProvider {
    static var previews: some View {
        NostrIDMainApp()
            .environmentObject(SessionManager())
    }
}
