//
//  DocumentResultView.swift
//  Document
//
//  Created by Pablo Sierra on 08/10/2025.
//

import SwiftUI
import Document

struct DocumentResultView: View {
    let result: DocumentProcessingState.Result
    let metadata: DocumentProcessingMetadata?
        
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "Version \(version) (Build \(build))"
    }

    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                switch result {
                case .success(let success):
                    SuccessView(success: success, metadata: metadata)
                case .failure(let failure):
                    FailureView(failure: failure)
                @unknown default:
                    fatalError()
                }
                Text(appVersion)
                    .font(.caption)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview("Success") {
    if case .result(let result) = DocumentProcessingState.mockSuccess {
        DocumentResultView(
            result: result,
            metadata: DocumentProcessingMetadata.mock
        )
    } else {
        DocumentResultView(
            result: .failure(
                Failure(message: "Invalid mock", component: .other, cause: nil)
            ),
            metadata: nil
        )
    }
}

#Preview("Failure") {
    if case .result(let result) = DocumentProcessingState.mockFailure {
        DocumentResultView(
            result: result,
            metadata: nil
        )
    } else {
        DocumentResultView(
            result: .failure(
                Failure(message: "Invalid mock", component: .other, cause: nil)
            ),
            metadata: nil
        )
    }
}
