//
//  StarsCollectionViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 3/23/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class StarsCollectionViewCell: UICollectionViewCell {
    let imagerView = UIImageView()
    
    override func layoutSubviews() {
        contentView.addSubview(imagerView)
        imagerView.translatesAutoresizingMaskIntoConstraints = false
        imagerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        imagerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        imagerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imagerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        imagerView.backgroundColor = .clear
    }
}
