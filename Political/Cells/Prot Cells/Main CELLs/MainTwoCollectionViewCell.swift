//
//  MainTwoTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 4/12/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class MainTwoCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    var buttonExternalLink = UIButton()
    var externalImage = UIImageView()
    var labelPubli = UILabel()
    let shapeLayer = CAShapeLayer()
    override func layoutSubviews() {
        imagerView.contentMode = .scaleAspectFill
        activeView.backgroundColor = UIColor(red: 0.9961135983467102, green: 0.2821864187717438, blue: 0.22698186337947845, alpha: 1.0) 
        activeLabel.textColor = .lightGray
        activeLabel.textAlignment = .center
        titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 21)
        titlerLabel.textColor = .white
        timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .left
        viewsLabel.textColor = .lightGray
        viewsLabel.font = UIFont(name: "AvenirNext-Regular", size: 13)
        viewsLabel.textAlignment = .left
//        likeImageView.image = UIImage(named: "up1")
//        dislikeImageView.image = UIImage(named: "down1")
        percentLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        percentLabel.textAlignment = .center
        activeLabel.text = "active"
        titlerLabel.numberOfLines = 0
        activeLabel.font = UIFont(name: "AvenirNext-Medium", size: 13)
       // externalImage.image = #imageLiteral(resourceName: "feedChat")
        externalImage.contentMode = .scaleAspectFill
        activeNumberLabel.font =  UIFont(name: "HelveticaNeue-Medium", size: 12)
        activeNumberLabel.textColor = .white
        
        contentView.addSubview(publisherImageView)
        contentView.addSubview(activeView)
        contentView.addSubview(imagerView)
        contentView.addSubview(titlerLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(likeImageView)
        contentView.addSubview(percentLabel)
        contentView.addSubview(dislikeImageView)
        contentView.addSubview(activeLabel)
        activeView.addSubview(activeNumberLabel)
       contentView.addSubview(externalImage)
      //externalImage.addSubview(buttonExternalLink)
        
        
        let width = Int(contentView.frame.width)
        let hullHeight = 245
        self.publisherImageView.frame = CGRect(x: 15, y: 22, width: 120, height: 20)
        self.publisherImageView.contentMode = .scaleAspectFit
        self.imagerView.frame = CGRect(x: 15, y: 45, width: width - 30, height: 200)
        //self.titleLabel.frame = CGRect(x: 15, y: hullHeight + 5, width: width - 30, height: 55)
         imagerView.isUserInteractionEnabled = true 
        externalImage.layer.cornerRadius = 20.0
        externalImage.layer.shadowColor = UIColor.black.cgColor
        externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
         externalImage.layer.shadowOpacity = 1
        viewsLabel.frame = CGRect(x: 15, y: hullHeight + 120, width: width - 30, height: 20)
        titlerLabel.translatesAutoresizingMaskIntoConstraints = false
        titlerLabel.topAnchor.constraint(equalTo: imagerView.bottomAnchor, constant: 5).isActive = true
        titlerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titlerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        titlerLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: titlerLabel.bottomAnchor, constant: 5).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47).isActive = true
        likeImageView.frame = CGRect(x: width / 4, y: hullHeight + 120, width: 18, height: 18)
        percentLabel.frame = CGRect(x: (width / 4) + 20, y: hullHeight + 120, width: 28, height: 21)
        dislikeImageView.frame = CGRect(x: (width / 4) + 49, y: hullHeight + 120, width: 18, height: 18)
        activeView.frame = CGRect(x: width - 49, y: hullHeight + 85, width: 24, height: 24)
        activeNumberLabel.frame = CGRect(x: -5, y: 0, width: 34, height: 24)
        activeLabel.frame = CGRect(x: width - 58, y: hullHeight + 108, width: 42, height: 21)
        externalImage.frame = CGRect(x: width - 87, y: hullHeight + 85, width: 27, height: 27)
        externalImage.isUserInteractionEnabled = true
        buttonExternalLink.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        buttonExternalLink.setTitle("", for: .normal)
        labelSharedArticle.frame = CGRect(x: 10, y: 0, width: 300, height: 25)
        shapeLayer.lineWidth = 62.0
        activeView.layer.cornerRadius = activeView.frame.width / 2
        labelPubli.frame = CGRect(x: 15, y: 3, width: 300, height: 40)
        activeView.clipsToBounds = true
        titlerLabel.sizeToFit()
         titlerLabel.numberOfLines = 3
        if contentView.frame.width > 375 {
             titlerLabel.numberOfLines = 4
        }
       
        imagerView.layer.cornerRadius = 8.0
        imagerView.clipsToBounds = true
        publisherImageView.clipsToBounds = true 
        let path = UIBezierPath()
        path.move(to: CGPoint(x: imagerView.frame.width - 38, y: -15))
        path.addLine(to: CGPoint(x: imagerView.frame.width+24, y: imagerView.frame.height+15))
        activeNumberLabel.textAlignment = .center
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
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                
              case 1920, 2208:
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 23)
                viewsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
               
            case 2436:
                // print("iPhone X, XS")
            titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 22)
                viewsLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
               
            case 2688:
                // print("iPhone XS Max")
           titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 23)
                viewsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            case 1792:
                // print("iPhone XR")
         titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 22)
                viewsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
                timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            default:
                print("none")
            }
        } else {
            if UIDevice().userInterfaceIdiom == .pad {
                titlerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 32)
                
            }
        }
        
    }
    
   var publisherImageView = UIImageView()
    var imagerView = UIImageView()
    var titlerLabel = UILabel()
   var timeLabel = UILabel()
   var likeImageView = UIImageView()
    var percentLabel = UILabel()
     var dislikeImageView = UIImageView()
     var viewsLabel = UILabel()
    var activeView = UIView()
      var activeNumberLabel = UILabel()
    var activeLabel = UILabel()
    var labelSharedArticle = UILabel()
    
    

   

}
