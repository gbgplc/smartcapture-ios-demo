//
//  AsyncButton.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 17/04/26.
//

import Foundation
import SwiftUI

struct AsyncButton<Label: View>: View {
    var action: () async throws -> Void
    @ViewBuilder var label: () -> Label

    @State private var isPerformingTask = false

    var body: some View {
        Button(
            action: {
                isPerformingTask = true

                Task { @MainActor in
                    defer { isPerformingTask = false }
                    do {
                        try await action()
                    } catch {
                        // Surface the error so failures aren't silently ignored.
                        print("AsyncButton action failed: \(error)")
                    }
                }
            },
            label: {
                ZStack {
                    // We hide the label by setting its opacity
                    // to zero, since we don't want the button's
                    // size to change while its task is performed:
                    label().opacity(isPerformingTask ? 0 : 1)

                    if isPerformingTask {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isPerformingTask)
    }
}

extension AsyncButton where Label == Text {
    
    init(_ label: String, action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(label)
        }
    }
    
    init(_ label: Text, action: @escaping () async -> Void) {
        self.init(action: action) {
            label
        }
    }
    
}
