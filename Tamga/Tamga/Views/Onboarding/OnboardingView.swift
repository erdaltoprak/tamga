//
//  OnboardingView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import UIKit
import FluidGradient

struct OnboardingView: View {
    
    @StateObject private var manager = OnboardingManager()
    @ObservedObject var userSettings = UserSettings.shared
    @State private var showBtn = false
    @State private var animateGradient = true
    @State var showSafari = false
    @EnvironmentObject var session: SessionManager
    
    var backgroundView: some View {
        FluidGradient(blobs: [.red, .teal, .indigo],
                      highlights: [.orange, .red, .indigo],
                      speed: 0.7,
                      blur: 0.75)
          .background(.quaternary)
          .edgesIgnoringSafeArea(.all)
    }
    
    var body: some View {
            ZStack {
                if !manager.items.isEmpty {
                    
                    TabView {
                        
                        ForEach(manager.items) { item in
                            OnboardingInfoView(item: item)
                                .onDisappear() {
                                    if item == manager.items.first{
                                        withAnimation(.spring().delay(0.25)) {
                                            showBtn = true
                                            
                                        }
                                    }
                                }
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .overlay(alignment: .bottom) {
                                    if showBtn {
                                        
                                        VStack{
//                                            Button(action: {
//                                                self.showSafari = true
//                                                HapticsManager.shared.hapticPlay(.light)
//                                            }) {
//                                                Text("Learn more")
//                                            }
//                                            .font(.system(size: 20, weight: .bold, design: .rounded))
//                                            .frame(width: 150, height: 50)
//                                            .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
//                                            .offset(y: 50)
//                                            .transition(.scale.combined(with: .opacity))
//                                            .safariView(isPresented: $showSafari) {
//                                                SafariView(
//                                                    url: URL(string: userSettings.moreNostrInfo)!,
//                                                    configuration: SafariView.Configuration(
//                                                        entersReaderIfAvailable: false,
//                                                        barCollapsingEnabled: true
//                                                    )
//                                                )
//                                                .preferredBarAccentColor(.clear)
//                                                .preferredControlAccentColor(.accentColor)
//                                                .dismissButtonStyle(.done)
//                                            }
                                            
                                            
                                            
                                            Button("Continue") {
                                                session.completeOnboarding()
                                                HapticsManager.shared.hapticNotify(.success)
                                            }
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .frame(width: 150, height: 50)
                                            .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .offset(y: 50)
                                            .transition(.scale.combined(with: .opacity))
                                        }
                                        

                                        
                                    }
                                }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
            }
            .onAppear(perform: manager.load)
            .background(backgroundView)
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(SessionManager())
    }
}


