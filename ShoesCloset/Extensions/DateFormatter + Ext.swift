//
//  DateFormatter + Ext.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/30.
//

import UIKit

extension UIViewController {
    
    func dateToString(dateDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // 自訂日期格式，例如：Jan 21, 2025
        formatter.timeStyle = .none  // 不顯示時間
        let formattedDate = formatter.string(from: dateDate)
        
        return formattedDate
    }
}
