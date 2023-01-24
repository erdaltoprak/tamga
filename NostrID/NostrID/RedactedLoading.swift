//
//  RedactedLoading.swift
//  NostrID
//
//  Created by Erdal Toprak on 22/01/2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
}
