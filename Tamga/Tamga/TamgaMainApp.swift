//
//  TamgaMainApp.swift
//  Tamga
//
//  Created by Erdal Toprak on 01/03/2023.
//

import Foundation
import SwiftUI

struct TamgaMainApp: View {
    
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

struct TamgaMainApp_Previews: PreviewProvider {
    static var previews: some View {
        TamgaMainApp()
            .environmentObject(SessionManager())
    }
}
