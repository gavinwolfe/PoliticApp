//
//  AUserTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 3/22/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class AUserTableViewCell: UITableViewCell {

    var externalButton = UIButton()
       var externalImage = UIImageView()
    var titleLabel = UILabel()
    var imagerView = UIImageView()
    var timeLabel = UILabel()
    var labelPubli = UILabel()
     var captionLabel = UILabel()
      let shapeLayer = CAShapeLayer()
    var captionImage = UIImageView()
    var publisherImage = UIImageView()
    
    
    override func layoutSubviews() {
        self.publisherImage.frame = CGRect(x: 15, y: 20, width: 120, height: 20)
        self.publisherImage.contentMode = .scaleAspectFit
        self.publisherImage.clipsToBounds = true
        imagerView.contentMode = .scaleAspectFill
        contentView.backgroundColor = .darkText
        imagerView.clipsToBounds = true
        imagerView.layer.cornerRadius = 8
        titleLabel.textColor = .white
       // titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
        titleLabel.textColor = .white
        timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .left
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 0
        captionLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        captionLabel.textColor = UIColor(red: 0, green: 0.5294, blue: 1, alpha: 1.0)
        captionLabel.numberOfLines = 3
        externalImage.image = #imageLiteral(resourceName: "xternal")
               externalImage.contentMode = .scaleAspectFill
               externalImage.isUserInteractionEnabled = true
               externalButton.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        self.imagerView.isUserInteractionEnabled = true
               externalButton.setTitle("", for: .normal)
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imagerView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(labelPubli)
          contentView.addSubview(captionLabel)
         contentView.addSubview(publisherImage)
        //imagerView.addSubview(externalImage)
               externalImage.addSubview(externalButton)
        
        externalImage.layer.cornerRadius = 20.0
        externalImage.layer.shadowColor = UIColor.black.cgColor
        externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
         externalImage.layer.shadowOpacity = 1
        externalImage.isUserInteractionEnabled = true
            imagerView.isUserInteractionEnabled = true 
        
           self.selectionStyle = .none 
        self.imagerView.frame = CGRect(x: 15, y: 43, width: 170, height: 100)
        externalImage.frame = CGRect(x: 5, y: 5, width: 23, height: 23)
        //self.titleLabel.frame = CGRect(x: width - 182, y: 40, width: 176, height: 90)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
        
        //timeLabel.frame = CGRect(x: width - 182, y: 126, width: 80, height: 20)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: captionLabel.topAnchor, constant: 0).isActive = true
        
        labelPubli.textColor = .lightGray
        labelPubli.numberOfLines = 1
        labelPubli.setLineHeight(lineHeight: 5)
        labelPubli.font = UIFont(name: "Courier", size: 14)
        labelPubli.frame = CGRect(x: 15, y: 8, width: 300, height: 30)
        
        captionImage.frame = CGRect(x: 10, y: imagerView.frame.height + 65, width: 35, height: 35)
        captionImage.layer.cornerRadius = 17.5
        captionImage.clipsToBounds = true
        captionImage.contentMode = .scaleAspectFill
        contentView.addSubview(captionImage)
        
        
             
        
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: imagerView.bottomAnchor, constant: 8).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: captionImage.trailingAnchor, constant: 8).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        shapeLayer.lineWidth = 40.0
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
               
                    print("iPhone 5 or 5S or 5C")
                 self.imagerView.frame = CGRect(x: 15, y: 43, width: 140, height: 100)
                titleLabel.numberOfLines = 4
            case 1334:
                print("iPhone 6/6S/7/8")
                titleLabel.numberOfLines = 4
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
                titleLabel.numberOfLines = 5
            case 2436:
                print("iPhone X, XS")
                titleLabel.numberOfLines = 4
            case 2688:
                print("iPhone XS Max")
                titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
                titleLabel.numberOfLines = 5
            case 1792:
                print("iPhone XR")
                titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
                titleLabel.numberOfLines = 4
            default:
                print("Unknown")
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 26)
            //titleLabel.numberOfLines = 4
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: imagerView.frame.width - 25, y: -15))
        path.addLine(to: CGPoint(x: imagerView.frame.width+20, y: imagerView.frame.height+15))
        
        shapeLayer.path = path.cgPath
        imagerView.layer.addSublayer(shapeLayer)
        
        
        
    }
}