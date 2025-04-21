//
//  MainVCNew.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/19.
//

import UIKit

class MainVCNew: UIViewController {
    
    let dropdown = dropDownList()
    let itemTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F9F9F9", alpha: 1)
        
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
            dropdown.button.widthAnchor.constraint(equalToConstant: 179),
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
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
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


extension MainVCNew: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemTableView.dequeueReusableCell(withIdentifier: ShoeItemTableViewCell.reuseID) as! ShoeItemTableViewCell
       cell.setUpCell(image: UIImage(named: "defaultShoe")!, brand: "Nike", series: "Air Force", colorway: "Brown", count: 5)
        return cell
    }

}


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

