//
//  DetailDataView.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/30.
//

import UIKit

class DetailDataView: UIView {
    
    var titleLabel = UILabel()
    var detailLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String, detail: String) {
        self.init(frame: .zero)
        titleLabel.text = title
        detailLabel.text = detail
        
    }
    
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        detailLabel.isEditable = false
//        detailLabel.isScrollEnabled = true
//        detailLabel.backgroundColor = .clear

        
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textAlignment = .left
    
        
        detailLabel.textColor = .black
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailLabel.textAlignment = .left
        detailLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            detailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            detailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            detailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
            
        ])
        
    }

}
