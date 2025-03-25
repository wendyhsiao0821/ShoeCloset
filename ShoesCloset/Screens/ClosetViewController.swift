//
//  ViewController.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/1/15.
//

import UIKit
import CoreData

class ClosetViewController: UITableViewController {
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var periodButton: UIButton!
    
    @IBOutlet var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet var navTitle: UINavigationItem!
    
    var shoeArray: [Item] = []
    var newShoeItem: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var periodState: String?
    
    
    //Computed properties
    var menuItems: [UIAction] {
        return [
            UIAction(title: "7 days", image: nil, handler: { (_) in
                self.periodMenuAction(days: "7 days")
            }),
            UIAction(title: "30 days", image: nil, handler: { (_) in
                self.periodMenuAction(days: "30 days")
            }),
            UIAction(title: "90 days", image: nil, handler: { (_) in
                self.periodMenuAction(days: "90 days")
            }),
            UIAction(title: "180 days", image: nil, handler: { (_) in
                self.periodMenuAction(days: "180 days")
            }),
            UIAction(title: "All time", image: nil, handler: { (_) in
                self.periodMenuAction(days: "All time")
            })
        ]
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadClosetData), name: NSNotification.Name("DidUpdateShoes"), object: nil) //加入監聽
        
        configureButtonMenu()
        
        self.navTitle.title = "All time"
        
        let nib = UINib(nibName: "ShoeTableViewCell", bundle: nil) //設定Cell nib
        tableView.register(nib, forCellReuseIdentifier: "ShoeTableViewCell") //register Cell nib
        
        //        let image = UIImage(systemName: "calendar")
        //        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector())
        
        reloadClosetData()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //            self.sortingList()
        //        }
    }
    
    
    //MARK: Period Menu methods -
    
    func configureButtonMenu() {
        
        periodButton.menu = demoMenu
        //        periodButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        periodButton.showsMenuAsPrimaryAction = true
    }
    
    func getLogCountForDateRange(item: Item, daysBeforeToday: Int) -> Int {
        let calendar = Calendar.current //當前日曆
        
        // 設定篩選日期範圍
        let now = Date()
        let dateFrom = now// 今天 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: -daysBeforeToday, to: dateFrom) // 過去 daysBeforeToday 天
        
        // 確保 dateTo 有值
        guard let dateTo = dateTo else { return 0 }
        
        // 設定 NSPredicate 篩選 logs
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "parentItem == %@", item),
            NSPredicate(format: "logDate >= %@", dateTo as NSDate),
            NSPredicate(format: "logDate < %@", dateFrom as NSDate)
        ])
        
        do {
            let filteredLogs = try context.fetch(fetchRequest)
            return filteredLogs.count
        } catch {
            print("Error fetching filtered logs: \(error)")
            return 0
        }
    }
    
    
    var demoMenu: UIMenu {
        return UIMenu(title: "Days before today", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func periodMenuAction(days: String) {
        self.navTitle.title = days
        self.periodState = days
        self.reloadClosetData()
    }
    
    
    //MARK: SearchBar -
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadClosetData()
    }
    
    @objc func reloadClosetData() { // for the notificationCenter observer
        loadItems()
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    } // 當 ClosetViewController 被釋放時，移除監聽
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        var numberOfSections: Int
        
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeTableViewCell", for: indexPath) as! ShoeTableViewCell
        // 從 `shoeArray` 中取出對應的 `Item`
        let shoe = shoeArray[indexPath.row]
        
        
        cell.shoeTitleLabel?.text = shoe.shoeTitle
        
        if periodState == "7 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 7)
            cell.logCountLabel?.text = String(logCount)
        } else if periodState == "30 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 30)
            cell.logCountLabel?.text = String(logCount)
        } else if periodState == "90 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 90)
            cell.logCountLabel?.text = String(logCount)
        } else if periodState == "180 days" {
            let logCount = getLogCountForDateRange(item: shoe, daysBeforeToday: 180)
            cell.logCountLabel?.text = String(logCount)
        } else {
            let logCount = shoe.logs?.count
            cell.logCountLabel?.text = String(logCount ?? 0)
        }
        
        
        cell.shoeImageView.image = nil  // 先清空圖片，避免顯示錯誤的殘留圖片
        if let data = shoe.shoeImage, let image = UIImage(data: data) {
            cell.shoeImageView.image = image
        } else {
            cell.shoeImageView.image = UIImage(named: "defaultShoe")
        }
        
        cell.shoeImageView.layer.cornerRadius = 5
        
        return cell
    }
    
    //MARK: Sorting Methods -
    
    
    
    func sortingList() {
        shoeArray = shoeArray.sorted {
            ($0.shoeTitle ?? "") < ($1.shoeTitle ?? "")
        }
        tableView.reloadData()
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        performSegue(withIdentifier: "ShoesDetailSegue", sender: cell)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Swipe to delete
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(shoeArray[indexPath.row])
            shoeArray.remove(at: indexPath.row)
            
            saveItems()
        }
    }
    
    
    // MARK: - Move to Add New Shoes Page
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewSegue", sender: self)
        
    }
    
    
    // MARK: - Model Manupulation Methods
    
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
        
        tableView.reloadData()
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - Shoes Detail Data
    
    func dateToString(dateDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // 自訂日期格式，例如：Jan 21, 2025
        formatter.timeStyle = .none  // 不顯示時間
        let formattedDate = formatter.string(from: dateDate)
        
        return formattedDate
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShoesDetailSegue" {
            var stringDate: String? 
            
            if let navController = segue.destination as? UINavigationController, //TERRY
               let destinationVC = navController.topViewController as? ShoesDetailViewController { //TERRY
                if let selectedIndex = tableView.indexPathForSelectedRow?.row {
                    destinationVC.detailBrand = shoeArray[selectedIndex].brand
                    destinationVC.detailSeries = shoeArray[selectedIndex].series
                    destinationVC.detailColorway = shoeArray[selectedIndex].colorway
                    
                    stringDate = dateToString(dateDate: shoeArray[selectedIndex].purchaseDate ?? Date()) // TODO: change default to if let unwrap
                    destinationVC.detailPurchaseDate = stringDate
                    destinationVC.editPurchaseDate = shoeArray[selectedIndex].purchaseDate
                    
                    destinationVC.detailTitle = shoeArray[selectedIndex].shoeTitle
                    destinationVC.selectedItem = shoeArray[selectedIndex]
                    
                    if let data = shoeArray[selectedIndex].shoeImage {
                        if let image = UIImage(data: data) {
                            destinationVC.shoeImage = image
                        }
                    }
                    //                if let indexPath = tableView.indexPathForSelectedRow {
                    //
                }
            }
        }
    }
}


extension ClosetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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








