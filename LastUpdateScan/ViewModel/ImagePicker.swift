//
//  ImagePicker.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 15/06/1446 AH.
//
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var completion: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage, completion: completion)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?
        var completion: (UIImage?) -> Void
        
        init(selectedImage: Binding<UIImage?>, completion: @escaping (UIImage?) -> Void) {
            self._selectedImage = selectedImage
            self.completion = completion
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.selectedImage = image
                self.completion(image)
            } else {
                self.completion(nil)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.completion(nil)
            picker.dismiss(animated: true)
        }
    }
}
