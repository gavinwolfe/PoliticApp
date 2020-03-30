//
//  FirstSearchTableViewCell.swift
//  Political
//
//  Created by Gavin Wolfe on 10/28/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class FirstSearchTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var whatSection: Int?
    //var whatQuad: Int?
    @IBOutlet weak var labelAbove: UILabel!
    
    var productVC: SearchViewController?
    
    var subbedPubs = [String]()
   // var subbedTags = [String]()

    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewer: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewer.delegate = self
        collectionViewer.dataSource = self
       
        // Initialization code
    }
    override func layoutSubviews() {
       labelAbove.frame = CGRect(x: 8, y: 0, width: 100, height: 20)
        collectionViewer.frame = CGRect(x: 8, y: 20, width: contentView.frame.width - 8, height: 140)
        collectionViewer.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        contentView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        buttonMoveon.frame = CGRect(x: 15, y: 175, width: contentView.frame.width - 30, height: 43)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productVC?.selectedIndx = indexPath.row
        productVC?.tagOrPub = whatSection
        productVC?.performSegue(withIdentifier: "segueSelectedSearch", sender: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
//    var tags = [Tagi]()
    var publis = [Publisher]()
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 130)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if whatSection == 2 {
//            return tags.count
//        }
        
        return publis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewer.dequeueReusableCell(withReuseIdentifier: "cellCollectionSearcher", for: indexPath) as! SearchCollectionViewCell
        print("calledr")
        
       cell.mainImagerView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        cell.mainImagerView.layer.cornerRadius = 15.0
        cell.mainImagerView.backgroundColor = randomColor()
         cell.labelMain.text = publis[indexPath.row].name
        if indexPath.row == 1 {
          //  cell.mainImagerView.image = #imageLiteral(resourceName: "fox")
            cell.labelMain.text = publis[indexPath.row].name
        }
        if whatSection == 2 {
           // cell.labelMain.text = tags[indexPath.row].title
          //  cell.mainImagerView.image = #imageLiteral(resourceName: "tagTrump")
        }
        return cell
    }
    
    
    
    func randomColor () -> UIColor {
         let radOne = Int.random(in: 1..<8)
        // there are 7
        if radOne == 1 {
            return UIColor(red: 0.8392, green: 0.5294, blue: 0, alpha: 1.0)
        }
        if radOne == 2 {
            return UIColor(red: 0, green: 0.6353, blue: 0.7176, alpha: 1.0)
        }
        if radOne == 3 {
            return UIColor(red: 0.7294, green: 0, blue: 0.0118, alpha: 1.0)
        }
        if radOne == 4 {
            return UIColor(red: 0.3059, green: 0, blue: 0.7098, alpha: 1.0)
        }
        if radOne == 5 {
            return UIColor(red: 0, green: 0.2039, blue: 0.6784, alpha: 1.0)
        }
        if radOne == 6 {
            return UIColor(red: 0.6863, green: 0.3216, blue: 0, alpha: 1.0)
        }
        if radOne == 7 {
            return UIColor(red: 0, green: 0.6784, blue: 0.5647, alpha: 1.0)
        }
        return UIColor.blue
    }
    
    
    @IBOutlet weak var buttonMoveon: UIButton!
}
