//
//  ThirdSearchTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 10/30/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class ThirdSearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        imagerView.layer.cornerRadius = imagerView.frame.width / 2
        imagerView.clipsToBounds = true 
        contentView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var imagerView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followerCount: UILabel!
}
