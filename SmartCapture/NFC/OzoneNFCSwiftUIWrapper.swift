//
//  OzoneNFCSwiftUIWrapper.swift
//  SmartCapture
//
//  Created by Wilmer Barrios on 17/04/26.
//

import Foundation
import OzoneNFC
import SwiftUI

struct OzoneNFCSwiftUIWrapper: UIViewControllerRepresentable {
    let documentKey: OzoneNFCDocumentKey
    let completion: (Result<OzoneNFCDocument, OzoneNFCError>) -> Void

    func makeUIViewController(context: Context) -> OzoneNFCViewController {
        OzoneNFCUIAppearance.shared.customBundle = Bundle.main
        let vc = OzoneNFCViewController(documentKey: documentKey, completion: completion)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: OzoneNFCViewController, context: Context) {
        
    }
}
