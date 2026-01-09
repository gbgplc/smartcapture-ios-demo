//
//  FaceCameraDelegateHandler.swift
//  SmartCapture
//
//  Created by Pablo Sierra on 31/10/2025.
//

import Foundation
import FaceCamera

class FaceCameraDelegateHandler: NSObject, FaceCameraListenable {
    weak var parent: HomeViewModel?
    
    init(parent: HomeViewModel) {
        self.parent = parent
    }
    
    func didEncounterError(_ error: FaceCameraError) {
        DispatchQueue.main.async {
            self.parent?.cameraError = error
            self.parent?.showCameraError = true
            self.parent?.showCamera = false
        }
    }
    
    func didCapture(_ result: FaceCameraResult) {
        DispatchQueue.main.async {
            self.parent?.cameraResult = result
            self.parent?.showCamera = false
        }
    }
    
    func didCancel() {
        DispatchQueue.main.async {
            self.parent?.showCancellationAlert = true
            self.parent?.showCamera = false
        }
    }
    
    func didTapBack() {
        //handle dismissal if needed
    }
}
