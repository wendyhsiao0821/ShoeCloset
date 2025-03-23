//
//  AddNewShoesViewController.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/1/17.
//

import UIKit
import CoreData

class AddNewShoesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var brandTextField: UITextField!
    @IBOutlet var seriesTextField: UITextField!
    @IBOutlet var colorwayTextField: UITextField!
    @IBOutlet var purchaseDate: UIDatePicker!
    
    @IBOutlet var editShoeTitleLabel: UILabel!
    
    @IBOutlet var imagePickerButton: UIButton!
    @IBOutlet var addShoePhotoImageView: UIImageView!
    
    @IBOutlet var saveButton: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activeField: UITextField?
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "ADD NEW SHOES"
        
        brandTextField.delegate = self
        
        addShoePhotoImageView.layer.borderWidth = 0.8
        addShoePhotoImageView.layer.borderColor = UIColor.gray.cgColor
        addShoePhotoImageView.layer.cornerRadius = 8
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if self.brandTextField.text != "" {
//                self.saveButton.setTitle("cool", for: .normal)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               self.checkBrandTextField()
           }
    }

    func checkBrandTextField() {
        if let text = brandTextField.text, !text.isEmpty {
            saveButton.setTitle("Update data", for: .normal)
            imagePickerButton.setTitle("Edit photo", for: .normal)
        }
    }
    
    //MARK: - Keyboard Show and Dismiss
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: - Press Save Button
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        //        self.performSegue(withIdentifier: "saveNewSegue", sender: self)

        if (brandTextField.text ?? "").isEmpty ||
            (seriesTextField.text ?? "").isEmpty ||
            (colorwayTextField.text ?? "").isEmpty  {
               showEmptyAlert()
            
        } else {
            let newItem = Item(context: context)
            
            newItem.shoeTitle = getShoesItemTitle()
            newItem.brand = brandTextField.text
            newItem.series = seriesTextField.text
            newItem.colorway = colorwayTextField.text
            newItem.purchaseDate = purchaseDate.date
            newItem.id = UUID()
            
//            guard let imageData = addShoePhotoImageView.image?.jpegData(compressionQuality: 1.0) else {
//                print("no image data")
//                return
//            }
            
            if let imageData = addShoePhotoImageView.image?.jpegData(compressionQuality: 1.0) {
                newItem.shoeImage = imageData
            } else {
                print("no image data alert")
            }
            
            saveItems()
            
            navigationController?.popViewController(animated: true)
            

        }
        

    }
    
    func showEmptyAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill in all text fields.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
    }
    
    func getShoesItemTitle() -> String {
        let brand = brandTextField.text ?? "Unknown Brand"
        let series = seriesTextField.text ?? "Unknown Series"
        let colorway = colorwayTextField.text ?? "Unknown Colorway"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // 自訂日期格式，例如：Jan 21, 2025
        formatter.timeStyle = .none  // 不顯示時間
        //            let formattedDate = formatter.string(from: purchaseDate.date)
        
        let combinedString = "\(brand) \(series) \(colorway)"
        
        return combinedString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveNewSegue" {
            let destinationVC = segue.destination as! ClosetViewController
            destinationVC.newShoeItem = getShoesItemTitle()
        }
    }
     
    
   
    
//MARK: Data save methods -
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    }

extension AddNewShoesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func openImagePicker(_ sender: UIButton) {
        presentImagePicker()
    }


    private func presentImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Or .camera for capturing photos
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            addShoePhotoImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Handle the user canceling the image picker, if needed.
        dismiss(animated: true, completion: nil)
    }
    
    
    func fetchImageFromCoreData() -> UIImage? {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            if let result = try context.fetch(request).first, let imageData = result.shoeImage {
                return UIImage(data: imageData)
            }
        } catch {
            print("Failed to fetch image: \(error)")
        }
        
        return nil
    }
    

}


