//
//  AddCommentTopTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 4/11/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class AddCommentTopTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(textBubble)
        
       textBubble.translatesAutoresizingMaskIntoConstraints = false
        textBubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        textBubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        textBubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        textBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true

        
        
        textBubble.text = "   \n Read full article  \n"
        contentView.backgroundColor  = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        // Initialization code
    }
    
    let gesture: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        return button
    }()
    
    func setUpClicks () {
        textBubble.addSubview(gesture)
        textBubble.isUserInteractionEnabled = true
        gesture.translatesAutoresizingMaskIntoConstraints = false
        
        gesture.topAnchor.constraint(equalTo: textBubble.topAnchor, constant: 0).isActive = true
        gesture.leadingAnchor.constraint(equalTo: textBubble.leadingAnchor, constant: 0).isActive = true
        gesture.trailingAnchor.constraint(equalTo: textBubble.trailingAnchor, constant: 0).isActive = true
        gesture.bottomAnchor.constraint(equalTo: textBubble.bottomAnchor, constant: 0).isActive = true
    }
    
    
    
    
    let textBubble : UILabel  = {
        let labelText = UILabel()
        
        labelText.numberOfLines = 3
        labelText.backgroundColor = #colorLiteral(red: 0.3028503954, green: 0.01856542379, blue: 0.2233350873, alpha: 1)
        labelText.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        labelText.textAlignment = .center
        labelText.textColor = .white
        labelText.layer.cornerRadius = 20.0
        labelText.clipsToBounds = true
        return labelText
    }()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
