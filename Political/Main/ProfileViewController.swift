//
//  ProfileViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 10/28/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, changedValues {

    var tablerView = UITableView()
    
    var starCollection : UICollectionView!
    
    
   // var myId: String?
    
    let activity = UIActivityIndicatorView()
    
    override var prefersStatusBarHidden: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return true
            case 1334:
                print("iPhone 6/6S/7/8")
              return true
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                return true
            case 2436:
                print("iPhone X, XS")
                return false
            case 2688:
                print("iPhone XS Max")
                return false
            case 1792:
                print("iPhone XR")
                return false
            default:
                print("Unknown")
            }
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
     self.navigationController?.navigationBar.isHidden = true 
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = true
      
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        let farm = CGRect(x: 0, y: 0, width: 200, height: 0)
        starCollection = UICollectionView(frame: farm, collectionViewLayout: layout)
        starCollection.delegate   = self
        starCollection.dataSource = self
        starCollection.register(StarsCollectionViewCell.self, forCellWithReuseIdentifier: "cellStark")
        starCollection.backgroundColor = .clear
        starCollection.backgroundView?.backgroundColor = .clear
        
        automaticallyAdjustsScrollViewInsets = false
      
        
       
        
        
        
        self.layoutViews()
        tablerView.delegate = self
        tablerView.dataSource = self
       self.tablerView.separatorStyle = .none
        self.tablerView.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        //self.tablerView.backgroundView = nil
        self.view.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        
        tablerView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "profilerCell")
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                self.tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            case 2436:
                print("iPhone X, XS")
                self.tablerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height-50)
            case 2688:
                print("iPhone XS Max")
                self.tablerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height-50)
            case 1792:
                print("iPhone XR")
                self.tablerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height-50)
            default:
                print("Unknown")
            }
        }
        // Do any additional setup after loading the view.
        textviewA.delegate = self
        self.loadYourStuff()
        self.grabFollowersCount()
        self.fetchStars()
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    @objc func backout () {
        
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
        return arts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let imageBg = getSavedImage(named: "backGround.png") {
            img = imageBg
        } else {
            img = #imageLiteral(resourceName: "bgh")
        }
        if section == 1 {
            tableView.estimatedSectionHeaderHeight = 36;
            return UITableView.automaticDimension
        }
        if let img = img {
            let w = view.frame.size.width
            let imgw = img.size.width
            let imgh = img.size.height
            let ighit = w/imgw*imgh
            if ighit > 200 && ighit < 300 {
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 1136:
                        print("iPhone 5 or 5S or 5C")
                      
                    case 1334:
                        print("iPhone 6/6S/7/8")
                       
                    case 1920, 2208:
                        print("iPhone 6+/6S+/7+/8+")
                        return w/imgw*imgh / 1.15
                    case 2436:
                        print("iPhone X, XS")
                        return w/imgw*imgh / 1.15
                    case 2688:
                        print("iPhone XS Max")
                         return w/imgw*imgh / 1.15
                    case 1792:
                        print("iPhone XR")
                        return w/imgw*imgh / 1.15
                    default:
                        print("Unknown")
                    }
                }
                return w/imgw*imgh / 1.3
            }
            if ighit >= 300 {
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 1136:
                        print("iPhone 5 or 5S or 5C")
                        
                    case 1334:
                        print("iPhone 6/6S/7/8")
                        
                    case 1920, 2208:
                        print("iPhone 6+/6S+/7+/8+")
                        return w/imgw*imgh / 1.6
                    case 2436:
                        print("iPhone X, XS")
                        return w/imgw*imgh / 1.6
                    case 2688:
                        print("iPhone XS Max")
                        return w/imgw*imgh / 1.6
                    case 1792:
                        print("iPhone XR")
                        return w/imgw*imgh / 1.6
                    default:
                        print("Unknown")
                    }
                }
                return w/imgw*imgh / 2
            }
            return w/imgw*imgh
        }
        
        return 150
    }
    let namelabel = UILabel()
     let followersLabel = UILabel()
    var imagerBackView = UIImageView()
    var profileImger: UIImage?
    var img: UIImage?
     let imageView2 = UIImageView()
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        
        
        if let image = getSavedImage(named: "profileImg.png") {
            imageView2.image = image
            profileImger = image
        } else {
            self.imageView2.image = #imageLiteral(resourceName: "profile")
        }
        if let imageBg = getSavedImage(named: "backGround.png") {
            img = imageBg
        } else {
            img = #imageLiteral(resourceName: "bgh")
        }

        if section == 1 {
            let label: UILabel = {
                let lb = UILabel()
                lb.translatesAutoresizingMaskIntoConstraints = false
                if Auth.auth().currentUser?.uid != nil  && Auth.auth().currentUser?.isAnonymous == false {
                if let mySavedDes = UserDefaults.standard.value(forKey: "bio") as? String {
                    lb.text = mySavedDes
                } else {
                    lb.text = "Press edit to add a bio..."
                }
            } else {
                lb.text = "Press edit to add a bio..."
            }
                lb.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
                
               lb.font =  UIFont(name: "HelveticaNeue-Medium", size: 16)
                lb.textColor = .lightGray
                lb.numberOfLines = 0
                return lb
            }()
            
            let header: UIView = {
                let hd = UIView()
               hd.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
                hd.addSubview(label)
                label.leadingAnchor.constraint(equalTo: hd.leadingAnchor, constant: 10).isActive = true
                label.topAnchor.constraint(equalTo: hd.topAnchor, constant: 0).isActive = true
                label.trailingAnchor.constraint(equalTo: hd.trailingAnchor, constant: -10).isActive = true
                label.bottomAnchor.constraint(equalTo: hd.bottomAnchor, constant: -8).isActive = true
                return hd
            }()
            return header
        }
        
        
        imagerBackView = UIImageView(image: img)
        let overlay = UIButton(frame: CGRect(x: 10, y: 5, width: 50, height: 40))
        imagerBackView.isUserInteractionEnabled = true
        imagerBackView.contentMode = .scaleAspectFill
        imagerBackView.clipsToBounds = true
        overlay.backgroundColor = UIColor.clear
        overlay.setTitleColor(.white, for: .normal)
        overlay.setTitle("Done", for: .normal)
        overlay.addTarget(self, action: #selector(dismisser), for: .touchUpInside)
        imagerBackView.addSubview(overlay)
        let overlay2 = UIButton(frame: CGRect(x: self.view.frame.width - 45, y: 15, width: 35, height: 35))
        let overlay2Image = UIImageView(frame: CGRect(x: self.view.frame.width - 42, y: 10, width: 32, height: 32))
        overlay2Image.image = #imageLiteral(resourceName: "settings")
        overlay2.addTarget(self, action: #selector(self.openSettings), for: .touchUpInside)
        overlay2.backgroundColor = UIColor.clear
       
        imagerBackView.addSubview(overlay2Image)
        imagerBackView.addSubview(overlay2)
        let canseeview = UIView()
        canseeview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        let followButton = UIButton()
   
        
        if let img = img {
            let w = view.frame.size.width
            let imgw = img.size.width
            let imgh = img.size.height
            var heightter = w/imgw*imgh
            let ighit = w/imgw*imgh
            if ighit > 200 && ighit < 300 {
                 heightter = w/imgw*imgh / 1.3
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 1136:
                        print("iPhone 5 or 5S or 5C")
                        
                    case 1334:
                        print("iPhone 6/6S/7/8")
                        
                    case 1920, 2208:
                        print("iPhone 6+/6S+/7+/8+")
                        heightter =  w/imgw*imgh / 1.15
                    case 2436:
                        print("iPhone X, XS")
                        heightter =  w/imgw*imgh / 1.15
                    case 2688:
                        print("iPhone XS Max")
                        heightter =  w/imgw*imgh / 1.15
                    case 1792:
                        print("iPhone XR")
                        heightter =  w/imgw*imgh / 1.15
                    default:
                        print("Unknown")
                    }
                }
               
            }
            if ighit >= 300 {
                heightter = w/imgw*imgh / 2
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 1136:
                        print("iPhone 5 or 5S or 5C")
                        
                    case 1334:
                        print("iPhone 6/6S/7/8")
                        
                    case 1920, 2208:
                        print("iPhone 6+/6S+/7+/8+")
                        heightter =  w/imgw*imgh / 1.6
                    case 2436:
                        print("iPhone X, XS")
                        heightter =  w/imgw*imgh / 1.6
                    case 2688:
                        print("iPhone XS Max")
                        heightter =  w/imgw*imgh / 1.6
                    case 1792:
                        print("iPhone XR")
                        heightter =  w/imgw*imgh / 1.6
                    default:
                        print("Unknown")
                    }
                }
            }
            
            
            canseeview.frame = CGRect(x: 0, y: heightter - 70, width: imagerBackView.frame.width, height: 70)
            imageView2.frame = CGRect(x: 10, y: heightter - 60, width: 50, height: 50)
            namelabel.frame = CGRect(x: 70, y: heightter - 60, width: imagerBackView.frame.width - 20, height: 30)
            followButton.frame = CGRect(x: self.view.frame.width - 90, y: heightter - 35, width: 80, height: 25)
            followersLabel.frame = CGRect(x: 70, y: heightter - 35, width: 150, height: 25)
            
            let framer = CGRect(x: 10, y: heightter - 110, width: imagerBackView.frame.width, height: 30)
            
            starCollection.frame = framer
            
            
        }
        
        followButton.backgroundColor = .clear
        followButton.layer.borderColor = UIColor.white.cgColor
        followButton.layer.borderWidth = 1.0
        followButton.setTitleColor(.white, for: .normal)
        followButton.setTitle("Edit", for: .normal)
        followButton.layer.cornerRadius = 6.0
        followButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        followButton.addTarget(self, action: #selector(self.openEdit), for: .touchUpInside)
        imagerBackView.addSubview(canseeview)
        imagerBackView.addSubview(starCollection)
      
        imagerBackView.addSubview(followButton)
        
        imageView2.contentMode = .scaleAspectFill
        imageView2.layer.cornerRadius = 25.0
        imageView2.clipsToBounds = true
        imagerBackView.addSubview(imageView2)
        namelabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        namelabel.textColor = .white
        namelabel.text = Auth.auth().currentUser?.displayName
         if let mySavedUn = UserDefaults.standard.value(forKey: "username") as? String {
            musername = mySavedUn
            if let name = Auth.auth().currentUser?.displayName {
            namelabel.text = "\(name) @\(mySavedUn)"
            }
         } else {
            musername = ""
        }
        
        followersLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        followersLabel.textColor = .white
        followersLabel.text = "• \(followerCount) Followers"
        if Auth.auth().currentUser?.uid != nil  && Auth.auth().currentUser?.isAnonymous == false {
        let charactersCount = namelabel.text?.count
        let usnmcount = ((musername?.count)! + 1)
        let amountText = NSMutableAttributedString.init(string: "\(String(namelabel.text!))")
        
        // set the custom font and color for the 0,1 range in string
        amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                  NSAttributedString.Key.foregroundColor: UIColor.lightGray],
                                 range: NSMakeRange(charactersCount! - usnmcount, usnmcount))
        // if you want, you can add more attributes for different ranges calling .setAttributes many times
        
        // set the attributed string to the UILabel object
        namelabel.attributedText = amountText
        
        
        imagerBackView.addSubview(namelabel)
        }
        imagerBackView.addSubview(followersLabel)
        
        return imagerBackView
    }
    var musername: String?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "profilerCell", for: indexPath) as! ProfileTableViewCell
         let image2 = UIImage(named: "news")
        cell.titleLabel.text = arts[indexPath.row].titler
        cell.timeLabel.text = arts[indexPath.row].time
        if let urlOfPub = arts[indexPath.row].publisherUrl {
            if urlOfPub == "none" {
                cell.labelPubli.text = "\n\(arts[indexPath.row].publisher!)"
            } else {
                cell.labelPubli.text = ""
                let url = URL(string: urlOfPub)
                cell.publisherImage.kf.setImage(with: url)
            }
        }
         if self.arts[indexPath.row].caption != nil {
        if self.profileImger != nil {
        cell.captionImage.image = self.profileImger
        } else {
            cell.captionImage.image = #imageLiteral(resourceName: "profile")
        }
         } else {
            cell.captionImage.image = nil
        }
        if let urli = arts[indexPath.row].imageUrl {
            if urli != "none" {
                let url = URL(string: urli)
                cell.imagerView.kf.setImage(with: url, placeholder: image2)
            } else {
                cell.imagerView.image = UIImage(named: "news")
            }
        } else {
            cell.imagerView.image = UIImage(named: "news")
        }
        if let cap = self.arts[indexPath.row].caption {
            cell.captionLabel.text = cap
        } else {
            cell.captionLabel.text = ""
        }
        if let bias = arts[indexPath.row].bias {
            if bias == -2  {
                cell.shapeLayer.strokeColor = UIColor.blue.cgColor
            }
            if bias == -1  {
                cell.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
            }
            if bias == 0 {
                cell.shapeLayer.strokeColor = UIColor.purple.cgColor
            }
            if bias == 1 {
                cell.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
            if bias == 2 {
                cell.shapeLayer.strokeColor = UIColor.red.cgColor
            }
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var count = 0;
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
      
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStark", for: indexPath) as! StarsCollectionViewCell
        cell.imagerView.image = #imageLiteral(resourceName: "stark")
        return cell
    }
    
    @objc func openSettings () {
        let vc = SettingsViewController()
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func layoutViews () {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .grouped)
        view.addSubview(tablerView)
    }
    
    @objc func dismisser () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arts[indexPath.row].caption != nil {
            return 215
        }
        return 180
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let repost = self.arts[indexPath.row].aid {
                if let uid = Auth.auth().currentUser?.uid {
                    if Auth.auth().currentUser?.isAnonymous == false {
                let ref = Database.database().reference().child("users").child(uid).child("Reposts").child(repost)
                ref.removeValue()
                self.arts.remove(at: indexPath.row)
                self.tablerView.reloadSections([1], with: .automatic)
            }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedArt") as? SelectedArticleViewController {
                if let cell2 = tablerView.cellForRow(at: indexPath) as? ProfileTableViewCell {
                                          if let imager = cell2.imagerView.image {
                                           destination.img = imager
                                   }
                               }
                
                destination.delegate = self
                destination.indexPathi = indexPath
             //   destination.useID = self.myId
                destination.titler = arts[indexPath.row].titler
                destination.timer = arts[indexPath.row].time
                destination.publisher = arts[indexPath.row].publisher
                destination.urlToLoad = arts[indexPath.row].mainUrl
                destination.aid = arts[indexPath.row].aid
                if let myPersonal = self.arts[indexPath.row].personalLikeDis {
                    destination.personLikeDis = myPersonal
                }
                if let urlPub = arts[indexPath.row].publisherUrl {
                                            if urlPub != "none" {
                                                destination.publisherImageUrl = urlPub
                                            }
                                        }
                if let navigator = navigationController {
                    navigator.pushViewController(destination, animated: true)
                }
            }
        }
    }
    
    var oneAddTopLabelsandProfButton = false
    let labelTop = UILabel()
    let buttonoProf = UIButton()
    var loadingMore = false
    var working = false
    var arts = [Article]()
    var timeRepeated = 1;
    func loadYourStuff() {
        let last = timeRepeated * 6
        var reloadAdded = false
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
         if Auth.auth().currentUser?.isAnonymous == false {
        if let uid = Auth.auth().currentUser?.uid  {
           
            working = true
            var howManyAdded = 0;
            let ref = Database.database().reference().child("users").child(uid).child("Reposts")
            ref.queryLimited(toLast: UInt(last)).queryOrdered(byChild: "timeSent").observeSingleEvent(of: .value, with: { (snapshoti) in
                if let reposts = snapshoti.value as? [String : AnyObject] {
                    let dispatcherGroup = DispatchGroup()
                    for (_,lip) in reposts {
                        dispatcherGroup.enter()
                        if let aidi = lip["aid"] as? String {
                        let ref2 = Database.database().reference().child("Feed").child(aidi)
                        ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                             let titlr = snapshot.value as? [String : AnyObject]
                            
                            
                                    if let titler = titlr?["title"] as? String, let url = titlr?["url"] as? String, let namert = titlr?["publisher"] as? String, let publishedAt = titlr?["publishedAt"] as? String {
                                        let newArt = Article()
                                        let stringl = namert
                                        let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                                        let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                                        newArt.publisher = last.capitalized
                                        
                                        
                                        newArt.aid = aidi
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                        let newpdate = dateFormatter.date(from: publishedAt)
                                        if let localiDate = newpdate {
                                            let timey = Date().offset(from: localiDate)
                                            print("hired \(timey)")
                                            newArt.time = timey
                                            
                                        } else {
                                            print("HOUSTON PROBLEM")
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                            if let leeeps = dateFormatter.date(from: publishedAt) {
                                                let timey = Date().offset(from: leeeps)
                                                print("hired \(timey)")
                                                let newString = timey.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                                                newArt.time = newString
                                                print("HOUSTON Fixed")
                                            }
                                            
                                        }
                                        newArt.publisherUrl = self.publishers(name: last.capitalized)
                                        
                                        if likeArraySave.contains(aidi) {
                                            newArt.personalLikeDis = "Like"
                                            print("GOT A LIKE")
                                        }
                                        
                                        if dislikeArraySave.contains(aidi) {
                                            newArt.personalLikeDis = "Dislike"
                                        }
                                        
                                        if let caption = lip["caption"] as? String {
                                            newArt.caption = caption
                                        }
                                        
                                        if let urlImg = titlr?["urlToImage"] as? String {
                                            newArt.imageUrl = urlImg
                                        } else {
                                            newArt.imageUrl = "none"
                                        }
                                        
                                        if let biasi = titlr?["bias"] as? String {
                                            newArt.bias = Int(biasi)
                                            if newArt.bias == nil {
                                                let floaty = Float(biasi)
                                                if floaty != nil {
                                                    let inty = roundf(floaty!)
                                                    let newInty = Int(inty)
                                                    newArt.bias = newInty
                                                }
                                            }
                                        } else {
                                            newArt.bias = 0
                                        }
                                        
                                        newArt.titler = titler
                                        newArt.mainUrl = url
                                        if self.arts.contains( where: { $0.mainUrl == newArt.mainUrl } ) {
                                            print("no")
                                        } else {
                                            if self.arts.count < self.timeRepeated*6 {
                                                
                                                reloadAdded = true
                                                self.arts.append(newArt)
                                                if self.loadingMore == true {
                                                let index = IndexPath(row: self.arts.count-1, section: 1)
                                                self.tablerView.insertRows(at: [index], with: .automatic)
                                                    howManyAdded+=1
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                            
                            
                            dispatcherGroup.leave()
                        })
                        
                    }
                        else {
                            dispatcherGroup.leave()
                        }
                    }
                 
                    // self.activityIndc.stopAnimating()
                    
                    dispatcherGroup.notify(queue: DispatchQueue.main) {
                      
                        if reloadAdded == true {
                        if self.loadingMore == true {
                        var loop = 1;
                        while loop < howManyAdded {
                            if self.arts[self.arts.count-loop].aid != nil {
                            let indexPather = IndexPath(row: self.arts.count-loop, section: 1)
                            self.tablerView.reloadRows(at: [indexPather], with: .automatic)
                            loop+=1
                            }
                        }
                        } else {
                            
                            self.tablerView.reloadData()
                            self.labelTop.removeFromSuperview()
                            self.buttonoProf.removeFromSuperview()
                        }
                        self.timeRepeated+=1
                        self.working = false
                        }
                    }
                    
                } else {
                  
                        let emblem = UIImageView()
                        emblem.frame = CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2, width: 60, height: 60)
                        emblem.image = UIImage(named: "news")
                        let subLabel = UILabel()
                        subLabel.frame = CGRect(x: 20, y: self.view.frame.height / 2 + 70, width: self.view.frame.width - 40, height: 80)
                        subLabel.text = "Your reposted articles and popular comments will show up here!"
                        subLabel.textAlignment = .center
                        subLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
                        
                        subLabel.numberOfLines = 3
                        subLabel.textColor =  UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
                        self.tablerView.addSubview(emblem)
                        self.tablerView.addSubview(subLabel)
                        self.working = false
                    
                }
            }, withCancel: nil)
            }
        } else {
            if self.oneAddTopLabelsandProfButton == false {
                self.oneAddTopLabelsandProfButton = true
            self.labelTop.frame = CGRect(x: 25, y: self.view.frame.height / 2.5, width: self.view.frame.width - 50, height: 100)
            self.labelTop.font = UIFont(name: "Avenir-Medium", size: 22)
            self.labelTop.numberOfLines = 3
            self.labelTop.text = "Repost articles, share articles to friend's feeds, commenting, and so much more..."
            self.labelTop.textAlignment = .center
            self.labelTop.textColor = UIColor.lightGray
            self.view.addSubview(self.labelTop)
            
            self.buttonoProf.frame = CGRect(x: 30, y: self.view.frame.height / 1.7, width: self.view.frame.width - 60, height: 50)
            self.buttonoProf.backgroundColor = .white
            self.buttonoProf.setTitle("Login or Sign Up", for: .normal)
            self.buttonoProf.titleLabel?.font = UIFont(name: "Futura", size: 18)
            self.buttonoProf.addTarget(self, action: #selector(self.goToSignUp), for: .touchUpInside)
            self.buttonoProf.layer.cornerRadius = 12.0
            self.buttonoProf.clipsToBounds = true
            self.view.addSubview(self.buttonoProf)
            self.buttonoProf.setTitleColor(UIColor(red: 0, green: 0.5098, blue: 0.9882, alpha: 1.0), for: .normal)
                
            }
        }
    }
    
    var oneTimeGo = false
    @objc func goToSignUp () {
        if self.oneTimeGo == false {
            oneTimeGo = true
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSignUpVc") as! LoginOrSignUpVcViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: {
                self.oneTimeGo = false
            })
            
        }
    }
    
    
    var from = "none"
    @objc func openEdit () {
        var alert = UIAlertController()
        if Auth.auth().currentUser?.uid != nil  && Auth.auth().currentUser?.isAnonymous == false  {
        alert.title = "What would you like to change?"
        let action1 = UIAlertAction(title: "Profile Photo", style: .default) {  (alert : UIAlertAction) -> Void in
           self.from = "profile"
            self.openPhoto()
        }
        
        
        let action2 = UIAlertAction(title: "Background Photo", style: .default) {  (alert : UIAlertAction) -> Void in
            self.from = "bg"
            self.openPhoto()
        }
        
        let action3 = UIAlertAction(title: "Name", style: .default) {  (alert : UIAlertAction) -> Void in
            let alertController = UIAlertController(title: "Edit Name", message: "", preferredStyle: UIAlertController.Style.alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter your name..."
                textField.autocorrectionType = .default
                textField.keyboardType = .twitter
                textField.keyboardAppearance = .dark
                textField.autocapitalizationType = .sentences
                textField.tintColor = .blue
            }
           
            let attributedString = NSAttributedString(string: "Edit Name", attributes: [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 18)!, //your font here
                NSAttributedString.Key.foregroundColor : UIColor.blue
                ])
            alertController.setValue(attributedString, forKey: "attributedTitle")
            
            
            
            let saveAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { alert -> Void in
                if let text = alertController.textFields?[0].text {
                    if text.count < 32 {
                self.checkIfClean(string: text, from: "name")
                    }
                }
            })
            
            let cancel4 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            saveAction.setValue(UIColor.blue, forKey: "titleTextColor")
            alertController.addAction(saveAction)
            alertController.addAction(cancel4)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        let action4 = UIAlertAction(title: "Bio", style: .default) {  (alert : UIAlertAction) -> Void in
            self.openComment()
            
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(cancel)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action1)
        
        }
        else {
           
            alert = UIAlertController(title: "You need to create or login to an account to do that!", message: "", preferredStyle: .alert)
             let cancel = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
            alert.addAction(cancel)
        }
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openPhoto () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let pageAlert = UIAlertController(title: "Add Profile Photo", message: "Choose a way to add a profile photo", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let delete = UIAlertAction(title: "Remove Current Photo", style: .default, handler: { (action : UIAlertAction!) -> Void in
            if self.from == "bg" {
            let ref = Database.database().reference()
            
            if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("bckgUrl").removeValue()
            let storage = Storage.storage().reference().child(uid).child("bckg.jpg")
          
           // let url = food[indexPath.row].downloadURL
            
                
                
                //Removes image from storage
            storage.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        // File deleted successfully
                    }
                }
            }
            
            let imerg = UIImage(named: "bgh")
            let success = self.saveImage(image: imerg!)
                self.tablerView.reloadSections([0], with: .automatic)
            print(success)
            }
            if self.from == "profile" {
                let ref = Database.database().reference()
                
                if let uid = Auth.auth().currentUser?.uid {
                    ref.child("users").child(uid).child("profileUrl").removeValue()
                    let storage = Storage.storage().reference().child(uid).child("profile.jpg")
                    
                    // let url = food[indexPath.row].downloadURL
                    
                    
                    
                    //Removes image from storage
                    storage.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                        }
                    }
                    let imerg = UIImage(named: "profile")
                    let success = self.saveImage(image: imerg!)
                     self.tablerView.reloadSections([0], with: .automatic)
                    print(success)
                }
                
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        pageAlert.addAction(camera)
        pageAlert.addAction(library)
        pageAlert.addAction(delete)
        pageAlert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(pageAlert, animated: true, completion: nil)
        }
    }
    
    var tookPhoto = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        
        if from == "profile" {
        imageView2.image = selectedImage
        postPhoto(imgi: selectedImage, type: "profile")
        }
        if from == "bg" {
        img = selectedImage
        self.tablerView.reloadSections([0], with: .automatic)
        postPhoto(imgi: selectedImage, type: "bckg")
        }
       let success = saveImage(image: selectedImage)
        print(success)
        tookPhoto = true
        
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    var once = true
    func postPhoto (imgi: UIImage, type: String) {
        
        if once == true {
            once = false
        
                if let uid = Auth.auth().currentUser?.uid {
                    
                    let storage = Storage.storage().reference().child(uid).child("\(type).jpg")
                    if let uploadData = imgi.jpegData(compressionQuality: 0.40) {
                        storage.putData(uploadData, metadata: nil, completion:
                            { (metadata, error) in
                                guard let metadata = metadata else {
                                    // Uh-oh, an error occurred!
                                    print(error!)
                                    self.once = true
                                    return
                                }
                                
                                print(metadata)
                                storage.downloadURL { url, error in
                                    guard let downloadURL = url else {
                                        print("erroor downl")
                                        return
                                    }
                                    
                                    let ref = Database.database().reference()
                                    let postFeed = ["\(type)Url" : downloadURL.absoluteString]
                                    ref.child("users").child(uid).updateChildValues(postFeed)
                                    self.once = true
                                }
                                
                        })
                    }
                    
                    
                }
            }
        
    
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
    
    
    
    func fetchStars () {
        if let uid = Auth.auth().currentUser?.uid {
            if Auth.auth().currentUser?.isAnonymous == false {
        let ref = Database.database().reference().child("users").child(uid).child("stars")
            ref.observeSingleEvent(of: .value, with: {(thanosSnap) in
                if let total = thanosSnap.value as? [String : AnyObject] {
                    self.count = total.count
                    self.starCollection.reloadData()
                }
            })
            self.activity.stopAnimating()
        }
        }
    }
    
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            if from == "profile" {
            try data.write(to: directory.appendingPathComponent("profileImg.png")!)
            } else if from == "bg" {
            try data.write(to: directory.appendingPathComponent("backGround.png")!)
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != UIColor.black {
            textView.textColor = .black
        }
    }
     let postButton = UIButton()
    let textviewA = UITextView()
    let exitButtonComment = UIButton()
    let divideViewComment = UIView()
 
    func setUpComment () {
        
        textviewA.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        
        if let mySavedDes = UserDefaults.standard.value(forKey: "bio") as? String {
            textviewA.text = mySavedDes
        } else {
            textviewA.text = "Add a bio..."
        }
        textviewA.delegate = self
        textviewA.frame = CGRect(x: 0, y: 51, width: self.view.frame.width, height: 100)
        divideViewComment.frame = CGRect(x: 0, y: 0, width: commentingView.frame.width , height: 50)
        divideViewComment.backgroundColor = UIColor(red: 0.8863, green: 0.8706, blue: 0.898, alpha: 1.0)
        commentingView.layer.shadowColor = UIColor.gray.cgColor
        commentingView.layer.shadowOpacity = 1
        commentingView.layer.shadowOffset = CGSize.zero
        commentingView.layer.shadowRadius = 2
        commentingView.layer.cornerRadius = 8.0
        divideViewComment.roundCorners([.topLeft, .topRight], radius: 8.0)
        commentingView.addSubview(divideViewComment)
        commentingView.backgroundColor = .white
        exitButtonComment.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        exitButtonComment.setTitle("Exit", for: .normal)
        exitButtonComment.addTarget(self, action: #selector(self.closeComment), for: .touchUpInside)
        exitButtonComment.setTitleColor(.gray, for: .normal)
        
       
        postButton.frame = CGRect(x: self.commentingView.frame.width - 95, y: 8, width: 80, height: 34)
        postButton.backgroundColor = UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0)
        postButton.setTitleColor(.white, for: .normal)
        postButton.setTitle("Done", for: .normal)
        postButton.layer.cornerRadius = 10.0
        postButton.addTarget(self, action: #selector(self.doneBio), for: .touchUpInside)
        postButton.clipsToBounds = true
        
        self.commentingView.addSubview(postButton)
        self.commentingView.addSubview(exitButtonComment)
        self.commentingView.addSubview(textviewA)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        return numberOfChars < 105
    }
    
    var commentOpen = false
    let commentingView = UIView()
    @objc func openComment () {
        commentingView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        self.view.addSubview(commentingView)
        setUpComment()
        commentOpen = true
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.commentingView.frame = CGRect(x: 0, y: self.view.frame.height / 3.4, width: self.view.frame.width, height: self.view.frame.height - self.view.frame.height / 3.4)
            self.textviewA.becomeFirstResponder()
        }, completion: nil)
    }
    @objc func closeComment () {
        textviewA.resignFirstResponder()
        commentOpen = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.commentingView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        }, completion: { finished in
            self.commentingView.removeFromSuperview()
            self.exitButtonComment.removeFromSuperview()
            self.divideViewComment.removeFromSuperview()
            self.textviewA.removeFromSuperview()
        })
        
    }
    
  @objc func doneBio () {
    closeComment()
    if textviewA.text != "" {
        if textviewA.text.contains("god hates") || textviewA.text.contains("shoot") {
            
        } else {
        let text = textviewA.text
        UserDefaults.standard.set(text, forKey: "bio")
        if let uid = Auth.auth().currentUser?.uid {
              if Auth.auth().currentUser?.isAnonymous == false {
            let ref = Database.database().reference().child("users").child(uid)
            let postFeed: [String : String] = ["bio" : text!]
            ref.updateChildValues(postFeed)
            }
        }
         self.tablerView.reloadSections([0], with: .automatic)
        }
    } else {
         if let uid = Auth.auth().currentUser?.uid  {
            if Auth.auth().currentUser?.isAnonymous == false {
         let ref = Database.database().reference().child("users").child(uid).child("bio")
        ref.removeValue()
            }
        }
    }
    }
    
    var followerCount = 0;
    func grabFollowersCount () {
       
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
              if Auth.auth().currentUser?.isAnonymous == false {
        ref.child("users").child(uid).child("followers").observeSingleEvent(of: .value, with: { (snapshoti) in
            if let followers = snapshoti.value as? [String : AnyObject] {
                self.followerCount = followers.count
                self.followersLabel.text = "• \(followers.count) followers"
            }
            })
            }
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
            if scrollView == tablerView {
                if self.timeRepeated < 10 {
                    if self.working == false {
                        self.loadingMore = true
                        self.loadYourStuff()
                    }
                }
            }
        }
    }
    
    
    func userDidChangeLikeDislike(type: String, index: IndexPath, cell: String, aid: String, myId: String) {
        if type == "Like" {
            let uid = myId
            
            let ref = Database.database().reference().child("artItems").child(aid).child("likeArray")
            let ref2 = Database.database().reference().child("artItems").child(aid).child("dislikeArray")
            ref2.child(uid).removeValue()
            let feeder: [String : Any] = [uid : "like"]
            ref.updateChildValues(feeder)
            
        }
        if type == "Dislike" {
            let uid = myId
            let ref = Database.database().reference().child("artItems").child(aid).child("dislikeArray")
            let ref2 = Database.database().reference().child("artItems").child(aid).child("likeArray")
            ref2.child(uid).removeValue()
            let feeder: [String : Any] = [uid : "dislike"]
            ref.updateChildValues(feeder)
            
        }
        if type == "None" {
            let uid = myId
            let ref = Database.database().reference().child("artItems").child(aid).child("dislikeArray")
            let ref2 = Database.database().reference().child("artItems").child(aid).child("likeArray")
            ref.child(uid).removeValue()
            ref2.child(uid).removeValue()
            
        }
        
        self.arts[index.row].personalLikeDis = type
        
        
        
        //save context
        if type == "Like" {
            let defaults = UserDefaults.standard
            var myarray = defaults.stringArray(forKey: "likedArray") ?? [String]()
            if myarray.contains(aid) {
                print("already in")
            } else {
                myarray.append(aid)
                print("added one like")
                defaults.set(myarray, forKey: "likedArray")
            }
            //remove from dislike
            var myarran = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
            if let index = myarran.firstIndex(of: aid) {
                myarran.remove(at: index)
                print("removed one dislike /c like")
            }
            defaults.set(myarran, forKey: "dislikeArray")
        }
        if type == "Dislike" {
            let defaults = UserDefaults.standard
            var myarrayi = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
            if myarrayi.contains(aid) {
                print("already in")
            } else {
                myarrayi.append(aid)
                print("added one dislike")
                defaults.set(myarrayi, forKey: "dislikeArray")
            }
            //remove from like
            var myarran = defaults.stringArray(forKey: "likedArray") ?? [String]()
            if let index = myarran.firstIndex(of: aid) {
                print("removed one like /c dislike")
                myarran.remove(at: index)
            }
            defaults.set(myarran, forKey: "likedArray")
            
        }
        if type == "None" {
            //check both then remove
            let defaults = UserDefaults.standard
            var myarran = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
            if let index = myarran.firstIndex(of: aid) {
                myarran.remove(at: index)
            }
            defaults.set(myarran, forKey: "dislikeArray")
            var myarrayL = defaults.stringArray(forKey: "likedArray") ?? [String]()
            if let indexl = myarrayL.firstIndex(of: aid) {
                myarrayL.remove(at: indexl)
            }
            defaults.set(myarrayL, forKey: "likedArray")
            
        }
        
        
    }
    
    func userAlreadyUpdatedActive(index: IndexPath) {
        //
    }
    
    func nowAllowBiasVote(index: IndexPath) {
        //
    }
    
    func userDidChangeBias(biasScore: Float, aid: String, index: IndexPath, myId: String, cell: String) {
        
        if arts.count > 0 {
            
            let uid = myId
            let ref1 = Database.database().reference().child("artItems").child(aid).child("biasVotes")
            
            let feeder: [String : Any] = [uid : biasScore]
            ref1.updateChildValues(feeder)
            
            
            //    var array = [Float]()
            var zeroStart:Float = 0
            
            let refUpdateAll = Database.database().reference().child("artItems").child(aid).child("biasVotes")
            refUpdateAll.observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshot = snapshot.value as? [String : AnyObject] {
                    for (_,each) in snapshot {
                        let floatt = each as! NSNumber
                        //  array.append(floatt.floatValue)
                        zeroStart += floatt.floatValue
                    }
                    
                    let final = zeroStart / Float(snapshot.count)
                    
                    let upRef = Database.database().reference().child("Feed").child(aid)
                    let feedo: [String : Any] = ["bias" : "\(final)"]
                    upRef.updateChildValues(feedo)
                    
                    let inty = roundf(biasScore)
                    let newInty = Int(inty)
                    self.arts[index.row].bias = newInty
                    
                }
                else {
                    
                    let upRef = Database.database().reference().child("Feed").child(aid)
                    let feedo: [String : Any] = ["bias" : "\(biasScore)"]
                    upRef.updateChildValues(feedo)
                    let inty = roundf(biasScore)
                    let newInty = Int(inty)
                    self.arts[index.row].bias = newInty
                    
                }
                
            })
            
        }
    }
    

    var descriptor = String()
    func checkIfClean(string: String, from: String) {
        if string.count > 2 {
            let string1 = string.lowercased()
            if  string1.contains(";") || string1.contains(")") || string1.contains("$") || string1.contains("&") || string1.contains("shit") || string1.contains("fuck") || string1.contains("suck") || string1.contains("ass")  || string1.contains("dick") || string1.contains("cock") || string1.contains("penis") || string1.contains("lick") || string1.contains("vagina") || string1.contains("pussy") || string1.contains("fag") || string1.contains("tit") || string1.contains("boob") || string1.contains("hole") || string1.contains("butt") || string1.contains("anal") || string1.contains("milf") || string1.contains("cunt") || string1.contains("/") || string1.contains("hate") || string1.contains("\\") || string1.contains("\"") ||  string1.contains("porn") || string1.contains("sex") || string1.contains("nigger") || string1.contains("beaner") || string1.contains("coon") || string1.contains("spic") || string1.contains("wetback") || string1.contains("chink") || string1.contains("gook") || string1.contains("porn") || string1.contains("twat") || string1.contains("crow")  || string1.contains("darkie")  || string1.contains("bitch") || string1.contains("god hates") || string1.contains("  ") || string1.contains("klux") || string1.contains("kkk") || string1.contains("nigga")
                
            {
                
            } else {
                
                if from == "name" {
                     if string.count < 32 {
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    
                    let ref = Database.database().reference()
                    if let currentUser = Auth.auth().currentUser?.uid {
                        changeRequest.displayName = string
                        changeRequest.commitChanges(completion: nil)
                       
                        namelabel.text = string
                        let newTitle = ["name" : string]
                        ref.child("users").child(currentUser).updateChildValues(newTitle)
                        self.fixNameLabel(name: string)
                    }
                    }
                } else if from == "description" {
                   
                    let newDest = ["bio" : string]
                    if let uid = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference()
                        ref.child("users").child(uid).updateChildValues(newDest)
                        self.descriptor = string
                      
                    
                    }
                }
            }
        }
    }
    
    func fixNameLabel (name: String) {
        if let mySavedUn = UserDefaults.standard.value(forKey: "username") as? String {
            musername = mySavedUn
           
                namelabel.text = "\(name) @\(mySavedUn)"
            
        } else {
            musername = ""
        }
        if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isAnonymous == false  {
            let charactersCount = namelabel.text?.count
            let usnmcount = ((musername?.count)! + 1)
            let amountText = NSMutableAttributedString.init(string: "\(String(namelabel.text!))")
            
            // set the custom font and color for the 0,1 range in string
            amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                      NSAttributedString.Key.foregroundColor: UIColor.lightGray],
                                     range: NSMakeRange(charactersCount! - usnmcount, usnmcount))
            // if you want, you can add more attributes for different ranges calling .setAttributes many times
            
            // set the attributed string to the UILabel object
            self.namelabel.attributedText = amountText
            
            
        }
        
    }
    
    
    func publishers (name: String) -> String {
        if name.contains("Bloomberg") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FbloomEdit-2.png?alt=media&token=16b9f1f5-beac-437f-81a3-9086b9e278e3"
        }
        if name.contains("Breitbart") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FbreitbartEdit.png?alt=media&token=435d55bb-5d93-4ddc-8ee1-0e0a11944aee"
        }
        if name.contains("Cbs") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Fcbsedit.png?alt=media&token=6d354dcd-03dd-44d0-b418-41d487663ba9"
        }
        if name.contains("Cnn") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FcnnEdit.png?alt=media&token=35cf1026-f85d-46a3-a973-0faf0a2a976f"
        }
        if name.contains("Nbc") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Fnbcnewp.png?alt=media&token=d4728942-1306-4602-b195-4fcaa072bb63"
        }
        if name.contains("Newsweek") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FnewsweekEdit.png?alt=media&token=24ee7f3d-c05b-45a4-ab95-db7e42acf73c"
        }
        if name.contains("New York Magazine") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FnewsMagEdit.png?alt=media&token=0487878d-a127-43fa-a107-b5f2c7568380"
        }
        if name.contains("The New York Times") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Fnyttt.png?alt=media&token=67db126a-8c05-47b9-8160-863f0e83d200"
        }
        if name.contains("Politico") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Fpoliticoedit.png?alt=media&token=2b64e726-1a90-44b4-9f64-77a91be49e3e"
        }
        if name.contains("euters") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Freutersrun.png?alt=media&token=291158af-0406-4219-a466-06f0f91085f0"
        }
        if name.contains("The Washington Post") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FwpEdit.png?alt=media&token=f80c2222-744f-4813-92cb-2d87d5fcaf06"
        }
        if name.contains("Wall") && name.contains("Journal") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Fwsj.png?alt=media&token=2f821d6f-45fe-4b8f-a926-39d7e6ee2a86"
        }
        if name.contains("Usa Today") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FusaTodayEdit.png?alt=media&token=685679c1-63a5-4d2d-b631-191f081e596f"
        }
        if name.contains("The Hill") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FtheHillEdit.png?alt=media&token=664a1d8c-ef10-4c2a-ba46-3e63cac1a8b6"
        }
        if name.contains("Abc News") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FabcEdit.png?alt=media&token=38d4d576-dd5c-4b53-8761-32d2429ec858"
        }
        if name.contains("Fox News") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FfoxNewsEdit.png?alt=media&token=e59b711a-6d4a-4bad-a342-e895517a3890"
        }
        if name.contains("The Economist") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FeconomistEdit.png?alt=media&token=6e2fe50d-8017-4d27-a8c3-8a1300b61de3"
        }
        if name.contains("Vice News") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FviceEdit.png?alt=media&token=09eac551-1e59-4db6-8448-38360acc0684"
        }
        if name.contains("Msnbc") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FmsnbcEdit.png?alt=media&token=5eba2186-f654-4b63-b3f1-93f1dac0912a"
        }
        if name.contains("Fortune") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Ffortune_white.png?alt=media&token=24a8262f-5409-4fc0-9e03-7f5c16dfee21"
        }
        let none = "none"
        return none
    }
    
 
    
}


//let smallest = min(selectedImage.size.width, selectedImage.size.height)
//let largest = max(selectedImage.size.width, selectedImage.size.height)
//
//let ratio = Float(largest/smallest)
//
//let maximumRatioForNonePanorama = Float(4 / 3) // check with your ratio
//
//if ratio > maximumRatioForNonePanorama {
//    return
//}
