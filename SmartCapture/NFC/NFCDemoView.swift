//
//  NFCDemoView.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 14/04/26.
//

import SwiftUI
import Document
import OzoneNFC

struct NFCDemoView: View {
    private enum Step {
        case capture
        case confirm(DocumentScannerResult, mrz: MRZData)
        case scan(OzoneNFCDocumentKey, scanResult: DocumentScannerResult, mrz: MRZData)
        case result(OzoneNFCDocument?)
    }

    @State private var step: Step = .capture
    @State private var captureAttempt = 0

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Group {
                switch step {
                case .capture:
                    MRZDocumentCaptureView(onCaptured: handleCaptured)
                        .id(captureAttempt)
                case .confirm(let scanResult, let mrz):
                    DocumentResultView(result: scanResult.result, metadata: scanResult.metadata) {
                        VStack(spacing: 12) {
                            Button(action: retake) {
                                actionLabel(title: String(localized: "Retake", comment: "Button title to retake the document photo"), systemImage: "arrow.counterclockwise", isProminent: false)
                            }
                            Button(action: { startScan(with: scanResult, mrz: mrz) }) {
                                actionLabel(title: String(localized: "Start NFC scan", comment: "Button title to start the NFC scan using the read MRZ data"), systemImage: "wave.3.right", isProminent: true)
                            }
                        }
                    }
                case .scan(let documentKey, let scanResult, let mrz):
                    OzoneNFCSwiftUIWrapper(documentKey: documentKey) { result in
                        onScanFinished(result, scanResult: scanResult, mrz: mrz)
                    }
                case .result(let passport):
                    NFCResultView(passport: passport)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if case .confirm(let scanResult, let mrz) = step {
                        Button(action: retake) {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .accessibilityLabel(String(localized: "Retake", comment: "Button title to retake the document photo"))

                        Button(action: { startScan(with: scanResult, mrz: mrz) }) {
                            Image(systemName: "wave.3.right")
                        }
                        .accessibilityLabel(String(localized: "Start NFC scan", comment: "Button title to start the NFC scan using the read MRZ data"))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if case .capture = step {
                        EmptyView()
                    } else {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                        }
                        .accessibilityLabel("Close NFC demo")
                    }
                }
            }
        }
    }

    private func handleCaptured(_ result: DocumentScannerResult) {
        switch result.result {
        case .success(let success):
            if let mrz = success.mrz,
               let documentNumber = mrz.documentNumber, !documentNumber.isEmpty,
               let dateOfBirth = mrz.dateOfBirth, MRZDateCodec.bacKeyString(fromReceivedDate: dateOfBirth) != nil,
               let expiryDate = mrz.expiryDate, MRZDateCodec.bacKeyString(fromReceivedDate: expiryDate) != nil {
                step = .confirm(result, mrz: mrz)
            } else {
                dismiss()
            }
        case .failure:
            dismiss()
        @unknown default:
            dismiss()
        }
    }

    private func actionLabel(title: String, systemImage: String, isProminent: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(title)
        }
        .font(.subheadline.bold())
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(isProminent ? Color.accentColor : Color.clear)
        .foregroundColor(isProminent ? .white : .accentColor)
        .overlay(
            Capsule().stroke(Color.accentColor, lineWidth: isProminent ? 0 : 1.5)
        )
        .clipShape(Capsule())
        .shadow(color: isProminent ? Color.accentColor.opacity(0.25) : .clear, radius: 8, x: 0, y: 4)
    }

    private func retake() {
        captureAttempt += 1
        step = .capture
    }

    private func startScan(with scanResult: DocumentScannerResult, mrz: MRZData) {
        // handleCaptured already confirmed both dates convert before reaching .confirm.
        let documentKey = OzoneNFCDocumentKey(
            passportNumber: mrz.documentNumber ?? "",
            dateOfBirth: mrz.dateOfBirth.flatMap(MRZDateCodec.bacKeyString(fromReceivedDate:)) ?? "",
            expiryDate: mrz.expiryDate.flatMap(MRZDateCodec.bacKeyString(fromReceivedDate:)) ?? ""
        )
        step = .scan(documentKey, scanResult: scanResult, mrz: mrz)
    }

    private func onScanFinished(_ result: Result<OzoneNFCDocument, OzoneNFCError>, scanResult: DocumentScannerResult, mrz: MRZData) {
        switch result {
        case .success(let passport):
            step = .result(passport)
        case .failure:
            step = .confirm(scanResult, mrz: mrz)
        }
    }

    /// Validates the `yyMMdd` dates Document's MRZData returns and normalizes them into
    /// the form the NFC BAC key requires.
    private enum MRZDateCodec {
        private static let bacKeyFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "yyMMdd"
            return formatter
        }()

        static func bacKeyString(fromReceivedDate receivedDate: String) -> String? {
            bacKeyFormatter.date(from: receivedDate).map(bacKeyFormatter.string)
        }
    }
}

#Preview {
    NFCDemoView()
}
