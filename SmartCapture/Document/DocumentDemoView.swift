//
//  DocumentDemoView.swift
//  SmartCapture
//
//  Created by Pablo Sierra on 03/11/2025.
//

import SwiftUI
import Document

struct DocumentDemoView: View {
    @StateObject var documentSDK: DocumentSDK
    @Binding var documentResult: DocumentScannerResult?
    @Environment(\.dismiss) var dismiss
    
    init(documentResult: Binding<DocumentScannerResult?>) {
        let config = DocumentScannerConfig(
            autoCaptureToggleConfig: AutoCaptureToggleConfig.showDelayed(),
            documentSide: .front
        )
        _documentSDK = StateObject(wrappedValue: DocumentSDK(documentScannerConfig: config))
        _documentResult = documentResult
    }
    
    var body: some View {
        ZStack {
            documentSDK.mainView
        }
        // Use onReceive to observe changes
        .onReceive(documentSDK.$documentScannerResult) { newValue in
            if newValue != nil {
                dismiss()
                documentResult = newValue
            }
            
        }
    }
}

