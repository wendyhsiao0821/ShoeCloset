//
//  MainVCNew.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/19.
//

import UIKit
import CoreData

class MainVCNew: UIViewController, dropDownListDelegate, detailDoneDelegate {
    
    let mainViewModel = MainVCNewViewModel()
    
    let dropdown = DropDownList()
    let itemTableView = UITableView()

    var newShoeItem: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F3F3F3", alpha: 1)
        
        mainViewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.itemTableView.reloadData()
            }
        }
        
        setUpDropDown()
        setUpAddButton()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        mainViewModel.loadItems()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - drop down list
    
    func setUpDropDown() {
        dropdown.delegate = self
        dropdown.configure()
        
        view.addSubview(dropdown.button)
        
        dropdown.button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dropdown.button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            dropdown.button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dropdown.button.widthAnchor.constraint(equalToConstant: 102),
            dropdown.button.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    
    func editPeriodState(state: String) {
        mainViewModel.setPeriodState(state)
    }
    
    
  // MARK: - add button
    
    func setUpAddButton() {
        let addButton = AddPageButton(imageName: "plus.circle", imageColor: "F2771F")
        view.addSubview(addButton)
         
        itemTableView.backgroundColor = .clear
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        addButton.addTarget(self, action: #selector(pushAddPageVC), for: .touchUpInside)
    }
    
    
    @objc func pushAddPageVC() {

        guard navigationController?.topViewController == self else { return }
        
            let addPageVC = AddPageVC()
            navigationController?.pushViewController(addPageVC, animated: true)
        }
    
    
    // MARK: - itemTableView
    
    func configureTableView() {
        view.addSubview(itemTableView)
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        itemTableView.separatorStyle = .none
        itemTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemTableView.topAnchor.constraint(equalTo: dropdown.button.bottomAnchor, constant: 16),
            itemTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            itemTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            itemTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        itemTableView.register(ShoeItemTableViewCell.self, forCellReuseIdentifier: ShoeItemTableViewCell.reuseID)
    }
}


extension MainVCNew: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shoe = mainViewModel.filteredShoes[indexPath.row]
        
        let cell = itemTableView.dequeueReusableCell(withIdentifier: ShoeItemTableViewCell.reuseID) as! ShoeItemTableViewCell
        
        let image: UIImage = {
            if let data = shoe.shoeImage, let img = UIImage(data: data) {
                return img
            } else {
                return UIImage(named: "defaultShoe")!
            }
        }()
        
        let CellLogCount = mainViewModel.getLogCount(for: shoe)
        
        cell.setUpCell(image: image, brand: shoe.brand ?? "Empty brand", series: shoe.series ?? "Empty series", colorway: shoe.colorway ?? "Empty colorway", count: CellLogCount)
        
        cell.selectionStyle = .none

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainViewModel.filteredShoes.count > 0 {
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            let noDataImageView = UIImageView(image: UIImage(named: "noDataImage"))
            
            let stackView = UIStackView(arrangedSubviews: [noDataImageView, noDataLabel])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            tableView.backgroundView = stackView
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            noDataLabel.text = "I don't have any shoes now 😕"
            noDataLabel.textColor = .systemGray
        }
        return mainViewModel.filteredShoes.count
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         let selectedShoe = mainViewModel.filteredShoes[indexPath.row]
        
        let detailVC = ShoeDetailVC()
         
         detailVC.delegate = self
        
        detailVC.detailBrand = selectedShoe.brand
        detailVC.detailSeries = selectedShoe.series
        detailVC.detailColorway = selectedShoe.colorway
        
        if let purchaseDate = selectedShoe.purchaseDate {
            detailVC.detailPurchaseDate = dateToString(dateDate: purchaseDate)
            detailVC.editPurchaseDate = purchaseDate
        } else {
            detailVC.detailPurchaseDate = nil
            detailVC.editPurchaseDate = nil
        }
        
        detailVC.detailTitle = selectedShoe.shoeTitle
        detailVC.selectedItem = selectedShoe
        
        if let data = selectedShoe.shoeImage,
           let image = UIImage(data: data) {
            detailVC.shoeImage = image
        }

        let navController = UINavigationController(rootViewController: detailVC)
//        present(navController, animated: true, completion: nil)
         navController.modalPresentationStyle = .automatic
         navController.isModalInPresentation = true
         present(navController, animated: true, completion: nil)
         
         
         
    }
    
    
    //MARK: - Swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "🗑️") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
//            mainViewModel.context.delete(mainViewModel.shoeArray[indexPath.row])
//            self.mainViewModel.shoeArray.remove(at: indexPath.row)
//            self.mainViewModel.saveItems()
            
            mainViewModel.cellDeleteMethod(indexPath: indexPath)
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(hex: "F3F3F3") 
      
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

    

// MARK: - Model Manupulation Methods

extension MainVCNew {
    
    @objc func reloadClosetData() { // for the notificationCenter observer
        mainViewModel.loadItems()
    }
}
