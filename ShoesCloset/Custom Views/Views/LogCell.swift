//
//  LogCell.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/5/2.
//

import UIKit

class LogCell: UITableViewCell {
    
    let logContainerView = UIView()
    let logDateLabel = UILabel()

    static let reuseID = "LogCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = true
        
        setUpLogContainer()
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpLogContainer() {
        contentView.addSubview(logContainerView)
        
        logContainerView.translatesAutoresizingMaskIntoConstraints = false
        logContainerView.backgroundColor = .white
        logContainerView.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            logContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            logContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            logContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            logContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
        ])
    }
    
    
    func configure() {
        logContainerView.addSubview(logDateLabel)
        logDateLabel.translatesAutoresizingMaskIntoConstraints = false
        logDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        logDateLabel.textColor = .black
        
        NSLayoutConstraint.activate([
//            logDateLabel.topAnchor.constraint(equalTo: logContainerView.topAnchor, constant: 7),
//            logDateLabel.bottomAnchor.constraint(equalTo: logContainerView.bottomAnchor, constant: -7),
            logDateLabel.centerYAnchor.constraint(equalTo: logContainerView.centerYAnchor),
            logDateLabel.heightAnchor.constraint(equalToConstant: 24),
            logDateLabel.leadingAnchor.constraint(equalTo: logContainerView.leadingAnchor, constant: 20),
            logDateLabel.trailingAnchor.constraint(equalTo: logContainerView.trailingAnchor, constant: -20),
        ])
    }

}
