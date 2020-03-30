//
//  TrendingTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 10/27/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class TrendingTableViewCell: UITableViewCell {

    var titleLabel = UILabel()
    var externalImage = UIImageView()
    var buttonExternalLink = UIButton()
    var imagerView = UIImageView()
    var timeLabel = UILabel()
    var labelPubli = UILabel()
     let shapeLayer = CAShapeLayer()
     let imageViewCircleUnseen = UIImageView()
    override func layoutSubviews() {
        
        imagerView.contentMode = .scaleAspectFill
        contentView.backgroundColor = .darkText
        imagerView.clipsToBounds = true
        imagerView.layer.cornerRadius = 8
        titleLabel.textColor = .lightGray
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
        
        
      
               self.imagerView.isUserInteractionEnabled = true
           
        
        timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .left
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 4
        
        externalImage.layer.cornerRadius = 20.0
               externalImage.layer.shadowColor = UIColor.black.cgColor
               externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
                externalImage.layer.shadowOpacity = 1
               externalImage.isUserInteractionEnabled = true
       
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imagerView)
        contentView.addSubview(timeLabel)
        
        contentView.addSubview(labelPubli)
        contentView.addSubview(imageViewCircleUnseen)
        imagerView.addSubview(externalImage)
        externalImage.addSubview(buttonExternalLink)
        
        self.imagerView.frame = CGRect(x: 15, y: 30, width: 170, height: 110)
        //self.titleLabel.frame = CGRect(x: width - 182, y: 40, width: 176, height: 90)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
        
        //timeLabel.frame = CGRect(x: width - 182, y: 126, width: 80, height: 20)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
        labelPubli.textColor = .lightGray
        labelPubli.numberOfLines = 1
        labelPubli.setLineHeight(lineHeight: 5)
        labelPubli.font = UIFont(name: "Courier", size: 14)
        labelPubli.frame = CGRect(x: 15, y: 2, width: 300, height: 25)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: imagerView.frame.width - 25, y: -15))
        path.addLine(to: CGPoint(x: imagerView.frame.width+20, y: imagerView.frame.height+15))
        shapeLayer.lineWidth = 40.0
        shapeLayer.path = path.cgPath
        imagerView.layer.addSublayer(shapeLayer)
        imageViewCircleUnseen.frame = CGRect(x: contentView.frame.width - 40, y: 0, width: 24, height: 24)
        externalImage.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        externalImage.image = #imageLiteral(resourceName: "respondSend")
        externalImage.contentMode = .scaleAspectFill
        externalImage.isUserInteractionEnabled = true
        buttonExternalLink.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 26)
        buttonExternalLink.setTitle("", for: .normal)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                titleLabel.numberOfLines = 4
                self.imagerView.frame = CGRect(x: 15, y: 43, width: 140, height: 100)
               
                
            default:
                 print("Unknown")
            }
        } 
        
        
    }
   
   

}
