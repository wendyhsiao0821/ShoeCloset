//
//  ShoesDetailViewController.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/1/16.
//

import UIKit
import CoreData

class ShoesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var topNavigator: UINavigationBar!
    @IBOutlet var logTableView: UITableView!
    @IBOutlet var shoePhotoImageView: UIImageView!
    
    var logArray: [Log] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var detailTitle: String? = "default title"
    var detailBrand: String? = "default brand"
    var detailSeries: String? = "default series"
    var detailColorway: String? = "default colorway"
    var detailPurchaseDate: String? = "default date"
    let imagePicker = UIImagePickerController()
    var shoeImage: UIImage? = UIImage(named: "shoe1")
    
    var selectedItem : Item? {
        didSet{
            loadLog()
        }
    }
    
    
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var seriesLabel: UILabel!
    @IBOutlet var colorwayLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logTableView.isScrollEnabled = true
        topNavigator.topItem?.title = detailTitle
        
        shoePhotoImageView.layer.borderWidth = 0.8
        shoePhotoImageView.layer.borderColor = UIColor.gray.cgColor
        shoePhotoImageView.layer.cornerRadius = 8
        shoePhotoImageView.image = shoeImage
     
        
//        topNavigator.topItem?.rightBarButtonItem?.action = #selector(closeDetailModal(_:))
        
        brandLabel.text = detailBrand
        seriesLabel.text = detailSeries
        colorwayLabel.text = detailColorway
        dateLabel.text = detailPurchaseDate
        
        logTableView.dataSource = self
        logTableView.delegate = self
        logTableView.register(UITableViewCell.self, forCellReuseIdentifier: "logCell")
        
        
//        logTableView.reloadData()
        loadLog()
    }
    
    @IBAction func closeDetailModal(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

    
     
    
    //MARK: TABLE VIEW PART -
    
    //MARK: Dismiss Detail VC -
    
    override func viewWillDisappear(_ animated: Bool) { //NEW
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DidUpdateShoes"), object: nil)
    }
    
    //MARK: UITableViewDataSource Methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath)
        
        if let log = logArray[indexPath.row].logDate {
            cell.textLabel?.text = getDateString(date: log)
        } else {
            cell.textLabel?.text = "No Date"
        }
        
        return cell
    }
    
    
    func getDateString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // 自訂日期格式，例如：Jan 21, 2025
        formatter.timeStyle = .none  // 不顯示時間
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    
    //MARK: Picked the date -
    
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBAction func dateAddPressed(_ sender: UIButton) {
        
        if let selectedItem = self.selectedItem {
            let newLog = Log(context: context)
            newLog.logDate = datePicker.date
            newLog.parentItem = selectedItem
            self.logArray.append(newLog)
            self.saveItems()
            logTableView.reloadData()
            
            let controller = UIAlertController(title: "New log added.", message: getDateString(date: newLog.logDate!), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Done", style: .default)
            controller.addAction(okAction)
            present(controller, animated: true)
            
//            guard let logs = selectedItem.logs else {
//
//                    print("count print error")
//                    return
//                }
//                print("目前 log 數量：\(logs.count)")
//        } else {
//            print("Error: selectedItem is nil")
        }
    }
    
    //MARK: Swipe to delete log -
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
        context.delete(logArray[indexPath.row])
        logArray.remove(at: indexPath.row)
          
        saveItems()
        logTableView.reloadData()
      }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false // 禁止高亮，代表不可點選
    }
    
    
    //MARK: Core data manipulation function TODO: refact all core data function to a class -
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadLog(with request : NSFetchRequest<Log> = Log.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let ItemPredicate = NSPredicate(format: "parentItem.shoeTitle MATCHES %@", selectedItem!.shoeTitle!)
        

        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ItemPredicate, addtionalPredicate])
        } else {
            request.predicate = ItemPredicate
        }
        
        do {
            logArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
//        logTableView.reloadData()
    }
    

}

//MARK: UIPhotoPicker -

extension ShoesDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func openImagePicker(_ sender: UIButton) {
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            shoePhotoImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Handle the user canceling the image picker, if needed.
        dismiss(animated: true, completion: nil)
    }
}
