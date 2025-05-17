//
//  AddPageVC.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/22.
//

import UIKit
import CoreData

class AddPageVC: UIViewController, UITextFieldDelegate {
    
    let addPageViewModel = AddPageVCViewModel()
    
    let shoeDataStack = UIStackView()
    let purchaseDatePickerTitle = PurchaseDateTitle(titleText: "Purchase Date")
    let brandTextField = TextFieldTitle(titleText: "Brand")
    let seriesTextField = TextFieldTitle(titleText: "Series")
    let colorwayTextField = TextFieldTitle(titleText: "Colorway")
    
    let addShoePhotoImageView = ImageView(frame: .zero)
    let imagePicker = UIImagePickerController()
    let imagePickerButton = GeneralButton(buttonTitle: "Add photo", backgroundColor: "F2771F")
    
    let saveButton = GeneralButton(buttonTitle: "Save", backgroundColor: "F2771F")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F3F3F3", alpha: 1)

        title = "Add new shoes"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: "F2771F")]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        configureShoeDataStack()
        configureImageView()
        configureSaveButton()

        brandTextField.textField.delegate = self
        seriesTextField.textField.delegate = self
        colorwayTextField.textField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkBrandTextField()
        }
    }
    
    
    // MARK: - Configure shoe data stack
    
    func configureShoeDataStack() {
        view.addSubview(shoeDataStack)
        
        shoeDataStack.axis = .vertical
        shoeDataStack.spacing = 10
        
        shoeDataStack.addArrangedSubview(brandTextField)
        shoeDataStack.addArrangedSubview(seriesTextField)
        shoeDataStack.addArrangedSubview(colorwayTextField)
        shoeDataStack.addArrangedSubview(purchaseDatePickerTitle)
        
        shoeDataStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            brandTextField.heightAnchor.constraint(equalToConstant: 70),
            seriesTextField.heightAnchor.constraint(equalToConstant: 70),
            colorwayTextField.heightAnchor.constraint(equalToConstant: 70),
            purchaseDatePickerTitle.heightAnchor.constraint(equalToConstant: 80),
            
            shoeDataStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            shoeDataStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            shoeDataStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    // MARK: - Configure image view
    
    func configureImageView() {
        view.addSubview(addShoePhotoImageView)
        view.addSubview(imagePickerButton)
        
        addShoePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        imagePickerButton.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            addShoePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            addShoePhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addShoePhotoImageView.widthAnchor.constraint(equalToConstant: 110),
            addShoePhotoImageView.heightAnchor.constraint(equalToConstant: 110),
            
            imagePickerButton.bottomAnchor.constraint(equalTo: addShoePhotoImageView.bottomAnchor, constant: 0),
            imagePickerButton.leadingAnchor.constraint(equalTo: addShoePhotoImageView.trailingAnchor, constant: 8),
            imagePickerButton.widthAnchor.constraint(equalToConstant: 110),
            imagePickerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addShoePhotoImageView.contentMode = .scaleAspectFit
        imagePickerButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
    }
    
    
    // MARK: - Configure save button
    
    func checkBrandTextField() {
        if let text = brandTextField.textField.text, !text.isEmpty {
                        saveButton.setTitle("Update data", for: .normal)
            //            imagePickerButton.setTitle("Edit photo", for: .normal)
            imagePickerButton.set(text: "Edit photo", color: "C9C9C9")
        }
    }
    
    
    func configureSaveButton() {
        view.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc func saveButtonPressed() {
//        if (brandTextField.textField.text ?? "").isEmpty ||
//            (seriesTextField.textField.text ?? "").isEmpty ||
//            (colorwayTextField.textField.text ?? "").isEmpty  {
//            presentGFAlertOnMainThread(title: "Missing information", message: "Please fill in all text fields.", buttonTitle: "Ok")
//            
//        } else {
//            let newItem = Item(context: context)
//            
//            newItem.shoeTitle = getShoesItemTitle()
//            newItem.brand = brandTextField.textField.text
//            newItem.series = seriesTextField.textField.text
//            newItem.colorway = colorwayTextField.textField.text
//            newItem.purchaseDate = purchaseDatePickerTitle.datePicker.date
//            newItem.id = UUID()
//            
//            if let imageData = addShoePhotoImageView.image?.jpegData(compressionQuality: 1.0) {
//                newItem.shoeImage = imageData
//            } else {
//                print("no image data alert")
//            }
//            saveItems()
        
        addPageViewModel.brand = brandTextField.textField.text ?? ""
        addPageViewModel.series = seriesTextField.textField.text ?? ""
        addPageViewModel.colorway = colorwayTextField.textField.text ?? ""
        addPageViewModel.purchaseDate = purchaseDatePickerTitle.datePicker.date
        addPageViewModel.shoeImage = addShoePhotoImageView.image

        addPageViewModel.onSaveSuccess = { [weak self] in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }

        addPageViewModel.onSaveFailure = { [weak self] message in
                DispatchQueue.main.async {
                    self?.presentGFAlertOnMainThread(title: "Missing Information", message: message, buttonTitle: "Ok")
                }
            }

        addPageViewModel.saveShoe()
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}






