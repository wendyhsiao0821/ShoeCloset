//
//  AddPageButton.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/20.
//

import UIKit

class AddPageButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(imageName: String, imageColor: String) {
        self.init(frame: .zero)
        set(image: imageName, color: imageColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        configuration = .plain()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(image: String, color: String) {
        
        self.setImage(UIImage(systemName: image), for: .normal)
        self.tintColor = UIColor(hex: color)
//        self.tintColor = UIColor(hex: "F2771F", alpha: 1)
    }
}
