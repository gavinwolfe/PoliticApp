//
//  UserViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 3/8/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, changedValues {

    var tablerView = UITableView()
    var starCollection: UICollectionView!
   var hasNotFinishedLoading = true
    
    var namer: String?
    var username: String?
    var profilePhoto: UIImage?
    var profilePhotoUrl: String?
    var profileBcgPhotoUrl: String?
    var theirUid: String?
    var userKey: String?
    
     //var myId: String?
    
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController!.navigationBar.isHidden = true

        self.followButton.isEnabled = false
     
       // activity.backgroundColor = .black
    
        
        
      layoutViews()
        tablerView.delegate = self
        tablerView.dataSource = self
        
        
        if self.profilePhoto == nil {
          self.grabProfilePhoto()
        }
  
       
        
        if let theirId = theirUid {
        grabTheirBio(uid: theirId)
            self.loadYourStuff()
        }
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        let farm = CGRect(x: 0, y: 0, width: 200, height: 0)
        starCollection = UICollectionView(frame: farm, collectionViewLayout: layout)
        starCollection.delegate   = self
        starCollection.dataSource = self
        starCollection.register(StarsCollectionViewCell.self, forCellWithReuseIdentifier: "cellStar")
        starCollection.backgroundColor = .clear
        starCollection.backgroundView?.backgroundColor = .clear 
        
        automaticallyAdjustsScrollViewInsets = false
        
        tablerView.register(AUserTableViewCell.self, forCellReuseIdentifier: "aUser")
        tablerView.separatorStyle = .none
        self.tablerView.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        //self.tablerView.backgroundView = nil
        self.view.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        let buttonDismiss = UIButton(frame: CGRect(x: 5, y: 15, width: 50, height: 50))
        
        buttonDismiss.addTarget(self, action: #selector(self.dismisser), for: .touchUpInside)
        self.view.addSubview(buttonDismiss)
        
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
     
      self.checkIfYouBlocked()
       self.fetchStars()
        self.grabUserKey()
        // Do any additional setup after loading the view.
    }
    
    func grabUserKey () {
        if Auth.auth().currentUser?.displayName != nil {
            if let theirId = self.theirUid {
                if let theirKey = self.userKey {
                  self.userKey = theirKey
                } else {
        let ref = Database.database().reference().child("users").child(theirId).child("userKey")
                    ref.observeSingleEvent(of: .value, with: {(snip) in
                        if let vali = snip.value as? String {
                            self.userKey = vali
                        } else {
                            self.userKey = " "
                        }
                        
                    })
        
                }
            }
        }
    }
    
    @objc func clickedOnExternalLink (sender: UIButton) {
    if let url = arts[sender.tag].mainUrl {
        if let mySavedDes = UserDefaults.standard.value(forKey: "dataLog") as? Int {
                   if mySavedDes >= 3 {
                    let radOne = Int.random(in: 1..<6)
                    if radOne == 5 || radOne == 4 || radOne == 1 {
                        UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
                                                             return
                    } else {
                        print("noo")
                      //nothing
                    }
                   } else {
                    UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
                                  return
            }
            }  else {
                       UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
                          return
                       }
        }
    }

    @objc func dismisser() {
        DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     let labelLoading = UILabel()
    var onceAddLoading = false
    var loadingOver = true
      let imageView2 = UIImageView()
    var followCount = 0
    let followButton = UIButton()
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if img == nil {
            img = UIImage(named: "bgh")
        }
        if let outImage = theImg {
            img = outImage
        }
        if section == 1 {
            let label: UILabel = {
                let lb = UILabel()
                lb.translatesAutoresizingMaskIntoConstraints = false
                lb.text = "\(theirBio)"
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
        let imagerBackView = UIImageView(image: img)
        let overlay = UIButton(frame: CGRect(x: 10, y: 5, width: 50, height: 40))
        imagerBackView.isUserInteractionEnabled = true
        overlay.backgroundColor = UIColor.clear
        overlay.setTitleColor(.white, for: .normal)
        overlay.setTitle("Done", for: .normal)
        overlay.titleLabel!.layer.shadowColor = UIColor.black.cgColor
         overlay.titleLabel!.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
         overlay.titleLabel!.layer.shadowOpacity = 1.0
         overlay.titleLabel!.layer.shadowRadius = 0
         overlay.titleLabel!.layer.masksToBounds = false
        overlay.addTarget(self, action: #selector(dismisser), for: .touchUpInside)
        imagerBackView.addSubview(overlay)
        let overlay2 = UIButton(frame: CGRect(x: self.view.frame.width - 45, y: 10, width: 35, height: 35))
        let overlay2Image = UIImageView(frame: CGRect(x: self.view.frame.width - 42, y: 12, width: 32, height: 32))
        overlay2Image.image = UIImage(named: "moreIcona.png")
        overlay2.addTarget(self, action: #selector(self.showMore), for: .touchUpInside)
        overlay2.backgroundColor = UIColor.clear
        
        imagerBackView.addSubview(overlay2Image)
        imagerBackView.addSubview(overlay2)
        let canseeview = UIView()
        canseeview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
      
        let namelabel = UILabel()
        
        let followersLabel = UILabel()
        
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
        namelabel.frame = CGRect(x: 70, y: heightter - 60, width: self.view.frame.width - 80, height: 30)
            followButton.frame = CGRect(x: self.view.frame.width - 110, y: heightter - 40, width: 100, height: 32)
            followersLabel.frame = CGRect(x: 70, y: heightter - 35, width: 150, height: 25)
      
            let framer = CGRect(x: 10, y: heightter - 110, width: imagerBackView.frame.width, height: 30)
          
       starCollection.frame = framer
          
           
        }
        followButton.backgroundColor = UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0)
        followButton.setTitleColor(.white, for: .normal)
        followButton.setTitle("-----", for: .normal)
        if self.isFollowing == false {
        followButton.backgroundColor = UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0)
        followButton.setTitleColor(.white, for: .normal)
        followButton.setTitle("Follow", for: .normal)
        } else if self.isFollowing == true {
            followButton.backgroundColor = .white
            followButton.setTitleColor(UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0), for: .normal)
            followButton.setTitle("Following", for: .normal)
        }
        followButton.layer.cornerRadius = 8.0
        followButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        followButton.addTarget(self, action: #selector(self.followUnfollow), for: .touchUpInside)
        imagerBackView.addSubview(canseeview)
        imagerBackView.addSubview(starCollection)
        imagerBackView.addSubview(followButton)
        if let theirPhoto = profilePhoto {
            imageView2.image = theirPhoto
            
        } else {
            imageView2.image = UIImage(named: "profile")
        }
        
        if self.loadingOver == true {
            if self.onceAddLoading == false {
       
        labelLoading.frame = CGRect(x: 20, y: self.view.frame.height / 2, width: view.frame.width - 40, height: 30)
        labelLoading.text = "This profile is loading, please wait"
        labelLoading.textAlignment = .center
        labelLoading.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        labelLoading.textColor = .white
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 1136:
                    labelLoading.text = "This profile is loading..."
                    default:
                        print("unko")
                    }
                
        }

        self.tablerView.addSubview(labelLoading)
            self.onceAddLoading = true
        }
        } else {
            labelLoading.removeFromSuperview()
        }
        imageView2.contentMode = .scaleAspectFill
        imageView2.layer.cornerRadius = 25.0
        imageView2.clipsToBounds = true
        imagerBackView.addSubview(imageView2)
        namelabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        namelabel.textColor = .white
        namelabel.text = ""
        if let namer = self.namer {
            namelabel.text = namer
        }
        
        followersLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        followersLabel.textColor = .white
        followersLabel.text = "• \(followCount) Followers"
      imagerBackView.addSubview(namelabel)
        imagerBackView.addSubview(followersLabel)
        return imagerBackView
    }
    var img: UIImage?
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if img == nil {
            img = UIImage(named: "bgh")
        }
        if let outImage = theImg {
            img = outImage
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
            print(ighit)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return arts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "aUser", for: indexPath) as! AUserTableViewCell
       
      
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
            if self.profilePhoto != nil {
                cell.captionImage.image = self.profilePhoto
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
        cell.externalButton.tag = indexPath.row
        cell.externalButton.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
        
        return cell
    }
    
   
    
    func layoutViews () {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .grouped)
        view.addSubview(tablerView)
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arts[indexPath.row].caption != nil {
            return 215
        }
        return 180
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedArt") as? SelectedArticleViewController {
                if let cell2 = tablerView.cellForRow(at: indexPath) as? AUserTableViewCell {
                                          if let imager = cell2.imagerView.image {
                                           destination.img = imager
                                   }
                               }
                 destination.modalPresentationStyle = .fullScreen
                destination.delegate = self
                destination.indexPathi = indexPath
             //   destination.useID = self.myId
                if let personalLikeDis = self.arts[indexPath.row].personalLikeDis {
                    destination.personLikeDis = personalLikeDis
                }
                if let urlPub = arts[indexPath.row].publisherUrl {
                                            if urlPub != "none" {
                                                destination.publisherImageUrl = urlPub
                                            }
                                        }
                destination.titler = arts[indexPath.row].titler
                destination.cell = "1"
                destination.allowedToGoToProfile = 1
                destination.timer = arts[indexPath.row].time
                destination.publisher = arts[indexPath.row].publisher
                destination.urlToLoad = arts[indexPath.row].mainUrl
                destination.aid = arts[indexPath.row].aid
                if let navigator = navigationController {
                    navigator.pushViewController(destination, animated: true)
                }
            }
        }
    }
    
    var isFollowing : Bool?
    func checkIfFollowing () {
         //  self.activity.startAnimating()
        if let uid = Auth.auth().currentUser?.uid  {
             if Auth.auth().currentUser?.isAnonymous == false {
            if let theirId = self.theirUid {
        let ref = Database.database().reference().child("users").child(theirId).child("followers")
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    
                    if let youFollow = snapshot.value as? [String : AnyObject] {
                        self.followCount = youFollow.count
                        if let yep = youFollow[uid] {
                            self.isFollowing = true
                            print(yep)
                           
                        } else {
                            self.isFollowing = false
                        }
                    } else {
                        self.isFollowing = false
                    }
                    self.tablerView.reloadData()
                })
            
                
            }
            
        } else {
             self.isFollowing = false
            if let theirId = self.theirUid {
            let ref = Database.database().reference().child("users").child(theirId).child("followers")
            ref.observeSingleEvent(of: .value, with: {(snap) in
                
                if let youFollow = snap.value as? [String : AnyObject] {
                     self.followCount = youFollow.count
                
                }
                 self.tablerView.reloadData()
            })
            }
           
        }
        }
    }
    
    var arts = [Article]()
   
    var loadingMore = false
    var working = false
     var timeRepeated = 1;
    func loadYourStuff() {
       
         let last = timeRepeated * 6
          working = true
        var howManyAdded = 0;
         var reloadAdded = false
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        if let theiruid = self.theirUid {
            let ref = Database.database().reference().child("users").child(theiruid).child("Reposts")
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
                                    if let caption = lip["caption"] as? String {
                                        newArt.caption = caption
                                    }
                                    newArt.publisherUrl = self.publishers(name: last.capitalized)
                                    if let urlImg = titlr?["urlToImage"] as? String {
                                        newArt.imageUrl = urlImg
                                    } else {
                                        newArt.imageUrl = "none"
                                    }
                                    if likeArraySave.contains(aidi) {
                                        newArt.personalLikeDis = "Like"
                                        print("GOT A LIKE")
                                    }
                                    
                                    if dislikeArraySave.contains(aidi) {
                                        newArt.personalLikeDis = "Dislike"
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
                                
                                        let indexPather = IndexPath(row: self.arts.count-loop, section: 1)
                                        self.tablerView.reloadRows(at: [indexPather], with: .automatic)
                                        loop+=1
                                    
                                }
                            } else {
                                self.tablerView.reloadData()
                            }
                            self.timeRepeated+=1
                            self.working = false
                        }
                        self.labelLoading.text = ""
                        self.labelLoading.removeFromSuperview()
                        self.hasNotFinishedLoading = false
                        self.followButton.isEnabled = true
                    }
                        
                    
                    
                } else {
                    
                    let emblem = UIImageView()
                    emblem.frame = CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2, width: 60, height: 60)
                    emblem.image = UIImage(named: "news")
                    let subLabel = UILabel()
                    subLabel.frame = CGRect(x: 20, y: self.view.frame.height / 2 + 70, width: self.view.frame.width - 40, height: 80)
                    subLabel.text = "This user has yet to repost any articles... Someone tell them to (:"
                    subLabel.textAlignment = .center
                    subLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
                    
                    subLabel.numberOfLines = 3
                    subLabel.textColor =  UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
                    self.tablerView.addSubview(emblem)
                    self.tablerView.addSubview(subLabel)
                    
                    self.labelLoading.text = ""
                    self.labelLoading.removeFromSuperview()
                    self.hasNotFinishedLoading = false
                    self.followButton.isEnabled = true
                }
            }, withCancel: nil)
        }
    }
    
    func grabProfilePhoto () {
      
        if let theirId = self.theirUid {
            let ref = Database.database().reference().child("users").child(theirId).child("profileUrl")
            ref.observeSingleEvent(of: .value, with: {(snapper) in
               
                    if let url = snapper.value as? String {
                        self.profilePhotoUrl = url
                        let url2 = URL(string: url)
                        let data = try? Data(contentsOf: url2!)
                        self.profilePhoto = UIImage(data: data!)
                       
                    }
                
                
            })
           
        }
    }
    
    var count = 0;
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStar", for: indexPath) as! StarsCollectionViewCell
        cell.imagerView.image = #imageLiteral(resourceName: "stark")
        return cell
    }
    
    var theirBio = " "
    func grabTheirBio (uid: String) {
        
        let ref = Database.database().reference().child("users").child(uid).child("bio")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let bio = snapshot.value as? String {
                self.theirBio = bio
            }
            self.grabTheirBckPhoto(uid: uid)
        })
        
    }
    var bcgPhoto: String?
    var theImg: UIImage?
    func grabTheirBckPhoto (uid: String) {
        let ref = Database.database().reference().child("users").child(uid).child("bckgUrl")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let url = snapshot.value as? String {
                self.bcgPhoto = url
                let url2 = URL(string: url)
                let data = try? Data(contentsOf: url2!)
                self.theImg = UIImage(data: data!)
            }
            self.checkIfFollowing()
        })
    }
    
    @objc func followUnfollow () {
         if Auth.auth().currentUser?.isAnonymous == false {
        if self.youBlocked == false {
        if self.isFollowing == false {
            if let uid = Auth.auth().currentUser?.uid {
                if let theirId = self.theirUid {
            let ref = Database.database().reference().child("users").child(theirId).child("followers")
                    let update: [String : Any] = [uid : uid]
                ref.updateChildValues(update)
                    self.isFollowing = true
                    self.followButton.backgroundColor = .white
                    self.followButton.setTitleColor(UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0), for: .normal)
                    self.followButton.setTitle("Following", for: .normal)
                    self.sendNotif()
                    return
                }
            } else {
                let alert = UIAlertController(title: "You need to create or login to an account to do that!", message: "", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        }
        if self.isFollowing == true {
            if let uid = Auth.auth().currentUser?.uid {
                if let theirId = self.theirUid {
                    let ref = Database.database().reference().child("users").child(theirId).child("followers").child(uid)
                    ref.removeValue()
                    self.isFollowing = false
                    followButton.backgroundColor = UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0)
                    followButton.setTitleColor(.white, for: .normal)
                    followButton.setTitle("Follow", for: .normal)
                    return 
                }
            }
        } else if self.isFollowing == nil {
            return
        }
        }
        }
    }
    
    func fetchStars () {
        if let theirId = self.theirUid {
            let ref = Database.database().reference().child("users").child(theirId).child("stars")
            ref.observeSingleEvent(of: .value, with: {(thanosSnap) in
                if let total = thanosSnap.value as? [String : AnyObject] {
                    self.count = total.count
                    self.starCollection.reloadData()
                }
            })
            
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
                    if self.hasNotFinishedLoading == false {
                    if self.working == false {
                        self.loadingMore = true
                        
                        self.loadYourStuff()
                    }
                }
                }
            }
        }
    }
    
    var alreadySentReply = false
    func sendNotif () {
        
        if self.alreadySentReply == false && self.theirUid != Auth.auth().currentUser?.uid {
            self.alreadySentReply = true
          
                if let userkey = self.userKey  {
                    if userkey != " " {
                    if let myNme = Auth.auth().currentUser?.displayName {
                        let messgae = "\(myNme) started following you!"
                        print("sending notif")
                        let data = [
                            "contents": ["en": "\(messgae)"],
                            "include_player_ids":["\(userkey)"],
                            "ios_badgeType": "Increase",
                            "ios_badgeCount": 1
                            ] as [String : Any]
                        OneSignal.postNotification(data)
                        print("send out")
                        if let theirUid = self.theirUid {
                            let refUse = Database.database().reference()
                            let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                            let time = Int(NSDate().timeIntervalSince1970)
                            let ref3 = Database.database().reference()
                            if let myId = Auth.auth().currentUser?.uid  {
                             
                                let setip = ["notification" : "\(myNme) started following you!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : myNme, "key" : key!, "aid" : "following", "url" : "following", "unseen" : "unseen"] as [String : Any]
                                    
                                    let final = [key : setip]
                                    ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                                
                            }
                        }
                    }
                    } else {
                        if let theirUid = self.theirUid {
                            let refUse = Database.database().reference()
                            let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                            let time = Int(NSDate().timeIntervalSince1970)
                            let ref3 = Database.database().reference()
                            if let myId = Auth.auth().currentUser?.uid  {
                                  if let myNme = Auth.auth().currentUser?.displayName {
                                let setip = ["notification" : "\(myNme) started following you!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : myNme, "key" : key!, "aid" : "following", "url" : "following", "unseen" : "unseen"] as [String : Any]
                                
                                let final = [key : setip]
                                ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                                
                            }
                            }
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
    
   
    
    var blocked = false
    func checkIfUserIsBlocked () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let id = self.theirUid {
                ref.child("users").child(uid).child("blocked").child(id).observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.exists() {
                        self.blocked = true
                    } else {
                        print("not blocked")
                    }
                })
            }
        }
    }
    
    @objc func showMore () {
        
        
        var stringle: String?
        
        if self.blocked == true {
            stringle = "Unblock"
        } else {
            stringle = "Block"
        }
        
        let popup = UIAlertController(title: "Actions", message: "Select what you would like to do", preferredStyle: .actionSheet)
        
    
        
        var actionTwo = UIAlertAction()
        if let stringler = stringle {
            actionTwo = UIAlertAction(title: stringler, style: .default, handler: { (alert : UIAlertAction) -> Void in
                
                 if Auth.auth().currentUser?.isAnonymous == false {
                if self.blocked == true {
                    let ref = Database.database().reference()
                    if let uid = Auth.auth().currentUser?.uid {
                        if let id = self.theirUid {
                            ref.child("users").child(uid).child("blocked").child(id).removeValue()
                            self.blocked = false
                           
                        }
                    }
                    print("unblock")
                } else {
                    let ref = Database.database().reference()
                    if let uid = Auth.auth().currentUser?.uid {
                        if let id = self.theirUid {
                            let feed = [id : id]
                            ref.child("users").child(uid).child("blocked").updateChildValues(feed)
                            self.blocked = true
                            let ref2 = ref.child("Users").child(uid).child("followers").child(id)
                            ref2.removeValue()
                        }
                    }
                    print("block")
                }
                }
            })
        }
        
      
        
        
        let canceler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        
       
        actionTwo.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        popup.addAction(actionTwo)
       
        popup.addAction(canceler)
        self.present(popup, animated: true, completion: nil)
    }
    var youBlocked = false
    func checkIfYouBlocked () {
        if let myId = Auth.auth().currentUser?.uid {
            if let theirId = self.theirUid {
        let ref = Database.database().reference().child("users").child(theirId).child("blocked").child(myId)
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let snt = snapshot.value as? String {
                    print(snt)
                    self.followButton.isEnabled = false
                    self.youBlocked = true
                }
                
            })
            
                
            }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
