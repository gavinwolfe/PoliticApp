//
//  SearchCollectionViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 10/29/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
//    let imagerview: UIImageView = {
//        let imagerView = UIImageView()
//        imagerView.contentMode = .scaleAspectFill
//        imagerView.clipsToBounds = true
//        return imagerView
//    }()
//
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelMain.frame = CGRect(x: 0, y: 5, width: contentView.frame.width, height: contentView.frame.height - 10)
        labelMain.textAlignment = .center
        labelMain.numberOfLines = 0
        labelMain.font = UIFont(name: "Verdana", size: 18)
        labelMain.textColor = .white
       
        contentView.addSubview(labelMain)
    }

    var labelMain = UILabel()
   
    @IBOutlet weak var mainImagerView: UIImageView!
    
    override func awakeFromNib() {
       super.awakeFromNib()
        self.layoutIfNeeded()
      
        
//        contentView.addSubview(mainImagerView)
//        mainImagerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        mainImagerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive
//        mainImagerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
//        mainImagerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
    }
   
    
}
