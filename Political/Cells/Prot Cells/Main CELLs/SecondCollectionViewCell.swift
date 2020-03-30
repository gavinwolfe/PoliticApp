//
//  SecondMainTableviewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 10/26/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {
    
    
    var buttonExternalLink = UIButton()
    var externalImage = UIImageView()
    var titlerLabel = UILabel()
    var imagerView = UIImageView()
    var timeLabel = UILabel()
    var activeView = UIView()
    var activeLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        // Initialization code
    }
      let shapeLayer = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    override func layoutSubviews() {
        activeView.backgroundColor = UIColor(red: 0.9961135983467102, green: 0.2821864187717438, blue: 0.22698186337947845, alpha: 1.0)
        activeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //print("iPhone 5 or 5S or 5C")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
            case 1334:
                //print("iPhone 6/6S/7/8")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
            case 1920, 2208:
                // print("iPhone 6+/6S+/7+/8+")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
            case 2436:
                //print("iPhone X, XS")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
            case 2688:
                //print("iPhone XS Max")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
            case 1792:
                //print("iPhone XR")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
            default:
                print("Unknown")
            }
        } else {
            if UIDevice().userInterfaceIdiom == .pad {
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 28)
                
            }
        }
        self.imagerView.isUserInteractionEnabled = true 
      //  externalImage.image = #imageLiteral(resourceName: "feedChat")
        externalImage.contentMode = .scaleAspectFill
        externalImage.isUserInteractionEnabled = true
        buttonExternalLink.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        buttonExternalLink.setTitle("", for: .normal)
        externalImage.layer.cornerRadius = 20.0
        externalImage.layer.shadowColor = UIColor.black.cgColor
        externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
         externalImage.layer.shadowOpacity = 1
        activeLabel.textColor = .white
        
        titlerLabel.textColor = .white
        timeLabel.textColor = .lightGray
        timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        timeLabel.textAlignment = .left
        activeLabel.textAlignment = .center
        titlerLabel.textAlignment = .left
        titlerLabel.sizeToFit()
        titlerLabel.numberOfLines = 0
        timeLabel.textAlignment = .left
        imagerView.contentMode = .scaleAspectFill
        contentView.addSubview(imagerView)
        contentView.addSubview(titlerLabel)
        contentView.addSubview(timeLabel)
        activeView.addSubview(activeLabel)
       contentView.addSubview(activeView)
        contentView.addSubview(externalImage)
       // externalImage.addSubview(buttonExternalLink)
        imagerView.clipsToBounds = true 
//        imagerView.translatesAutoresizingMaskIntoConstraints = false
//        imagerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        imagerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//        imagerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        imagerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        imagerView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
      
        timeLabel.frame = CGRect(x: 15, y: contentView.frame.height - 28, width: 100, height: 25)
        
        titlerLabel.translatesAutoresizingMaskIntoConstraints = false
        //    label1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        titlerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        titlerLabel.trailingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: -10).isActive = true
        titlerLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
        
        activeView.frame = CGRect(x: contentView.frame.width - 30, y: contentView.frame.height - 30, width: 26, height: 26)
        activeLabel.frame = CGRect(x: -5, y: 0, width: 34, height: 24)
        externalImage.frame = CGRect(x: contentView.frame.width - 60, y: contentView.frame.height - 30, width: 25, height: 25)
        titlerLabel.layer.shadowColor = UIColor.black.cgColor
        titlerLabel.layer.shadowRadius = 3.0
        titlerLabel.layer.shadowOpacity = 1.0
        titlerLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titlerLabel.layer.masksToBounds = false
        timeLabel.layer.shadowColor = UIColor.black.cgColor
        timeLabel.layer.shadowRadius = 3.0
        timeLabel.layer.shadowOpacity = 1.0
        timeLabel.shadowOffset = CGSize(width: 4, height: 4)
        
        
        
       activeLabel.textAlignment = .center
        activeView.layer.cornerRadius = activeView.frame.width / 2
        activeView.clipsToBounds = true
        shapeLayer.lineWidth = 49.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: imagerView.frame.width - 36, y: -15))
        path.addLine(to: CGPoint(x:  imagerView.frame.width+21, y: 90))
        
        shapeLayer.path = path.cgPath
      
        imagerView.layer.addSublayer(shapeLayer)
       
        
    
    
        
        
    }
    
    
    
  
    
    let button1: UIButton = {
        let buttonReturn = UIButton()
        buttonReturn.setTitle("", for: .normal)
        return buttonReturn
    }()
    let button2: UIButton = {
        let buttonReturn2 = UIButton()
        buttonReturn2.setTitle("", for: .normal)
        return buttonReturn2
    }()
    
  
}



