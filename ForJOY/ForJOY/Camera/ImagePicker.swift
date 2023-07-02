//
//  ImagePicker.swift
//  ForJOY
//
//  Created by hyebin on 2023/07/02.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
     @Binding var selectedImage: UIImage?
     var sourceType: UIImagePickerController.SourceType = .photoLibrary

     func makeCoordinator() -> Coordinator {
         Coordinator(parent: self)
     }

     func makeUIViewController(context: Context) -> UIImagePickerController {
         let imagePickerController = UIImagePickerController()
         imagePickerController.delegate = context.coordinator
         imagePickerController.sourceType = sourceType
         return imagePickerController
     }

     func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

     class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
         let parent: ImagePicker

         init(parent: ImagePicker) {
             self.parent = parent
         }

         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
             if let selectedImage = info[.originalImage] as? UIImage {
                 parent.selectedImage = selectedImage
             }
             picker.dismiss(animated: true, completion: nil)
         }
     }
 }
