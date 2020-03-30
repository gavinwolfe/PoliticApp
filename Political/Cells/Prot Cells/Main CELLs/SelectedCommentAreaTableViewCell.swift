//
//  SelectedCommentAreaTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 4/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class SelectedCommentAreaTableViewCell: UITableViewCell {

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
        textviewly.numberOfLines = 8
        textviewly.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        textviewly.contentMode = .left
        textviewly.textColor = .black
        return textviewly
    }()
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
