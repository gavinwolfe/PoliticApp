//
//  SelectedTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 10/24/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class SelectedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    contentView.addSubview(textviewet)
    textviewet.translatesAutoresizingMaskIntoConstraints = false
    textviewet.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    textviewet.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    textviewet.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
    textviewet.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true

    }

    let textviewet: UILabel = {
        let textviewly = UILabel()
        textviewly.numberOfLines = 0
        textviewly.font = UIFont(name: "HelveticaNeue", size: 14)
        textviewly.contentMode = .left

        return textviewly
    }()


    override func layoutSubviews() {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }




     func setUp () {
    }

}

