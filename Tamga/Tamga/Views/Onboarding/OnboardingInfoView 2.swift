//
//  OnboardingInfoView.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import SwiftUI
import ConfettiSwiftUI

struct OnboardingInfoView: View {
    
    let item: OnboardingItem
    @State private var counter = 0
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text(item.emoji)
                .font(.system(size: 150))
                .confettiCannon(counter: $counter, repetitions: 3, repetitionInterval: 0.7)
            
            Text(item.title)
                .font(.system(size: 35,
                              weight: .heavy,
                              design: .rounded))
                .padding(.bottom, 12)
            
            Text(item.content)
                .font(.system(size: 18,
                              weight: .light,
                              design: .rounded))
            
        }
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .padding()
        .onAppear{
            if counter < 1{
                self.counter += 1
            }
        }
    }
}

struct OnboardingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingInfoView(item: .init(emoji: "👋",
                                       title: "Hello World",
                                       content: "Hello World!"))
        .previewLayout(.sizeThatFits)
        .background(.blue)
    }
}
