//
//  FailureView.swift
//  SmartCapture
//
//  Created by Pablo Sierra on 04/11/2025.
//

import SwiftUI
import Document

struct FailureView: View {
    let failure: Failure

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "xmark.octagon.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 40))
                Text("Capture Failed")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Message: \(failure.message)")
                    .font(.body)
                Text("Component: \(failure.component.localizedDescription)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if let cause = failure.cause {
                    Text("Cause: \(cause.localizedDescription)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

#Preview {
    FailureView(failure: Failure(message: "Failure preview", component: .other, cause: nil))
}
