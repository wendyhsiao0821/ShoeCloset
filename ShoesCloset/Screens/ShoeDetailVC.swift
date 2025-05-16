//
//  ShoeDetailVC.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/30.
//

import UIKit
import CoreData

protocol detailDoneDelegate { func reloadClosetData() }

class ShoeDetailVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var logArray: [Log] = []
    var logDatePicker = UIDatePicker()
    var logTableView = UITableView()
    var logAddButton = GeneralButton(buttonTitle: "Add", backgroundColor: "F2771F")
    
    var shoeTitleLabelStack = UIStackView()
    
    var delegate: detailDoneDelegate?
    
    var detailTitle: String? = "default title"
    var detailBrand: String? = "default brand"
    var detailSeries: String? = "default series"
    var detailColorway: String? = "default colorway"
    var detailPurchaseDate: String? = "default date"
    var editPurchaseDate: Date? = Date()
    let imagePicker = UIImagePickerController()
    var shoePhotoImageView = ImageView(frame: .zero)
    var shoeImage: UIImage? = UIImage(named: "defaultShoe")
    
    var brandLabel = DetailDataView()
    var seriesLabel = DetailDataView()
    var colorwayLabel = DetailDataView()
    var dateLabel = DetailDataView()
    
    var logTitleLabel = UILabel()
    
    var selectedItem : Item? {
        didSet{
            loadLog()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F3F3F3")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissModal))
        
        configureShoeTitleLabelStack()
        configureShoePhotoImageView()
        configureShoeDetail()
        configureLogTitleLabel()
        configureLogDatePicker()
        configureLogTableView()
        setUpDateRange()
        
        loadLog()
    }
    
    
    @objc func dismissModal() {
            dismiss(animated: true, completion: nil)
            delegate?.reloadClosetData()
            
        }
    
    
    func configureLogTableView() {
        view.addSubview(logTableView)
        
        logTableView.isScrollEnabled = true
        logTableView.backgroundColor = .clear
        logTableView.separatorStyle = .none
        
        logTableView.dataSource = self
        logTableView.delegate = self
        logTableView.register(LogCell.self, forCellReuseIdentifier: LogCell.reuseID)
        
        logTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logTableView.topAnchor.constraint(equalTo: logTitleLabel.bottomAnchor, constant: 12),
            logTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 4)
            
        ])
    }
    
    @objc func logAddButtonTapped() {
        if let selectedItem = self.selectedItem {
            let newLog = Log(context: context)
            newLog.logDate = logDatePicker.date
            newLog.parentItem = selectedItem
            self.logArray.append(newLog)
            self.saveItems()
            logTableView.reloadData()
            
            presentGFAlertOnMainThread(title: "New log added.", message: dateToString(dateDate: newLog.logDate!), buttonTitle: "Ok")
        }
    }
    
    
    func setUpDateRange() {
        logDatePicker.minimumDate = selectedItem?.purchaseDate
        logDatePicker.maximumDate = Date()
    }
    
    
    
// MARK: - Configure shoe title label stack
    
    func configureLogTitleLabel() {
        view.addSubview(logTitleLabel)
        logTitleLabel.text = "Worn Log"
        logTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        logTitleLabel.textColor = UIColor(hex: "F2771F")
        
        logTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logTitleLabel.topAnchor.constraint(equalTo: colorwayLabel.bottomAnchor, constant: 32),
            logTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            logTitleLabel.widthAnchor.constraint(equalToConstant: 100),
            logTitleLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
// MARK: - Configure log date picker
    func configureLogDatePicker() {
        view.addSubview(logDatePicker)
        view.addSubview(logAddButton)
        
        logDatePicker.datePickerMode = .date
        logDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        logAddButton.translatesAutoresizingMaskIntoConstraints = false
        logAddButton.layer.cornerRadius = 8
        logAddButton.addTarget(self, action: #selector(logAddButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logDatePicker.topAnchor.constraint(equalTo: colorwayLabel.bottomAnchor, constant: 32),
            logDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            logDatePicker.widthAnchor.constraint(equalToConstant: 92),
            logDatePicker.heightAnchor.constraint(equalToConstant: 32),
            
            logAddButton.topAnchor.constraint(equalTo: colorwayLabel.bottomAnchor, constant: 32),
            logAddButton.leadingAnchor.constraint(equalTo: logDatePicker.trailingAnchor, constant: 4),
            logAddButton.widthAnchor.constraint(equalToConstant: 56),
            logAddButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    
// MARK: - Configure shoe detail labels
    func configureShoeDetail() {
        view.addSubview(brandLabel)
        view.addSubview(seriesLabel)
        view.addSubview(colorwayLabel)
        view.addSubview(dateLabel)
        
        seriesLabel.titleLabel.text = "Series"
        seriesLabel.detailLabel.text = detailSeries
        
        colorwayLabel.titleLabel.text = "Colorway"
        colorwayLabel.detailLabel.text = detailColorway
        
        brandLabel.titleLabel.text = "Brand"
        brandLabel.detailLabel.text = detailBrand
        
        dateLabel.titleLabel.text = "Purchase Date"
        dateLabel.detailLabel.text = detailPurchaseDate
        
        seriesLabel.translatesAutoresizingMaskIntoConstraints = false
        colorwayLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        brandLabel.setContentHuggingPriority(.required, for: .vertical)
        brandLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        seriesLabel.setContentHuggingPriority(.required, for: .vertical)
        seriesLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        colorwayLabel.setContentHuggingPriority(.required, for: .vertical)
        colorwayLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        dateLabel.setContentHuggingPriority(.required, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        
        
        NSLayoutConstraint.activate([
            brandLabel.topAnchor.constraint(equalTo: shoeTitleLabelStack.bottomAnchor, constant: 32),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            brandLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
//            brandLabel.heightAnchor.constraint(equalToConstant: 72),
            
            seriesLabel.topAnchor.constraint(equalTo: shoeTitleLabelStack.bottomAnchor, constant: 32),
            seriesLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            seriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
//            seriesLabel.heightAnchor.constraint(equalToConstant: 72),
            
            colorwayLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 12),
            colorwayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorwayLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
//            colorwayLabel.heightAnchor.constraint(equalToConstant: 72),
            
            dateLabel.topAnchor.constraint(equalTo: seriesLabel.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
//            dateLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    
    // MARK: - Configure shoe photo image view
    func configureShoePhotoImageView() {
        view.addSubview(shoePhotoImageView)
        shoePhotoImageView.image = shoeImage
        
        shoePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shoePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            shoePhotoImageView.leadingAnchor.constraint(equalTo: shoeTitleLabelStack.trailingAnchor, constant: 16),
            shoePhotoImageView.widthAnchor.constraint(equalToConstant: 96),
            shoePhotoImageView.heightAnchor.constraint(equalToConstant: 96)
        ])
        
    }
    
    
    // MARK: - Configure shoe title label stack
    func configureShoeTitleLabelStack() {
        func createTitleLabel(with text: String?) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            label.textColor = UIColor(hex: "F2771F")
            label.minimumScaleFactor = 0.5
            label.adjustsFontSizeToFitWidth = true
            return label
        }

        shoeTitleLabelStack.axis = .vertical
        shoeTitleLabelStack.alignment = .leading
        shoeTitleLabelStack.distribution = .fillEqually
        shoeTitleLabelStack.spacing = 0

        let labels = [detailBrand, detailSeries, detailColorway].map { createTitleLabel(with: $0) }
        labels.forEach { shoeTitleLabelStack.addArrangedSubview($0) }

        view.addSubview(shoeTitleLabelStack)
        shoeTitleLabelStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            shoeTitleLabelStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            shoeTitleLabelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            shoeTitleLabelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -134),
            shoeTitleLabelStack.heightAnchor.constraint(equalToConstant: 100)
        ])
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


extension ShoeDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if logArray.count > 0 {
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))

            tableView.backgroundView = noDataLabel
            
            noDataLabel.text = "No history of wearing it."
            noDataLabel.textColor = .systemGray
            noDataLabel.textAlignment = .center
            
        }
        return logArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = logTableView.dequeueReusableCell(withIdentifier: LogCell.reuseID) as! LogCell
        
        if let log = logArray[indexPath.row].logDate {
            cell.logDateLabel.text = dateToString(dateDate: log)
        } else {
            cell.logDateLabel.text = "No Date"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "🗑️") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }

            self.context.delete(self.logArray[indexPath.row])
            self.logArray.remove(at: indexPath.row)
            self.saveItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(hex: "F3F3F3")
      
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
