//
//  PurchaseDateTitle.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/29.
//

import UIKit

class PurchaseDateTitle: UIView {

    
    let titleLabel = UILabel()
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(titleText: String/*, placeholderText: String*/) {
        self.init(frame: .zero)
        titleLabel.text = titleText
//        textField.placeholder = placeholderTextp
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(datePicker)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact

        datePicker.maximumDate = Date()

        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 48),
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
    }


}
