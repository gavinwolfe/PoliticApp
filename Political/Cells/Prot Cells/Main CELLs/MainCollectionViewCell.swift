//
//  MainTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 10/5/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var once = false
    let shapeLayer = CAShapeLayer()
    var labelPubli = UILabel()
    var externalImage = UIImageView()
    var buttonExternalLink = UIButton()
    
    override func layoutSubviews() {
        
    
       imagerView.contentMode = .scaleAspectFill
       
     
        
        contentView.addSubview(publisherImage)
        contentView.addSubview(activeView)
        contentView.addSubview(imagerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(viewLabel)
        contentView.addSubview(likeView)
        contentView.addSubview(percentLabel)
        contentView.addSubview(dislikeView)
        contentView.addSubview(activeLabel)
        activeView.addSubview(countActiveLabel)
       contentView.addSubview(externalImage)
      // externalImage.addSubview(buttonExternalLink)
        
        setUpNormal(width: Int(contentView.frame.width), height: Int(contentView.frame.height))
       
        
    }
    
    // like: 18,18 |-| 2  *w,h
    // percent: 28, 21 |-| 1
    //views: 70,21 |-| 45
    
    var publisherImage = UIImageView()
    var activeView = UIView()
    var imagerView = UIImageView()
    var titleLabel = UILabel()
    var timeLabel = UILabel()
    var viewLabel = UILabel()
    var likeView = UIImageView()
    var percentLabel = UILabel()
    var dislikeView = UIImageView()
    var activeLabel = UILabel()
    var countActiveLabel = UILabel()
    
    
 
    
    
    
  
   
    func setUpNormal (width: Int, height: Int) {
       
        self.publisherImage.frame = CGRect(x: 15, y: 20, width: 120, height: 20)
        self.publisherImage.contentMode = .scaleAspectFit
        self.imagerView.frame = CGRect(x: 15, y: 43, width: 170, height: 100)
        labelPubli.frame = CGRect(x: 15, y: 2, width: 250, height: 40)
        //self.titleLabel.frame = CGRect(x: width - 182, y: 40, width: 176, height: 90)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
       titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
       titleLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 10).isActive = true
       titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
     titleLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
        
        //timeLabel.frame = CGRect(x: width - 182, y: 126, width: 80, height: 20)
       
        //timeLabel.frame.size.height = 28
        externalImage.layer.cornerRadius = 20.0
        externalImage.layer.shadowColor = UIColor.black.cgColor
        externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
         externalImage.layer.shadowOpacity = 1
        imagerView.isUserInteractionEnabled = true 
        viewLabel.frame = CGRect(x: 20, y: 146, width: 65, height: 21)
        likeView.frame = CGRect(x: 115, y: 146, width: 18, height: 18)
        percentLabel.frame = CGRect(x: 134, y: 146, width: 28, height: 21)
        dislikeView.frame = CGRect(x: 162, y: 146, width: 18, height: 18)
        activeView.frame = CGRect(x: width - 50, y: 126, width: 24, height: 24)
        countActiveLabel.frame = CGRect(x: -5, y: 0, width: 34, height: 24)
        activeLabel.frame = CGRect(x: width - 60, y: 146, width: 42, height: 21)
        externalImage.frame = CGRect(x: activeView.frame.midX - 50, y: 126, width: 26, height: 26)
      //  externalImage.image = #imageLiteral(resourceName: "feedChat")
        externalImage.contentMode = .scaleAspectFill
        externalImage.isUserInteractionEnabled = true
        buttonExternalLink.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        buttonExternalLink.setTitle("", for: .normal)
        labelSharedArticle.frame = CGRect(x: 10, y: -4, width: 300, height: 25)
        shapeLayer.lineWidth = 40.0
        timeLabel.sizeToFit()
        activeView.clipsToBounds = true
        titleLabel.sizeToFit()
        imagerView.layer.cornerRadius = 8.0
        imagerView.clipsToBounds = true
        activeView.backgroundColor = UIColor(red: 0.9961135983467102, green: 0.2821864187717438, blue: 0.22698186337947845, alpha: 1.0)
        activeLabel.text = "active"
        activeLabel.textColor = .lightGray
        activeLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
        titleLabel.textColor = .white
        timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .left
        viewLabel.textColor = .lightGray
        viewLabel.font = UIFont(name: "AvenirNext-Regular", size: 13)
        viewLabel.textAlignment = .left
//        likeView.image = UIImage(named: "up1")
//        dislikeView.image = UIImage(named: "down1")
        percentLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        percentLabel.textAlignment = .center
        titleLabel.numberOfLines = 4
        activeLabel.font = UIFont(name: "AvenirNext-Medium", size: 13)
        countActiveLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        countActiveLabel.textColor = .white
        countActiveLabel.textAlignment = .center
       publisherImage.clipsToBounds = true 
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                titleLabel.numberOfLines = 3
                self.imagerView.frame = CGRect(x: 15, y: 43, width: 140, height: 100)
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
            case 1334:
                print("iPhone 6/6S/7/8")
                titleLabel.numberOfLines = 4
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                titleLabel.numberOfLines = 4
                  titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
                 self.viewLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
            case 2436:
                print("iPhone X, XS")
                self.viewLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
                self.imagerView.frame = CGRect(x: 15, y: 43, width: 170, height: 110)
                viewLabel.frame = CGRect(x: 20, y: 166, width: 75, height: 21)
                likeView.frame = CGRect(x: 113, y: 166, width: 20, height: 20)
                percentLabel.frame = CGRect(x: 134, y: 166, width: 28, height: 21)
                dislikeView.frame = CGRect(x: 162, y: 166, width: 20, height: 20)
                activeView.frame = CGRect(x: width - 50, y: 146, width: 24, height: 24)
                activeLabel.frame = CGRect(x: width - 60, y: 166, width: 42, height: 21)
                externalImage.frame = CGRect(x: activeView.frame.midX - 50, y: 146, width: 27, height: 27)
                titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
                 timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28).isActive = true
                
            case 2688:
                print("iPhone XS Max")
                titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 21)
                self.viewLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
                self.imagerView.frame = CGRect(x: 15, y: 43, width: 180, height: 120)
                viewLabel.frame = CGRect(x: 20, y: 166, width: 75, height: 21)
                likeView.frame = CGRect(x: 113, y: 166, width: 20, height: 20)
                percentLabel.frame = CGRect(x: 134, y: 166, width: 28, height: 21)
                dislikeView.frame = CGRect(x: 162, y: 166, width: 20, height: 20)
               
                 timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
                 activeView.frame = CGRect(x: width - 50, y: 146, width: 24, height: 24)
                    activeLabel.frame = CGRect(x: width - 60, y: 166, width: 42, height: 21)
                    
                externalImage.frame = CGRect(x: activeView.frame.midX - 50, y: 146, width: 28, height: 28)
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
            case 1792:
                print("iPhone XR")
                titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
                self.viewLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
                self.imagerView.frame = CGRect(x: 15, y: 43, width: 180, height: 120)
                viewLabel.frame = CGRect(x: 20, y: 166, width: 75, height: 21)
                likeView.frame = CGRect(x: 113, y: 166, width: 20, height: 20)
                percentLabel.frame = CGRect(x: 134, y: 166, width: 28, height: 21)
                dislikeView.frame = CGRect(x: 162, y: 166, width: 20, height: 20)
                activeView.frame = CGRect(x: width - 50, y: 150, width: 24, height: 24)
                activeLabel.frame = CGRect(x: width - 60, y: 170, width: 42, height: 21)
                externalImage.frame = CGRect(x: activeView.frame.width - 50, y: 150, width: 27, height: 27)
                 timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
                titleLabel.numberOfLines = 4
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
            default:
                print("Unknown")
            }
        } else {
            if UIDevice().userInterfaceIdiom == .pad {
                titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 28)
                self.viewLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
                self.imagerView.frame = CGRect(x: 15, y: 43, width: 180, height: 120)
                viewLabel.frame = CGRect(x: 20, y: 166, width: 75, height: 21)
                likeView.frame = CGRect(x: 113, y: 166, width: 20, height: 20)
                percentLabel.frame = CGRect(x: 134, y: 166, width: 28, height: 21)
                dislikeView.frame = CGRect(x: 162, y: 166, width: 20, height: 20)
                 activeView.frame = CGRect(x: width - 50, y: 150, width: 24, height: 24)
                activeLabel.frame = CGRect(x: width - 60, y: 170, width: 42, height: 21)
                externalImage.frame = CGRect(x: 5, y: 6, width: 0, height: 0)
                timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
                titleLabel.numberOfLines = 4
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
            }
        }
        
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: imagerView.frame.width - 25, y: -15))
        path.addLine(to: CGPoint(x: imagerView.frame.width+20, y: imagerView.frame.height+15))
        
            shapeLayer.path = path.cgPath
            imagerView.layer.addSublayer(shapeLayer)
         activeView.layer.cornerRadius = activeView.frame.width / 2
        labelPubli.textColor = .lightGray
        labelPubli.numberOfLines = 2
        labelPubli.setLineHeight(lineHeight: 5)
        labelPubli.font = UIFont(name: "Courier", size: 14)
        
        labelSharedArticle.font = UIFont(name: "HelveticaNeue", size: 14)
        labelSharedArticle.textColor = .gray
        labelSharedArticle.backgroundColor = .clear
        labelSharedArticle.numberOfLines = 1
        contentView.addSubview(labelPubli)
        contentView.addSubview(labelSharedArticle)
        
    }
   
    var labelSharedArticle = UILabel()
   

}

extension UILabel
{
    func setLineHeight(lineHeight: CGFloat)
    {
        let text = self.text
        if let text = text
        {
            
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                         value: style,
                                         range: NSMakeRange(0, text.count))
            
            self.attributedText = attributeString
        }
    }
}
