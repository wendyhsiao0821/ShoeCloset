//
//  ImageView.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/4/26.
//

import UIKit

class ImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(shoeImage: UIImage) {
        self.init(frame: .zero)
        self.image = shoeImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .white
        contentMode = .scaleAspectFit
    }
    

}
