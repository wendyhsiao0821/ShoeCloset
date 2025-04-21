//
//  MainVCNew.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/19.
//

import UIKit
import CoreData

class MainVCNew: UIViewController {
    
    let dropdown = dropDownList()
    let itemTableView = UITableView()
    
    var shoeArray: [Item] = []
    var newShoeItem: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var periodState: String? = "All time" //記得刪掉 TODO: set up dropdown list action & change periodState
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F3F3F3", alpha: 1)
        
        setUpDropDown()
        setUpAddButton()
        configureTableView()
    }
    
    
    func setUpDropDown() {
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
    }
    
    
    func configureTableView() {
        view.addSubview(itemTableView)
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        itemTableView.separatorStyle = .none
        
        itemTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemTableView.topAnchor.constraint(equalTo: dropdown.button.bottomAnchor, constant: 16),
            itemTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            itemTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            itemTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        itemTableView.register(ShoeItemTableViewCell.self, forCellReuseIdentifier: ShoeItemTableViewCell.reuseID)
    }
}


// MARK: - itemTableView Data Source
extension MainVCNew: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shoe = shoeArray[indexPath.row]
        
        let cell = itemTableView.dequeueReusableCell(withIdentifier: ShoeItemTableViewCell.reuseID) as! ShoeItemTableViewCell
        
        let image: UIImage = {
            if let data = shoe.shoeImage, let img = UIImage(data: data) {
                return img
            } else {
                return UIImage(named: "defaultShoe")!
            }
        }()
        
        var CellLogCount: Int
        
        if periodState == "7 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 7)
            CellLogCount = logCount
        } else if periodState == "30 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 30)
            CellLogCount = logCount
        } else if periodState == "90 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 90)
            CellLogCount = logCount
        } else if periodState == "180 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 180)
            CellLogCount = logCount
        } else {
            let logCount = shoe.logs?.count
            CellLogCount = logCount ?? 0
        }
        
        cell.setUpCell(image: image, brand: shoe.brand ?? "Empty brand", series: shoe.series ?? "Empty series", colorway: shoe.colorway ?? "Empty colorway", count: CellLogCount)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shoeArray.count > 0 {
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
        return shoeArray.count
    }
}



// MARK: - Model Manupulation Methods
extension MainVCNew {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadClosetData()
    }
    
    @objc func reloadClosetData() { // for the notificationCenter observer
        loadItems()
        itemTableView.reloadData()
    }
    

    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let sortDescriptor = NSSortDescriptor(key: "shoeTitle", ascending: true)
        //        if let additionalPredicate = predicate {
        //            request.predicate = additionalPredicate
        //
        //        }
        request.sortDescriptors = [sortDescriptor]
        do {
            shoeArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        itemTableView.reloadData()
    }
    
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.itemTableView.reloadData()
    }
}


// MARK: - Hex color Ext
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

