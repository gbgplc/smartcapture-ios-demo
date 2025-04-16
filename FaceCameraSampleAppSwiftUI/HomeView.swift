import SwiftUI
import FaceCamera

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
}

extension HomeView {
    var body: some View {
        VStack(spacing: 20) {
            Image("gbg-logo")
                .font(.title)
            
            Button(action: { viewModel.showCamera = true }) {
                HStack {
                    Image(systemName: "camera")
                    Text("Start Camera Session")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(7)
            }
            
            if let result = viewModel.cameraResult {
                ResultView(result: result)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            FaceCameraViewControllerWrapper(delegate: viewModel.delegateHandler)
        }
        .alert("Error", isPresented: $viewModel.showCameraError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.cameraError?.localizedDescription ?? "Unknown error")
        }
        .alert("Cancelled", isPresented: $viewModel.showCancellationAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

class HomeViewModel: NSObject, ObservableObject {
    @Published var showCamera = false
    @Published var cameraResult: FaceCameraResult?
    @Published var cameraError: FaceCameraError?
    @Published var showCameraError = false
    @Published var showCancellationAlert = false
    
    lazy var delegateHandler: FaceCameraDelegateHandler = {
        FaceCameraDelegateHandler(parent: self)
    }()
}

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
