//
//  ImagePicker.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-08.
//

import Foundation
import SwiftUI

//This file contains the imagePicker used in several views.

//MARK ---------->> imagePicker - UIViewControllerRepresentable

struct imagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    //I set the default source to camera, but user is always presented with a choice of source.
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(image: $image, isPresented: $isPresented)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
        
    }
}

//MARK ---------->> Coordinator
class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
        _image = image
        _isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage =
            info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage {
            image = uiImage
            isPresented = false
            
        }
    }
}
