//
//  HapticsManager.swift
//  Tamga
//
//  Created by Erdal Toprak on 21/01/2023.
//

import Foundation
import UIKit
import SwiftUI

class HapticsManager {
    
    static let shared = HapticsManager()
    @ObservedObject var userSettings = UserSettings.shared
    
    
    private init() {}
    
    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
    
    
    
    //hapticNotify(.error)
    //hapticNotify(.success)
    //hapticNotify(.warning)
    func hapticNotify(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        if userSettings.hapticsEnabled {
            HapticsManager.shared.notify(notification)
        }
    }
    
    
    //hapticPlay(.heavy)
    //hapticPlay.(.light)
    //hapticPlay(.medium)
    //hapticPlay(.rigid)
    //hapticPlay(.soft)
    func hapticPlay(_ notification: UIImpactFeedbackGenerator.FeedbackStyle) {
        if userSettings.hapticsEnabled {
            HapticsManager.shared.play(notification)
        }
    }
    
}
