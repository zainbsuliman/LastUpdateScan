//
//  ScannerView.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 13/06/1446 AH.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: ([String]?) -> Void
    private let scanButtonText: String
    
    init(scanButtonText: String, completion: @escaping ([String]?) -> Void) {
        self.scanButtonText = scanButtonText
        self.completionHandler = completion
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: ([String]?) -> Void
        
        init(completion: @escaping ([String]?) -> Void) {
            self.completionHandler = completion
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var recognizedTexts: [String] = []
            let textRecognizer = TextRecognizer()
            
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                textRecognizer.recognizeText(from: image) { recognizedText in
                    if let text = recognizedText {
                        recognizedTexts.append(text)
                    }
                    
                    if recognizedTexts.count == scan.pageCount {
                        self.completionHandler(recognizedTexts)
                    }
                }
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            self.completionHandler(nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            self.completionHandler(nil)
        }
        
    }
}
