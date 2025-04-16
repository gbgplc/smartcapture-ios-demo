import SwiftUI
import FaceCamera

struct ResultView: View {
    let result: FaceCameraResult
    @State private var showShareSheet = false
    @State private var sharedFileURL: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(uiImage: result.previewPhoto)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 600)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Capture Results")
                    .font(.title2.bold())
                
                encryptedDataSection
                unencryptedDataSection
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showShareSheet) {
            if let url = sharedFileURL {
                ActivityView(activityItems: [url])
            }
        }
    }
    
    private var encryptedDataSection: some View {
        VStack(alignment: .leading) {
            Text("Encrypted Data")
                .font(.headline)
            HStack {
                Text("\(result.encryptedBlob.count) bytes")
                    .font(.body.monospaced())
                Spacer()
                Button(action: shareEncryptedData) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .labelStyle(.iconOnly)
                }
            }
        }
    }
    
    private var unencryptedDataSection: some View {
        VStack(alignment: .leading) {
            Text("Unencrypted Data")
                .font(.headline)
            HStack {
                Text("\(result.unencryptedBlob.count) bytes")
                    .font(.body.monospaced())
                Spacer()
                Button(action: shareUnencryptedData) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .labelStyle(.iconOnly)
                }
            }
        }
    }
    
    private func shareEncryptedData() {
        let base64String = result.encryptedBlob.base64EncodedString()
        shareData(Data(base64String.utf8), filename: "encrypted_data.txt")
    }
    
    private func shareUnencryptedData() {
        let base64String = result.unencryptedBlob.base64EncodedString()
        shareData(Data(base64String.utf8), filename: "un_encrypted_data.txt")
    }
    
    private func shareData(_ data: Data, filename: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(filename)
                try data.write(to: tempURL)
                
                DispatchQueue.main.async {
                    sharedFileURL = tempURL
                    showShareSheet = true
                }
            } catch {
                print("Error sharing file: \(error.localizedDescription)")
            }
        }
    }
}
