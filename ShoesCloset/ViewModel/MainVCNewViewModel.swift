//
//  MainVCNewViewModel.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/5/16.
//

import UIKit
import CoreData

class MainVCNewViewModel {
    
    var shoeArray: [Item] = []
    var periodState: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var onDataUpdated: (() -> Void)?
    
//    var filteredShoes: [Item] {
//        return shoeArray
//    }
    
    var filteredShoes: [Item] {
        if periodState == "7 days" || periodState == "30 days" || periodState == "90 days" || periodState == "180 days" {
            return shoeArray.filter { item in
                getLogCount(for: item) > 0
            }
        } else {
                return shoeArray
            }
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
            onDataUpdated?()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    
    func saveItems() {
        do {
            try context.save()
            onDataUpdated?()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    
    func getLogCount(for item: Item) -> Int {
        if periodState == "7 days" {
            let logCount = getLogCountForDateRange(item: item, daysBeforeToday: 7)
            return logCount
        } else if periodState == "30 days" {
            let logCount = getLogCountForDateRange(item: item, daysBeforeToday: 30)
            return logCount
        } else if periodState == "90 days" {
            let logCount = getLogCountForDateRange(item: item, daysBeforeToday: 90)
            return logCount
        } else if periodState == "180 days" {
            let logCount = getLogCountForDateRange(item: item, daysBeforeToday: 180)
            return logCount
        } else {
            let logCount = item.logs?.count
            return logCount ?? 0
        }
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
    
    
    func cellDeleteMethod(indexPath: IndexPath) {
        context.delete(shoeArray[indexPath.row])
        shoeArray.remove(at: indexPath.row)
        saveItems()
    }
    
    
    func setPeriodState(_ state: String) {
        self.periodState = state
        onDataUpdated?()
    }
}
