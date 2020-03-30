//
//  selectedArtsy.swift
//  Political
//
//  Created by Gavin Wolfe on 10/8/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class selectedArtsy: NSObject {

    
   let addView = UIView()
    
    func adddViews () {
        
        addView.backgroundColor = .black
          if let keywindow = UIApplication.shared.keyWindow {
            addView.frame = CGRect(x: 0, y: keywindow.frame.height - 50, width: keywindow.frame.width, height: 50)
            
            keywindow.addSubview(addView)
            
        }
        
    }
    
    
}
