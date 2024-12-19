//
//  TextRecognizer.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 13/06/1446 AH.
//


import UIKit
import Vision

final class TextRecognizer {
    func recognizeText(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil, let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            let recognizedText = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            completion(recognizedText)
        }
        
        request.recognitionLanguages = ["ar"] // تحديد اللغة العربية
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform text recognition: \(error)")
                completion(nil)
            }
        }
    }
}

