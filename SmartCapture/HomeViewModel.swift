//
//  HomeViewModel.swift
//  SmartCapture
//
//  Created by Pablo Sierra on 03/11/2025.
//

import Foundation
import FaceCamera
import Document

class HomeViewModel: NSObject, ObservableObject {
    @Published var showDocumentsDemo = false
    @Published var showCamera = false
    @Published var cameraResult: FaceCameraResult?
    @Published var cameraError: FaceCameraError?
    @Published var documentResult: DocumentScannerResult?
    @Published var showCameraError = false
    @Published var showCancellationAlert = false
    
    lazy var delegateHandler: FaceCameraDelegateHandler = {
        FaceCameraDelegateHandler(parent: self)
    }()
}
