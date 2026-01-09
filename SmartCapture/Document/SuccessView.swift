//
//  SuccessView.swift
//  SmartCapture
//
//  Created by Pablo Sierra on 04/11/2025.
//

import SwiftUI
import Document
import Photos

struct SuccessView: View {
    @State private var showSaveAlert = false
    @State private var showDeniedAlert = false

    let success: Success
    let metadata: DocumentProcessingMetadata?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            qualityResultsSection
            dimensionsSection
            if metadata != nil {
                metadataSection
            }
            if let uiImage = UIImage(data: success.image.image) {
                capturedImageSection(uiImage: uiImage)
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("Capture completed")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.green)
                .font(.system(size: 20))
        }
    }

    private var qualityResultsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Quality Results")
                    .font(.headline)
                if let metadata = metadata, metadata.hasDisabledAutoCapture {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                } else {
                    let checks = [
                        success.image.isGood,
                        success.image.isSharp,
                        success.image.isGlareFree,
                        success.image.isAdequateResolution
                    ]
                    let failedCount = checks.compactMap { $0 == false ? true : nil }.count
                    let (symbol, color): (String, Color) = {
                        switch failedCount {
                        case 0: return ("checkmark.seal.fill", .green)
                        case 1: return ("exclamationmark.triangle.fill", .yellow)
                        default: return ("xmark.octagon.fill", .red)
                        }
                    }()
                    Image(systemName: symbol)
                        .foregroundColor(color)
                        .font(.title3)
                }
            }
            Text("Good: \(success.image.isGood?.description ?? "-")")
            Text("Sharp: \(success.image.isSharp?.description ?? "-")")
            Text("Glare Free: \(success.image.isGlareFree?.description ?? "-")")
            Text("Adequate resolution: \(success.image.isAdequateResolution?.description ?? "-")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(16)
    }

    private var dimensionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Dimensions")
                .font(.headline)
            Text("Width: \(success.image.width) px")
            Text("Height: \(success.image.height) px")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.mint.opacity(0.07))
        .cornerRadius(16)
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Capture Details")
                .font(.headline)
            Text("Blurry frame count: \(metadata?.blurryFrameCount ?? 0)")
            Text("Glare frame count: \(metadata?.glareFrameCount ?? 0)")
            Text("Low resolution frame count: \(metadata?.lowResFrameCount ?? 0)")
            Text("Out of bounds frame count: \(metadata?.documentBoundaryFrameCount ?? 0)")
            Text("Total frame count: \(metadata?.processedFrameCount ?? 0)")
            Text("Has disabled auto capture: \(metadata?.hasDisabledAutoCapture.description ?? "-")")
            Text("Capture duration (sec): \(Double(metadata?.captureDuration ?? 0))")
            Text("Captured frame processing time (sec): \(Double(metadata?.lastFrameProcessingDuration ?? 0))")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue.opacity(0.08))
        .cornerRadius(16)
    }

    private func capturedImageSection(uiImage: UIImage) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Captured Image")
                .font(.headline)
            HStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(
                        CGFloat(success.image.width) / CGFloat(success.image.height),
                        contentMode: .fit
                    )
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Button(action: {
                saveImageToCameraRoll(uiImage)
            }) {
                Label("Save to Camera Roll", systemImage: "square.and.arrow.down")
                    .font(.body)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .alert("Image saved!", isPresented: $showSaveAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Permission denied", isPresented: $showDeniedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please allow access to Photos in Settings.")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(16)
    }

    func saveImageToCameraRoll(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    showSaveAlert = true
                } else {
                    showDeniedAlert = true
                }
            }
        }
    }
}

#Preview {
    if case .result(let result) = DocumentProcessingState.mockSuccess,
       case .success(let success) = result {
        SuccessView(
            success: success,
            metadata: DocumentProcessingMetadata.mock
        )
    }
}
