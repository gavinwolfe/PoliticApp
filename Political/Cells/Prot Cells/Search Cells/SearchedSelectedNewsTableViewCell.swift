//
//  SearchedSelectedNewsTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 4/1/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class SearchedSelectedNewsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var caller = false
//    let uiislider = UISlider()
//    func setUpRow1 () {
//        uiislider.frame = CGRect(x: 10, y: 5, width: contentView.frame.width - 20, height: 40)
//        uiislider.maximumValue = 10
//        uiislider.minimumValue = -10
//        uiislider.isUserInteractionEnabled = false
//
//        let labelLeftBias = UILabel()
//        let labelRightBias = UILabel()
//        let unBias = UILabel()
//
//
//
//
//
//        if caller == false {
//        contentView.addSubview(uiislider)
//        setSlider(slider: uiislider)
//            contentView.addSubview(labelLeftBias)
//              contentView.addSubview(labelRightBias)
//            contentView.addSubview(unBias)
//            caller = true
//
//
//        labelLeftBias.frame = CGRect(x: 20, y: 35, width: 65, height: 20)
//        labelLeftBias.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
//        labelLeftBias.text = "Left"
//        labelLeftBias.textColor = .gray
//
//        unBias.translatesAutoresizingMaskIntoConstraints = false
//        unBias.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
//        unBias.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 46).isActive = true
//        unBias.frame.size.height = 20
//        unBias.frame.size.width = 120
//        unBias.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
//        unBias.text = "Bias"
//
//        labelRightBias.frame = CGRect(x: contentView.frame.width - 85, y: 35, width: 65, height: 20)
//        labelRightBias.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
//        labelRightBias.text = "Right"
//        labelRightBias.textColor = .gray
//        labelRightBias.textAlignment = .right
//        }
//    }
//
//    func setUprow2 () {
//        let labelTell = UILabel()
//        labelTell.frame = CGRect(x: 10, y: 2, width: contentView.frame.width - 20, height: 40)
//        labelTell.numberOfLines = 2
//        labelTell.font = UIFont(name: "HelveticaNeue", size: 16)
//        labelTell.text = "This bias is the average of all bias ratings on this organization's articles, that appear on the app."
//        labelTell.textColor = .gray
//        labelTell.textAlignment = .left
//        contentView.addSubview(labelTell)
//    }
//
    
   let labelPubli = UILabel()
    var externalButton = UIButton()
       var externalImage = UIImageView()
    
    override func layoutSubviews() {
        
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        imagerView.clipsToBounds = true
        imagerView.layer.cornerRadius = 12.0
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
        timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
      
        self.selectionStyle = .none
        timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .left
        viewLabel.textColor = .lightGray
        viewLabel.font = UIFont(name: "AvenirNext-Regular", size: 13)
        viewLabel.textAlignment = .left
        
        externalImage.image = #imageLiteral(resourceName: "xternal")
               externalImage.contentMode = .scaleAspectFill
               externalImage.isUserInteractionEnabled = true
               externalButton.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
               self.imagerView.isUserInteractionEnabled = true
               externalButton.setTitle("", for: .normal)
        
        percentLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        percentLabel.textAlignment = .center
        titleLabel.textColor = .white
        timeLabel.textColor = .lightGray
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
        contentView.addSubview(countActiveLabel)
       // imagerView.addSubview(externalImage)
               externalImage.addSubview(externalButton)
        
        setUpRest(height: Int(contentView.frame.height), width: Int(contentView.frame.width))
        self.selectionStyle = .none 
    }
    
  
    let shapeLayer = CAShapeLayer()
    func setUpRest (height: Int, width: Int) {
      
        
            externalImage.layer.cornerRadius = 20.0
                   externalImage.layer.shadowColor = UIColor.black.cgColor
                   externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
                    externalImage.layer.shadowOpacity = 1
                   externalImage.isUserInteractionEnabled = true
        
        self.publisherImage.frame = CGRect(x: 15, y: 20, width: 120, height: 20)
        self.imagerView.frame = CGRect(x: width - 160, y: 25, width: 140, height: 130)
        self.titleLabel.frame = CGRect(x: 15, y: 40, width: width - 180, height: 100)
        
        timeLabel.frame = CGRect(x: 15, y: 140, width: 120, height: 20)
        viewLabel.frame = CGRect(x: width - 160, y: 160, width: 65, height: 21)
        likeView.frame = CGRect(x: width - 90, y: 160, width: 18, height: 18)
        percentLabel.frame = CGRect(x: width - 70, y: 160, width: 28, height: 21)
        dislikeView.frame = CGRect(x: width - 40, y: 160, width: 18, height: 18)
        activeView.frame = CGRect(x: width - 200, y: 122, width: 24, height: 24)
        activeLabel.frame = CGRect(x: width - 210, y: 142, width: 42, height: 21)
        externalImage.frame = CGRect(x: imagerView.frame.width - 26, y: 5, width: 22, height: 22)
               externalButton.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        shapeLayer.lineWidth = 42.0
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 28, y: -15))
        path.addLine(to: CGPoint(x: -20, y: imagerView.frame.height+15))
        
        shapeLayer.path = path.cgPath
        imagerView.layer.addSublayer(shapeLayer)
        
        labelPubli.textColor = .lightGray
        labelPubli.numberOfLines = 1
        labelPubli.setLineHeight(lineHeight: 5)
        labelPubli.font = UIFont(name: "Courier", size: 14)
        labelPubli.frame = CGRect(x: 15, y: 8, width: 300, height: 30)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
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
                titleLabel.numberOfLines = 5
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
        }
    }
    
    
    let publisherImage = UIImageView()
    let activeView =  UIView()
    let imagerView = UIImageView()
    let titleLabel = UILabel()
    let timeLabel =  UILabel()
    let viewLabel =  UILabel()
    let likeView =  UIImageView()
    let percentLabel = UILabel()
    let dislikeView = UIImageView()
    let activeLabel = UILabel()
    let countActiveLabel = UILabel()
    
    func setSlider(slider:UISlider) {
        
        
        
        let tgl = CAGradientLayer()
       
        let frame = CGRect(x: 0.0, y: 0.0, width: slider.bounds.width, height: 20.0 )
        tgl.frame = frame
        
        tgl.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.red.cgColor]
        
        tgl.borderWidth = 1.0
        tgl.borderColor = UIColor.gray.cgColor
        tgl.cornerRadius = 2.0
        
        tgl.endPoint = CGPoint(x: 1.0, y:  1.0)
        tgl.startPoint = CGPoint(x: 0.0, y:  1.0)
        
        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, false, 0.0)
        tgl.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
        slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
        
        let layerFrame = CGRect(x: 0, y: 0, width: 10.0, height: 30.0)
        
        
        let thumb = CALayer.init()
        let shapeLayer = CAShapeLayer()
        
        
        shapeLayer.path = CGPath(rect: layerFrame, transform: nil)
        shapeLayer.fillColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
        
       
        
        thumb.frame = layerFrame
        thumb.addSublayer(shapeLayer)
        
        thumb.borderColor = UIColor.black.cgColor
        thumb.borderWidth = 1.0
        
        UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
        
        thumb.render(in: UIGraphicsGetCurrentContext()!)
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        slider.setThumbImage(thumbImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .highlighted)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
