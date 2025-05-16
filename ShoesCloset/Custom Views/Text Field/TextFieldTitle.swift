//
//  TextField+Title.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/26.
//

import UIKit

class TextFieldTitle: UIView {
    
    let titleLabel = UILabel()
    let textField = TextField()
    
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
        addSubview(textField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }


}
