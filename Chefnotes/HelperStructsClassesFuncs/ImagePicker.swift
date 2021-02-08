//
//  ImagePicker.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-08.
//

import Foundation
import SwiftUI

//MARK ---------->> imagePicker - UIViewControllerRepresentable

struct imagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    //sourcetype är om du väljer en bild från kamera eller bildgalleri
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(image: $image)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
        
    }
}

//MARK ---------->> Coordinator
class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    
    init(image: Binding<UIImage?>) {
        _image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage =
            info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage {
            image = uiImage
        }
    }
}
