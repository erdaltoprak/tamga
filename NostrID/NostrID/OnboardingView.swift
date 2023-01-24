//
//  OnboardingView.swift
//  NostrID
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import UIKit


struct OnboardingView: View {
    
    @AppStorage(UserDefaultKeys.hapticsEnabled) private var isHapticsEnabled: Bool = false
    @StateObject private var manager = OnboardingManager()
    @State private var showBtn = false
    @State private var animateGradient = true
    @EnvironmentObject var session: SessionManager
    
    var backgroundView: some View {
        LinearGradient(colors: [.purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            .hueRotation(.degrees(animateGradient ? 45 : 0))
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
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
                                            isHapticsEnabled = true
                                            
                                        }
                                    }
                                }
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .overlay(alignment: .bottom) {
                                    if showBtn {
                                        
                                        VStack{
                                            Button(action: {
                                                UIApplication.shared.open(URL(string: "\(UserDefaultKeys.moreNostrInfo)")!)
                                            }) {
                                                Text("Learn more")
                                            }
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .frame(width: 150, height: 50)
                                            .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .offset(y: 50)
                                            .transition(.scale.combined(with: .opacity))
                                            
                                            
                                            Button("Continue") {
    //                                            action()
                                                session.completeOnboarding()
                                                hapticPlay(.light)
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


