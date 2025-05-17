//
//  ShoeDetailVCViewModel.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/5/17.
//

import UIKit
import CoreData

class ShoeDetailViewModel {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedItem: Item? {
        didSet {
            loadLog()
        }
    }

    var logArray: [Log] = []

    var onLogUpdated: (() -> Void)?
    
    var isLogEmpty: Bool {
        return logArray.isEmpty
    }

    func addLog(for date: Date) {
        guard let item = selectedItem else { return }
        let newLog = Log(context: context)
        newLog.logDate = date
        newLog.parentItem = item
        logArray.append(newLog)
        saveItems()
        onLogUpdated?()
    }

    func deleteLog(at index: Int) {
        guard logArray.indices.contains(index) else { return }
            context.delete(logArray[index])
            logArray.remove(at: index)
            saveItems()
            onLogUpdated?()
    }

    func setUpDateRange(for picker: UIDatePicker) {
        picker.minimumDate = selectedItem?.purchaseDate
        picker.maximumDate = Date()
    }

    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }

    private func loadLog() {
        guard let title = selectedItem?.shoeTitle else { return }
        let request: NSFetchRequest<Log> = Log.fetchRequest()
        let predicate = NSPredicate(format: "parentItem.shoeTitle MATCHES %@", title)
        request.predicate = predicate

        do {
            logArray = try context.fetch(request)
            onLogUpdated?()
        } catch {
            print("Error fetching logs: \(error)")
        }
    }
}
