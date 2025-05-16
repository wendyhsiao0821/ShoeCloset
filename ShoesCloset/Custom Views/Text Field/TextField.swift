//
//  TextField.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/26.
//

import UIKit

class TextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    convenience init(/*placeholderText: String*/) {
        self.init(frame: .zero)
//        self.placeholder = placeholderText
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        backgroundColor = .white

        textColor = .black
        tintColor = .black
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 17, weight: .regular)
        adjustsFontSizeToFitWidth = false
        minimumFontSize = 12

    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
}
