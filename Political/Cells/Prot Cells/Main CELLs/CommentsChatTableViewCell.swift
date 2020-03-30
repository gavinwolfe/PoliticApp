//
//  CommentsChatTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 4/5/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class CommentsChatTableViewCell: UITableViewCell {

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
    
//    func setUpClicks () {
//               textviewet.addSubview(gesture)
//                textviewet.isUserInteractionEnabled = true
//                gesture.translatesAutoresizingMaskIntoConstraints = false
//
//                gesture.topAnchor.constraint(equalTo: textviewet.topAnchor, constant: 0).isActive = true
//                gesture.leadingAnchor.constraint(equalTo: textviewet.leadingAnchor, constant: 0).isActive = true
//                gesture.trailingAnchor.constraint(equalTo: textviewet.trailingAnchor, constant: 0).isActive = true
//                gesture.bottomAnchor.constraint(equalTo: textviewet.bottomAnchor, constant: 0).isActive = true
//    }
//
   
    
    
    @IBOutlet weak var buttonLikeChat: UIButton!
    
    @IBAction func buttonLikeChatAction(_ sender: Any) {
        if buttonLikeChat.imageView?.image == UIImage(named: "blueLike") {
            let textOne = labelLikeCount.text
            if let inty = Int(textOne!) {
                labelLikeCount.text = ("\(inty-1)")
            }
            buttonLikeChat.setImage(#imageLiteral(resourceName: "up1"), for: .normal)
        } else {
            let textOne = labelLikeCount.text
            if let inty = Int(textOne!) {
                labelLikeCount.text = ("\(inty+1)")
            }
            if buttonDislikeChat.imageView?.image == UIImage(named: "blueDis") {
                let textTwo = labelDislikesCount.text
                if let inty2 = Int(textTwo!) {
                    labelDislikesCount.text = ("\(inty2-1)")
                }
            }
        buttonDislikeChat.setImage(#imageLiteral(resourceName: "down1"), for: .normal)
        buttonLikeChat.setImage(UIImage(named: "blueLike"), for: .normal)
        }
    }
    
    @IBOutlet weak var labelLikeCount: UILabel!
    
    
    @IBOutlet weak var buttonDislikeChat: UIButton!
    
    @IBAction func buttonDislikeChatAction(_ sender: Any) {
        if buttonDislikeChat.imageView?.image == UIImage(named: "blueDis") {
            let textOne = labelDislikesCount.text
            if let inty = Int(textOne!) {
                labelDislikesCount.text = ("\(inty-1)")
            }
            buttonDislikeChat.setImage(#imageLiteral(resourceName: "down1"), for: .normal)
        } else {
            let textOne = labelDislikesCount.text
            if let inty = Int(textOne!) {
                labelDislikesCount.text = ("\(inty+1)")
            }
            if buttonLikeChat.imageView?.image == UIImage(named: "blueLike") {
                let textTwo = labelLikeCount.text
                if let inty2 = Int(textTwo!) {
                    print("doing")
                    labelLikeCount.text = ("\(inty2-1)")
                }
            }
        buttonLikeChat.setImage(#imageLiteral(resourceName: "up1"), for: .normal)
        buttonDislikeChat.setImage(UIImage(named: "blueDis"), for: .normal)
            
           
        }
    }
    
    @IBOutlet weak var labelDislikesCount: UILabel!
    
    @IBOutlet weak var repliesButton: UIButton!
    
    @IBAction func viewRepliesAction(_ sender: Any) {
    }
    
//    let gesture: UIButton = {
//        let button = UIButton()
//        button.setTitle("", for: .normal)
//        return button
//    }()
    
    let textviewet: UILabel = {
        let textviewly = UILabel()
        textviewly.numberOfLines = 12
        textviewly.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        textviewly.contentMode = .left
        textviewly.textColor = .white
        return textviewly
    }()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class SelArtTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
      contentView.addSubview(textviewet)
            contentView.backgroundColor =  UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                  textviewet.translatesAutoresizingMaskIntoConstraints = false
                  textviewet.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
                  textviewet.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
                  textviewet.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
                  textviewet.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        // Initialization code
    }
    
    override func layoutSubviews() {
        
            
    }
    
     let textviewet: UILabel = {
           let textviewly = UILabel()
           textviewly.numberOfLines = 0
           textviewly.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
           textviewly.contentMode = .left
           textviewly.textColor = .white
           return textviewly
       }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class SelArt2TableViewCell: UITableViewCell {
    let textviewet: UILabel = {
              let textviewly = UILabel()
              textviewly.numberOfLines = 0
              textviewly.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
              textviewly.contentMode = .center
              textviewly.textColor = .white
              return textviewly
          }()
    
    override func layoutSubviews() {
           
              
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      contentView.addSubview(textviewet)
                    contentView.backgroundColor =  UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                         textviewet.translatesAutoresizingMaskIntoConstraints = false
                         textviewet.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
                         textviewet.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
                         textviewet.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
                         textviewet.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        // Initialization code
    }
    
}
