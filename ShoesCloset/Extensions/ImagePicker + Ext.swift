//
//  ImagePicker + Ext.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/29.
//

import UIKit
import CoreData

extension AddPageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    private func presentImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    

    @objc func openImagePicker() {
        presentImagePicker()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            addPageViewModel.updateSelectedImage(pickedImage)
            addShoePhotoImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
