//
//  AlertContainerView.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/30.
//

import UIKit

class AlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = UIColor(hex: "F3F3F3")
        layer.borderWidth = 2
        layer.cornerRadius = 16
        layer.borderColor = UIColor.darkGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

}
