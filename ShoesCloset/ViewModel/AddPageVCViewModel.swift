//
//  AddPageVCViewModel.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/5/17.
//

import UIKit
import CoreData

class AddPageVCViewModel {
    // MARK: - Properties for user input
        var brand: String = ""
        var series: String = ""
        var colorway: String = ""
        var purchaseDate: Date?
        var shoeImage: UIImage?
        
        var onSaveSuccess: (() -> Void)?
        var onSaveFailure: ((String) -> Void)?

        private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // MARK: - Public Methods
        func validateFields() -> Bool {
            return !brand.isEmpty && !series.isEmpty && !colorway.isEmpty
        }
    
        
        func saveShoe() {
            guard validateFields() else {
                onSaveFailure?("Please fill in all fields.")
                return
            }
            
            let newItem = Item(context: context)
            newItem.brand = brand
            newItem.series = series
            newItem.colorway = colorway
            newItem.purchaseDate = purchaseDate
            newItem.shoeTitle = "\(brand) \(series) \(colorway)"
            newItem.id = UUID()
            
            if let image = shoeImage, let imageData = image.jpegData(compressionQuality: 0.9) {
                newItem.shoeImage = imageData
            }

            do {
                try context.save()
                onSaveSuccess?()
            } catch {
                onSaveFailure?("Failed to save: \(error.localizedDescription)")
            }
        }
    
    
    func updateSelectedImage(_ image: UIImage) {
        self.shoeImage = image
    }
}
