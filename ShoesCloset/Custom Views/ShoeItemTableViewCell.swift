//
//  ShoeItemTableViewCell.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/20.
//

import UIKit

class ShoeItemTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    let shoeCellImageView = UIImageView(frame: .zero)
    let upperTitleLabel = UILabel()
    let colorTitleLabel = UILabel()
    let wornCountTitleLabel = UILabel()
    let wornCountLabel = UILabel()
    
    static let reuseID = "ShoeItemCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        setUpContainer()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpContainer() {
        
        contentView.addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            containerView.heightAnchor.constraint(equalToConstant: 84)
        ])
    }
    
    func setUpCell(image: UIImage, brand: String, series: String, colorway: String, count: Int) {
        shoeCellImageView.image = image
        upperTitleLabel.text = brand + " " + series
        colorTitleLabel.text = colorway
        wornCountTitleLabel.text = "Worn Count"
        wornCountLabel.text = String(count)
    }

    
    func configure() {
        
        [shoeCellImageView, upperTitleLabel, colorTitleLabel, wornCountTitleLabel, wornCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        wornCountLabel.textAlignment = .right
        wornCountLabel.textColor = UIColor(hex: "F2771F")
        wornCountLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        wornCountTitleLabel.font = .systemFont(ofSize: 9)
        wornCountTitleLabel.textColor = .systemGray3
        
        upperTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        colorTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        shoeCellImageView.translatesAutoresizingMaskIntoConstraints = false
        upperTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        colorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wornCountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        wornCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shoeCellImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            shoeCellImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 23),
            shoeCellImageView.widthAnchor.constraint(equalToConstant: 56),
            shoeCellImageView.heightAnchor.constraint(equalToConstant: 56),
            
            upperTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 19),
            upperTitleLabel.leadingAnchor.constraint(equalTo: shoeCellImageView.trailingAnchor, constant: 16),
            upperTitleLabel.widthAnchor.constraint(equalToConstant: 202),
            upperTitleLabel.bottomAnchor.constraint(equalTo: colorTitleLabel.topAnchor, constant: -4),
            
            colorTitleLabel.topAnchor.constraint(equalTo: upperTitleLabel.bottomAnchor, constant: 4),
            colorTitleLabel.leadingAnchor.constraint(equalTo: upperTitleLabel.leadingAnchor),
            colorTitleLabel.widthAnchor.constraint(equalToConstant: 202),
            colorTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -21),
            
            wornCountTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 17.5),
            wornCountTitleLabel.leadingAnchor.constraint(equalTo: upperTitleLabel.trailingAnchor),
            wornCountTitleLabel.widthAnchor.constraint(equalToConstant: 53),
            wornCountTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            wornCountLabel.topAnchor.constraint(equalTo: wornCountTitleLabel.bottomAnchor, constant: 3),
            wornCountLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -19),
            wornCountLabel.leadingAnchor.constraint(equalTo: upperTitleLabel.trailingAnchor),
            wornCountLabel.widthAnchor.constraint(equalToConstant: 53),
            wornCountLabel.heightAnchor.constraint(equalToConstant: 22),
            
        ])
        
        
    }
}
