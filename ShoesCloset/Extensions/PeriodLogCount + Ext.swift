//
//  PeriodLogCount + Ext.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/21.
//

import UIKit
import CoreData

extension MainVCNewViewModel {
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
}
