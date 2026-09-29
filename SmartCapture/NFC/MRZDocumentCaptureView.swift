//
//  MRZDocumentCaptureView.swift
//  SmartCapture
//

import SwiftUI
import Document

struct MRZDocumentCaptureView: View {
    @StateObject private var documentSDK: DocumentSDK
    let onCaptured: (DocumentScannerResult) -> Void

    init(onCaptured: @escaping (DocumentScannerResult) -> Void) {
        let config = DocumentScannerConfig(
            autoCaptureToggleConfig: AutoCaptureToggleConfig.showDelayed(),
            documentSide: .front,
            documentType: .passport,
            mrzRequired: true
        )
        _documentSDK = StateObject(wrappedValue: DocumentSDK(documentScannerConfig: config))
        self.onCaptured = onCaptured
    }

    var body: some View {
        ZStack {
            documentSDK.mainView
        }
        .onReceive(documentSDK.$documentScannerResult) { newValue in
            if let newValue {
                onCaptured(newValue)
            }
        }
    }
}
