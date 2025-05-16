//
//  GeneralButton.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/29.
//

import UIKit

class GeneralButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(buttonTitle: String, backgroundColor: String) {
        self.init(frame: .zero)
        set(text: buttonTitle, color: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        configuration = .plain()
        self.layer.cornerRadius = 18
        self.setTitleColor(.white, for: .normal)
        
//        self.tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(text: String, color: String) {

        self.backgroundColor = UIColor(hex: color)
        self.setTitle(text, for: .normal)
    }

}
