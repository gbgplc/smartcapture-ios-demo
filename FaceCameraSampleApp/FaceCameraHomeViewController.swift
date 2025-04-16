import UIKit
import SwiftUI
import FaceCamera

final class FaceCameraHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        startFaceCamera()
    }
    
    func startFaceCamera() {
        let vc = UIHostingController(rootView: FaceCameraViewControllerWrapper(delegate: self))
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }

}

extension FaceCameraHomeViewController: FaceCameraListenable {
    func didEncounterError(_ error: FaceCamera.FaceCameraError) {
        print(Self.self, #function, error)
    }
    
    func didCapture(_ result: FaceCamera.FaceCameraResult) {
        print(Self.self, #function, result)
    }
    
    func didCancel() {
        print(Self.self, #function)
    }
    
    func didTapBack() {
        print(Self.self, #function)
    }
}
