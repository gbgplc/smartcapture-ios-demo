//
//  ContentView.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 20/05/24.
//

import SwiftUI
import FaceCamera
import Document

// MARK: - Content

enum ModuleOption: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case journey
    case documentCamera
    case faceCamera
    case ozone
}

enum UserOption: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case settings
}

extension ModuleOption {
    var title: String {
        switch self {
        case .journey:
            String(localized: "JOURNEY", comment: "Journey Module Option")
        case .documentCamera:
            String(localized: "DOCUMENT CAMERA", comment: "Document Camera Module Option")
        case .faceCamera:
            String(localized: "FACE CAMERA", comment: "Face Camera Module Option")
        case .ozone:
            String(localized: "OZONE", comment: "Ozone Module Option")
        }
    }
}

extension UserOption {
    var title: String {
        switch self {
        case .settings:
            String(localized: "SETTINGS", comment: "Settings User Option")
        }
    }
}

struct StubView: View {
    let title: String
    
    var body: some View {
        Text(title)
    }
}

// MARK: - UI
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    let gbgGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.64, green: 0.63, blue: 1.0), // (vivid purple)
            Color(red: 0.96, green: 0.97, blue: 1.0)  // (light blue)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            gbgGradient.ignoresSafeArea()
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Text("GBG Smart Capture Demo")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Select a demo to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(ModuleOption.allCases, id: \.self) { option in
                        switch option {
                        case .documentCamera:
                            DemoTypeView(label: "Document", systemImage: "doc.text.viewfinder") {
                                viewModel.showDocumentsDemo = true
                            }
                        case .faceCamera:
                            DemoTypeView(label: "Face", systemImage: "face.dashed") {
                                viewModel.showCamera = true
                            }
//                        case .ozone:
//                            DemoTypeView(label: "NFC", systemImage: "wave.3.right.circle") {
//                                // Show the ozone demo
//                            }
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Modifiers for overlays and sheets
            .fullScreenCover(isPresented: $viewModel.showCamera) {
                FaceCameraViewControllerWrapper(delegate: viewModel.delegateHandler)
            }
            .fullScreenCover(isPresented: $viewModel.showDocumentsDemo) {
                DocumentDemoView(documentResult: $viewModel.documentResult)
            }
            .alert("Error", isPresented: $viewModel.showCameraError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.cameraError?.localizedDescription ?? "Unknown error")
            }
            .alert("Cancelled", isPresented: $viewModel.showCancellationAlert) {
                Button("OK", role: .cancel) { }
            }
            .sheet(item: $viewModel.cameraResult) { result in
                if #available(iOS 16.0, *) {
                    FaceResultView(result: result)
                        .presentationDragIndicator(.visible)
                } else {
                    FaceResultView(result: result)
                }
            }
            .sheet(item: $viewModel.documentResult) { result in
                if #available(iOS 16.0, *) {
                    DocumentResultView(
                        result: result.result,
                        metadata: result.metadata
                    )
                    .presentationDragIndicator(.visible)
                } else {
                    DocumentResultView(
                        result: result.result,
                        metadata: result.metadata
                    )
                }
            }
        }
    }
}

struct DemoTypeView: View {
    let label: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(.accentColor)
                .padding(.top, 20)
            Text(label)
                .font(.headline)
                .foregroundColor(.primary)
            Button(action: action) {
                HStack {
                    Image(systemName: "camera")
                    Text("Start")
                }
                .font(.subheadline.bold())
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground).opacity(0.9))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .padding(4)
    }
}

extension FaceCameraResult: Identifiable {
    public var id: Int { self.hash }
}

extension DocumentScannerResult: Identifiable {
    public var id: UUID { UUID() } // or any unique property
}


#Preview {
    HomeView()
}

#Preview("DemoTypeView") {
    DemoTypeView(label: "Face", systemImage: "face.dashed") {
        print("Start Face Camera")
    }
}
