//
//  dropDownList.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/19.
//

import UIKit

enum DaysType: String {
    case seven = "7 days"
    case thirty = "30 days"
    case ninety = "90 days"
}

class dropDownList {
    
    let dataSource = ["7 days", "30 days", "90 days", "180 days", "All time"]
    
    let actionClosure = { (action: UIAction) in
        print(action.title)
    }
    
    public let button = UIButton(primaryAction: nil)
    
    var menuChildren: [UIMenuElement] = []
    
    
    func configure() {
        
        //button data set up
        for period in dataSource {
            menuChildren.append(UIAction(title: period, handler: actionClosure))
        }
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        //button appearance
        button.setTitle("Select Period", for: .normal)
        
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10

        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        

    }
    

    
    
  
}
