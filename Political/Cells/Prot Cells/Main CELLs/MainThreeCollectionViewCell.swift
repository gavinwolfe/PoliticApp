//
//  MainThreeTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 4/12/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class MainThreeCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var externalButton = UIButton()
    var externalImage = UIImageView()
    let shapeLayer = CAShapeLayer()
    let labelPubli = UILabel()
     var publisherImageView = UIImageView()
    var titlerLabel = UILabel()
   var timeLabel = UILabel()
    var activeLabel = UILabel()
   var activeView = UIView()
    var activeNumberLabel = UILabel()
    var imagerView = UIImageView()
    var likeImageView = UIImageView()
   var percentLabel = UILabel()
   var viewLabel = UILabel()
   var dislikeImageView = UIImageView()
    
    override func layoutSubviews() {
        
        imagerView.contentMode = .scaleAspectFill
        activeView.backgroundColor = UIColor(red: 0.9961135983467102, green: 0.2821864187717438, blue: 0.22698186337947845, alpha: 1.0)
        activeLabel.text = "active"
        activeLabel.textColor = .lightGray
        activeLabel.textAlignment = .center
        titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
        titlerLabel.textColor = .white 
        timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .left
        viewLabel.textColor = .lightGray
        viewLabel.font = UIFont(name: "AvenirNext-Regular", size: 13)
        viewLabel.textAlignment = .left
      //  externalImage.image = #imageLiteral(resourceName: "feedChat")
        externalImage.contentMode = .scaleAspectFill
        externalImage.isUserInteractionEnabled = true
        externalButton.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        self.imagerView.isUserInteractionEnabled = true
        externalButton.setTitle("", for: .normal)
//        likeImageView.image = UIImage(named: "up1")
//        dislikeImageView.image = UIImage(named: "down1")
        percentLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        percentLabel.textAlignment = .center
        titlerLabel.numberOfLines = 4
        activeLabel.font = UIFont(name: "AvenirNext-Medium", size: 13)
        activeNumberLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        activeNumberLabel.textColor = .white
        activeNumberLabel.textAlignment = .center
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //print("iPhone 5 or 5S or 5C")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
                
            case 1334:
//print("iPhone 6/6S/7/8")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
            case 1920, 2208:
               // print("iPhone 6+/6S+/7+/8+")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
                 viewLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            case 2436:
                //print("iPhone X, XS")
              titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
                 viewLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
            case 2688:
                //print("iPhone XS Max")
               titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 21)
                 viewLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            case 1792:
                //print("iPhone XR")
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 21)
                viewLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            default:
                print("Unknown")
            }
        } else {
            if UIDevice().userInterfaceIdiom == .pad {
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 28)
               
            }
        }
        
        contentView.addSubview(publisherImageView)
        contentView.addSubview(activeView)
        contentView.addSubview(imagerView)
        contentView.addSubview(titlerLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(viewLabel)
        contentView.addSubview(likeImageView)
        contentView.addSubview(percentLabel)
        contentView.addSubview(dislikeImageView)
        contentView.addSubview(activeLabel)
        activeView.addSubview(activeNumberLabel)
        contentView.addSubview(externalImage)
        //externalImage.addSubview(externalButton)
        
        externalImage.layer.cornerRadius = 20.0
        externalImage.layer.shadowColor = UIColor.black.cgColor
        externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
         externalImage.layer.shadowOpacity = 1
        externalImage.isUserInteractionEnabled = true
         
        let width = contentView.frame.width
        self.publisherImageView.frame = CGRect(x: 15, y: 20, width: 120, height: 20)
        self.imagerView.frame = CGRect(x: width - 160, y: 25, width: 140, height: 130)
        self.publisherImageView.contentMode = .scaleAspectFit
        timeLabel.frame = CGRect(x: 15, y: 140, width: 120, height: 20)
        titlerLabel.translatesAutoresizingMaskIntoConstraints = false
        titlerLabel.topAnchor.constraint(equalTo: publisherImageView.bottomAnchor, constant: 1).isActive = true
        titlerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titlerLabel.trailingAnchor.constraint(equalTo: imagerView.leadingAnchor, constant: -10).isActive = true
        titlerLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -8).isActive = true
        viewLabel.frame = CGRect(x: width - 160, y: 160, width: 65, height: 21)
        likeImageView.frame = CGRect(x: width - 90, y: 160, width: 18, height: 18)
        percentLabel.frame = CGRect(x: width - 70, y: 160, width: 28, height: 21)
        dislikeImageView.frame = CGRect(x: width - 40, y: 160, width: 18, height: 18)
        activeView.frame = CGRect(x: width - 200, y: 128, width: 24, height: 24)
        activeNumberLabel.frame = CGRect(x: -5, y: 0, width: 34, height: 24)
        activeLabel.frame = CGRect(x: width - 210, y: 148, width: 42, height: 21)
        externalImage.frame = CGRect(x: width - 238, y: 130, width: 27, height: 27)
        externalButton.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        activeView.layer.cornerRadius = activeView.frame.width / 2
        labelSharedArticle.frame = CGRect(x: 10, y: -6, width: 300, height: 25)
        activeView.clipsToBounds = true
        titlerLabel.sizeToFit()
        imagerView.layer.cornerRadius = 8.0
        imagerView.clipsToBounds = true
        labelPubli.frame = CGRect(x: 15, y: 3, width: 300, height: 40)
        shapeLayer.lineWidth = 42.0
        publisherImageView.clipsToBounds = true
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 28, y: -15))
        path.addLine(to: CGPoint(x: -20, y: imagerView.frame.height+15))
        activeView.layer.cornerRadius = activeView.frame.width / 2
        
       
        
        shapeLayer.path = path.cgPath
        imagerView.layer.addSublayer(shapeLayer)
        
       labelPubli.textColor = .lightGray
        labelPubli.font = UIFont(name: "Courier", size: 14)
       
        labelPubli.setLineHeight(lineHeight: 5)
        labelPubli.numberOfLines = 2
        
        labelSharedArticle.font = UIFont(name: "HelveticaNeue", size: 14)
        labelSharedArticle.textColor = .gray
        labelSharedArticle.backgroundColor = .clear
        labelSharedArticle.numberOfLines = 1
        
        contentView.addSubview(labelPubli)
        contentView.addSubview(labelSharedArticle)
    }
    
    var labelSharedArticle = UILabel()
  
}
