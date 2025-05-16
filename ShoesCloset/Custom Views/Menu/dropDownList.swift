//
//  dropDownList.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/19.
//

import UIKit
protocol dropDownListDelegate {
    func editPeriodState(state: String)
}

enum DaysType: String, CaseIterable {
    case seven = "7 days"
    case thirty = "30 days"
    case ninety = "90 days"
    case oneEighty = "180 days"
    case allTime = "All time"
}


class DropDownList {
    
    var delegate : dropDownListDelegate?
    
    public let button = UIButton(primaryAction: nil)
    var menuChildren: [UIMenuElement] = []
    var selectedType: DaysType?

    func configure() {
        for type in DaysType.allCases {
            let action = UIAction(title: type.rawValue, handler: { [weak self] _ in
                self?.selectedType = type
                self?.handleSelection(for: type)
            })
            menuChildren.append(action)
        }
        
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        button.setTitle("Select Period", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .light)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    

    private func handleSelection(for type: DaysType) {
        
        switch type {
        case .seven:
            delegate?.editPeriodState(state: "7 days")
        case .thirty:
            delegate?.editPeriodState(state: "30 days")
        case .ninety:
            delegate?.editPeriodState(state: "90 days")
        case .oneEighty:
            delegate?.editPeriodState(state: "180 days")
        case .allTime:
            delegate?.editPeriodState(state: "all")
        }
}
}


    
  

