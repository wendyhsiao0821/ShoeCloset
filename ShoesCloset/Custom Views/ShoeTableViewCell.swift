//
//  ShoeTableViewCell.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/2/4.
//

import UIKit

class ShoeTableViewCell: UITableViewCell {

    @IBOutlet var shoeTitleLabel: UILabel!
    @IBOutlet var logCountLabel: UILabel!
    
    @IBOutlet var shoeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
