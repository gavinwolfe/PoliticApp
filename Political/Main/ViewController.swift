//
//  ViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 10/3/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Kingfisher
import SafariServices


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, changedValues, UICollectionViewDelegateFlowLayout {

  
    var collectionerView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let loadingView = UIImageView()
    
   //  var noID = "o"
    
    var refreshControl = UIRefreshControl()
    
 
    //check notes file for replace code (note to self)
    var articles = [Article]()
    
    func checkLoggedin () {
        if Auth.auth().currentUser?.uid == nil {

            self.displayPopUpMessage()
        }
    
       else {
            
            print("your good")
            self.grabUnseenMessagesCount()
           // print(Auth.auth().currentUser?.uid)
        }
        
    }
    
    
    func grabUnseenMessagesCount() {
        if let uid = Auth.auth().currentUser?.uid  {
            let ref = Database.database().reference()
            if Auth.auth().currentUser?.isAnonymous == false {
            ref.child("users").child(uid).child("inbox").queryOrdered(byChild: "timeSent").queryLimited(toLast: 15).observeSingleEvent(of: .value, with: {(snapshoti) in
                var unseners = [String]()
                if let notifs = snapshoti.value as? [String : AnyObject] {
                    for (_, val) in notifs {
                        if let unseener = val["unseen"] as? String {
                            unseners.append(unseener)
                            self.tabBarController?.tabBar.items?[2].badgeValue = "\(unseners.count)"
                        }
                    }
                    
                }
            }, withCancel: nil)
            }
        }
    }

    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadingView.frame = CGRect(x: 0, y: 160, width: self.view.frame.width, height: view.frame.height - 150)
        //loadingView.image = UIImage(named: "shototo.png")
        loadingView.loadGif(name: "loadUply")
      
       self.view.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        self.collectionerView.addSubview(loadingView)
        self.loadFromFriends()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumInteritemSpacing = 0
        collectionerView.setCollectionViewLayout(layout, animated: true)
        collectionerView.delegate = self
        collectionerView.dataSource = self
        collectionerView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        self.view.addSubview(collectionerView)
        collectionerView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionerView.register(MainTwoCollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        collectionerView.register(MainThreeCollectionViewCell.self, forCellWithReuseIdentifier: "cell3")
        collectionerView.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: "cell4")
        collectionerView.register(nothingCell.self, forCellWithReuseIdentifier: "noneCell")
        collectionerView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 67)
         checkLoggedin()
      
      activity.frame = CGRect(x: 0, y: 160, width: self.view.frame.width, height: view.frame.height-100)
        activity.backgroundColor = .black
        activity.color = .white
        refreshControl.tintColor = UIColor(red: 0.8196, green: 0, blue: 0.3804, alpha: 1.0)
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:4,length:3))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location:0,length:3))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:3,length:1))
        
       
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        collectionerView.addSubview(refreshControl)
        
        collectionerView.register(headerView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        
        collectionerView.register(headerGone.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "nothingHead")
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
               
            case 1334:
                print("iPhone 6/6S/7/8")
               
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
              
            case 2436:
                print("iPhone X, XS")
                collectionerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 97)
                
            case 2688:
                print("iPhone XS Max")
               collectionerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 97)
            case 1792:
                print("iPhone XR")
               collectionerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 97)
            default:
                print("Unknown")
            }
            
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    var waitCallRefresh = false
    @objc func refresh(sender:AnyObject) {
        print("would refresh")
        //check for new articles
        if self.lastReload != 0 {
            if self.waitCallRefresh == false {
                self.waitCallRefresh = true
        self.reloadNowOk = false
        self.checkBeforeReload = true
        
        self.loadFromFriends()
            
            }
        }
      
        // Code to refresh table view
    }
    let noView = UIView()
      let viewR = UIView()
    func displayPopUpMessage () {
      
        noView.frame = self.view.frame
        noView.backgroundColor = #colorLiteral(red: 0.07181023316, green: 0.06591241856, blue: 0.06899734716, alpha: 1).withAlphaComponent(0.8)
        view.addSubview(noView)
        viewR.layer.cornerRadius = 6.0
        viewR.clipsToBounds = true
        viewR.frame = CGRect(x: 30, y: view.frame.midY - 100, width: view.frame.width - 60, height: 220)
        viewR.backgroundColor = .white
        let labelTop = UILabel()
        labelTop.frame = CGRect(x: 15, y: 8, width: viewR.frame.width - 20, height: 30)
        labelTop.textColor = .black
        labelTop.textAlignment = .left
        labelTop.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        labelTop.numberOfLines = 2
        labelTop.text = "Create account?"
        viewR.addSubview(labelTop)
        let buttonYes = UIButton()
        buttonYes.frame = CGRect(x: 15, y: 55, width: viewR.frame.width-30, height: 50)
        buttonYes.clipsToBounds = true
        buttonYes.setTitle("Yes", for: .normal)
        buttonYes.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        buttonYes.layer.cornerRadius = 6.0
        buttonYes.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
        buttonYes.addTarget(self, action: #selector(self.yesClicked), for: .touchUpInside)
        
        viewR.addSubview(buttonYes)
        let buttonNo = UIButton(frame: CGRect(x: 15, y: 115, width: viewR.frame.width - 30, height: 50))
        buttonNo.setTitle("No thanks", for: .normal)
        buttonNo.layer.cornerRadius = 6.0
        buttonNo.setTitleColor(.black, for: .normal)
        buttonNo.clipsToBounds = true
        buttonNo.backgroundColor = UIColor(red: 1, green: 0.9098, blue: 0.8275, alpha: 1.0)
            //UIColor(red: 0.8784, green: 0.8784, blue: 0.8784, alpha: 1.0)
            //UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.0)
        buttonNo.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
       //  buttonNo.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
        buttonNo.addTarget(self, action: #selector(self.noClicked), for: .touchUpInside)
        viewR.addSubview(buttonNo)
        let buttonLogin = UIButton()
        buttonLogin.frame = CGRect(x: 15, y: viewR.frame.height - 35, width: viewR.frame.width - 30, height: 30)
        buttonLogin.setTitle("Or login to an account...", for: .normal)
        buttonLogin.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        buttonLogin.setTitleColor(.systemBlue, for: .normal)
        buttonLogin.addTarget(self, action: #selector(self.loginClicked), for: .touchUpInside)
        viewR.addSubview(buttonLogin)
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        self.view.addSubview(viewR)
    }
    
    @objc func yesClicked () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpVc") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        do {
            try Auth.auth().signOut()
        }   catch let loginError {
            print(loginError)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
   
    
    @objc func noClicked () {
        self.viewR.removeFromSuperview()
        self.noView.removeFromSuperview()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
       
        Auth.auth().signInAnonymously() { (authResult, error) in
        
        }
        let del = AppDelegate()
        del.callNotifs()
        
        if UIDevice().userInterfaceIdiom == .phone {
        self.tutorialMode()
        }
        UserDefaults.standard.set("showBrowser", forKey: "showBrowser")
         UserDefaults.standard.set("showPersonalize", forKey: "showPersonalize")
        
    }
    
    
    
    @objc func loginClicked () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVc") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        do {
                        try Auth.auth().signOut()
            }   catch let loginError {
                        print(loginError)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    var lastReload = 0;
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        print("notified!")
      
            let time = Int(NSDate().timeIntervalSince1970)
            if lastReload != 0 {
                let newTime = time - lastReload
                if newTime >= 1000 {
                    print("here")
                    if scrool < 300 {
                    self.collectionerView.allowsSelection = false
                     loadingView.frame = CGRect(x: 0, y: 160, width: self.view.frame.width, height: view.frame.height - 120)
                    collectionerView.addSubview(activity)
                    collectionerView.addSubview(loadingView)
                    activity.startAnimating()
                    } else {
                        view.addSubview(activity)
                        self.loadingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 35)
                        view.addSubview(loadingView)
                    }
           
                    self.onBias = false
                    self.waitCall = false
                
                    checkBeforeReload = true;
                    reloadNowOk = false
                    changedColor = false
                   slideBar.value = 0
                    self.collectionerView.isScrollEnabled = false
                    self.loadFromFriends()
                    
                }
            }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  print("CALLED CELL SIZE FOR ITEM")
        
        if indexPath.section == 1 || indexPath.section == 5 || section2Index.contains(indexPath.section) {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                    
                case 2436:
                    // print("iPhone X, XS")
                    return CGSize(width: collectionerView.frame.width, height: 192)
                case 2688:
                    // print("iPhone XS Max")
                     return CGSize(width: collectionerView.frame.width, height: 200)
                case 1792:
                    // print("iPhone XR")
                    return CGSize(width: collectionerView.frame.width, height: 200)
                default:
                    print("none")
                }
            }
            if indexPath.row + 1 == radOne {
                return CGSize(width: collectionerView.frame.width, height: 185)
            }
             return CGSize(width: self.view.frame.width, height: 170)
        }
        if indexPath.section == 2 || indexPath.section == 6 || section3Index.contains(indexPath.section) {
            return CGSize(width: collectionerView.frame.width, height: 195)
        }
        if indexPath.section == 3 || indexPath.section == 7 || section4Index.contains(indexPath.section) {
            let its = self.view.frame.width / 2
             return CGSize(width: its, height: its)
        }
        
        if articles.count == 0 {
             return CGSize(width: collectionerView.frame.width, height: 1)
        }
        
        return CGSize(width: self.view.frame.width, height: 400)
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
          
             return CGSize(width: collectionerView.frame.size.width, height: 170)
        }
        return CGSize(width: collectionerView.frame.size.width, height: 0.0001)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 3 || section == 7 || section4Index.contains(section) {
            return 0
        }
        return 5
    }
    
    var onceAdd = false
     let slideBar = UISlider()
    var myString:String = "Politic"
    var myMutableString = NSMutableAttributedString()
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
       
        
        if indexPath.section == 0 {
        let viewH: headerView  = collectionerView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"headerView", for: indexPath) as! headerView
        viewH.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170)
          viewH.subviews.forEach({ $0.removeFromSuperview() })
       let politc = UILabel()
        politc.attributedText = myMutableString
        politc.textAlignment = .left
        politc.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
             let unBias = UILabel()
            if self.view.frame.width > 375 {
                 politc.font = UIFont(name: "HelveticaNeue-Bold", size: 44)
            }
        
        politc.frame = CGRect(x: 15, y: 18, width: view.frame.width - 30, height: 38)
            let sublabel = UILabel(frame: CGRect(x: 15, y: 58, width: self.view.frame.width - 30, height: 30))
            sublabel.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
            sublabel.textColor = UIColor(red: 0.4588, green: 0.4588, blue: 0.4588, alpha: 1.0)
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            sublabel.text = ""
            dateFormatter.dateFormat = "EEEE, MMMM dd"
            let currentDateString: String = dateFormatter.string(from: date)
            sublabel.text = "\(currentDateString)"
           // sublabel.text = "Friday, April 20"
            sublabel.textAlignment = .left
            let profile = UIImageView()
            profile.frame = CGRect(x: self.view.frame.width - 40, y: 26, width: 30, height: 30)
            profile.image = UIImage(named: "prifole")
            let buttonProfile = UIButton()
            buttonProfile.setTitle("", for: .normal)
            buttonProfile.addTarget(self, action: #selector(self.jumpProfile), for: .touchUpInside)
            buttonProfile.frame = CGRect(x: self.view.frame.width - 45, y: 15, width: 35, height: 35)
            if self.onceAdd == false {
           //    self.onceAdd = true
            viewH.addSubview(profile)
            viewH.addSubview(politc)
            viewH.addSubview(buttonProfile)
            viewH.addSubview(sublabel)
                viewH.addSubview(slideBar)
                viewH.addSubview(unBias)
                
            }
           slideBar.isContinuous = false
            slideBar.frame = CGRect(x: 10, y: viewH.frame.height - 65, width: viewH.frame.width - 20, height: 30)
            setSlider(slider: slideBar)
            slideBar.minimumValue = -2
            slideBar.maximumValue = 2
            slideBar.value = value
            slideBar.addTarget(self, action: #selector(self.movedSlider), for: .valueChanged)
            let longtp = UILongPressGestureRecognizer()
            longtp.minimumPressDuration = 1
            longtp.addTarget(self, action: #selector(self.Tap))
            slideBar.addGestureRecognizer(longtp)
            
           
           // viewH.addSubview(unBias)
//            unBias.translatesAutoresizingMaskIntoConstraints = false
//            unBias.centerXAnchor.constraint(equalTo: viewH.centerXAnchor, constant: 0).isActive = true
//            unBias.topAnchor.constraint(equalTo: slideBar.bottomAnchor, constant: 5).isActive = true
            unBias.frame = CGRect(x: view.frame.midX - 150, y: viewH.frame.height - 32, width: 300, height: 20)
//            unBias.frame.size.height = 20
//            unBias.frame.size.width = 300
            unBias.textColor = .gray
            unBias.textAlignment = .center
            unBias.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
            unBias.text = "Drag to filter articles based on bias"
            
            return viewH
        }
        
       let viewh2: headerGone = collectionerView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"nothingHead", for: indexPath) as! headerGone
        viewh2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        return viewh2
        
        
        
    }
    
    @objc func jumpProfile () {
        let vx: ProfileViewController? = ProfileViewController()
        let aObjNavi = UINavigationController(rootViewController: vx!)
        
        aObjNavi.modalPresentationStyle = .fullScreen
        self.present(aObjNavi, animated: true, completion: nil)
        
    }
    
    @objc func inboxOpen () {
        self.performSegue(withIdentifier: "segueInbox", sender: self)
    }
    
    var sectionNumber = 4
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        if articles.count == 0 {
            return 1
        }
        return sectionNumber
    }
    
    var section1Index = [0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56]
    var section2Index = [1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57]
    var section3Index = [2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58]
    var section4Index = [3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if section == 2 || section == 6 || section3Index.contains(section) {
            return radTwo
        }
        if section == 3 || section == 7 || section4Index.contains(section) {
            return 4
        }
        if section == 1 || section == 5 || section2Index.contains(section) {
            return radOne
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
      
        let rowNumber = returnPositionForThisIndexPath(indexPath: indexPath as NSIndexPath, insideThisTable: collectionerView)
   //  print(rowNumber)
      
        let image = UIImage(named: "news")
        
             if  articles.count > 0  {
            if indexPath.section == 0 || indexPath.section == 4 || section1Index.contains(indexPath.section) {
           
            let cell2 = collectionerView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! MainTwoCollectionViewCell
            cell2.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
                if let urli = articles[rowNumber].imageUrl {
                    if urli != "none" {
                        let url = URL(string: urli)
                        cell2.imagerView.kf.setImage(with: url, placeholder: image)
                    } else {
                        cell2.imagerView.image = UIImage(named: "news")
                    }
                } else {
                    cell2.imagerView.image = UIImage(named: "news")
                }
            cell2.titlerLabel.text = articles[rowNumber].titler
                cell2.buttonExternalLink.tag = rowNumber
                cell2.buttonExternalLink.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
            cell2.publisherImageView.image = nil
            if let sharedwithyou = articles[rowNumber].hereOther {
                    if let fromer = articles[rowNumber].hereFrom {
                        if sharedwithyou == "repost" {
                            cell2.labelSharedArticle.text = "\(fromer) reposted this article"
                        }
                        if sharedwithyou == "feedadd" {
                            cell2.labelSharedArticle.text = "\(fromer) added this article to your feed"
                        }
                       
                    } else {
                       if sharedwithyou == "highlighted" {
                            cell2.labelSharedArticle.text = "• Highlighted article"
                       
                        }
                }
            } else {
                cell2.labelSharedArticle.text = ""
                }
                
                if let urlOfPub = articles[rowNumber].publisherUrl {
                    if urlOfPub == "none" {
                         cell2.labelPubli.text = "\n\(articles[rowNumber].publisher!)"
                    } else {
                         cell2.labelPubli.text = ""
                         let url = URL(string: urlOfPub)
                        cell2.publisherImageView.kf.setImage(with: url)
                    }
                }
                
                if let urLikeDislike = articles[rowNumber].personalLikeDis {
                    if urLikeDislike == "Like" {
                        cell2.likeImageView.image = UIImage(named: "blueLike")
                        
                        cell2.dislikeImageView.image = UIImage(named: "down1")
                    }
                    if urLikeDislike == "Dislike" {
                        cell2.dislikeImageView.image = UIImage(named: "blueDis")
                        cell2.likeImageView.image = UIImage(named: "up1")
                        
                    }
                } else {
                    cell2.likeImageView.image = UIImage(named: "up1")
                        cell2.dislikeImageView.image = UIImage(named: "down1")
                }
                
                if let ratio = articles[rowNumber].ratio {
                    cell2.percentLabel.text = "\(ratio)%"
                    if ratio >= 50 {
                    cell2.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
                    } else {
                    cell2.percentLabel.textColor = UIColor(red: 0.7373, green: 0.1961, blue: 0, alpha: 1.0)
                    }
                }
             
            cell2.timeLabel.text = articles[rowNumber].time
            cell2.viewsLabel.text = "\(articles[rowNumber].views!) views"
            cell2.activeNumberLabel.text = "\(articles[rowNumber].active!)"
                
                if let comCount = articles[rowNumber].comCount {
                    if comCount == 1 {
                        cell2.externalImage.image = #imageLiteral(resourceName: "feedChat")
                    } else {
                        cell2.externalImage.image = nil
                    }
                } else {
                    cell2.externalImage.image = nil
                }
          
                if let bias = articles[rowNumber].bias {
                if bias == -2  {
                    cell2.shapeLayer.strokeColor = UIColor.blue.cgColor
                }
                if bias == -1  {
                    cell2.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
                }
                if bias == 0 {
                    cell2.shapeLayer.strokeColor = UIColor.purple.cgColor
                }
                if bias == 1 {
                    cell2.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
                if bias == 2 {
                    cell2.shapeLayer.strokeColor = UIColor.red.cgColor
                }
                }
            return cell2
            }
        }
        if articles.count > 1 {
            if indexPath.section == 1 || indexPath.section == 5 || section2Index.contains(indexPath.section) {
            
            let cell = collectionerView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
            
            
                if let urli = articles[rowNumber].imageUrl {
                    if urli != "none" {
                        let url = URL(string: urli)
                        cell.imagerView.kf.setImage(with: url, placeholder: image)
                    } else {
                        cell.imagerView.image = UIImage(named: "news")
                    }
                } else {
                    cell.imagerView.image = UIImage(named: "news")
                }
            cell.titleLabel.text = articles[rowNumber].titler
           // cell.countActiveLabel.text = "37"
            cell.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
           cell.buttonExternalLink.tag = rowNumber
                cell.buttonExternalLink.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
            cell.publisherImage.image = nil
                
                if let sharedwithyou = articles[rowNumber].hereOther {
                    if let fromer = articles[rowNumber].hereFrom {
                        if sharedwithyou == "repost" {
                          cell.labelSharedArticle.text = "\(fromer) reposted this article"
                        }
                        if sharedwithyou == "feedadd" {
                            cell.labelSharedArticle.text = "\(fromer) added this article to your feed"
                        }
                        
                    } else {
                           if sharedwithyou == "highlighted" {
                                cell.labelSharedArticle.text = "• Highlighted article"
                           
                            }
                    }
                } else {
                    cell.labelSharedArticle.text = ""
                }
            
                if let urlOfPub = articles[rowNumber].publisherUrl {
                    if urlOfPub == "none" {
                        cell.labelPubli.text = "\n\(articles[rowNumber].publisher!)"
                    } else {
                        cell.labelPubli.text = ""
                        let url = URL(string: urlOfPub)
                        cell.publisherImage.kf.setImage(with: url)
                    }
                }
                
            cell.timeLabel.text = articles[rowNumber].time
            cell.viewLabel.text = "\(articles[rowNumber].views!) views"
            cell.countActiveLabel.text = "\(articles[rowNumber].active!)"
                
                if let urLikeDislike = articles[rowNumber].personalLikeDis {
                    if urLikeDislike == "Like" {
                        cell.likeView.image = UIImage(named: "blueLike")
                        
                        cell.dislikeView.image = UIImage(named: "down1")
                    }
                    if urLikeDislike == "Dislike" {
                        cell.dislikeView.image = UIImage(named: "blueDis")
                        cell.likeView.image = UIImage(named: "up1")
                        
                    }
                } else {
                    cell.likeView.image = UIImage(named: "up1")
                    cell.dislikeView.image = UIImage(named: "down1")
                }
                
                if let ratio = articles[rowNumber].ratio {
                    cell.percentLabel.text = "\(ratio)%"
                    if ratio >= 50 {
                        cell.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
                    } else {
                        cell.percentLabel.textColor = UIColor(red: 0.7373, green: 0.1961, blue: 0, alpha: 1.0)
                    }
                }
                
                if let comCount = articles[rowNumber].comCount {
                                   if comCount == 1 {
                                       cell.externalImage.image = #imageLiteral(resourceName: "feedChat")
                                   } else {
                                       cell.externalImage.image = nil
                                   }
                               } else {
                                   cell.externalImage.image = nil
                               }
   
                  if let bias = articles[rowNumber].bias {
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
        }
        if articles.count > 2 {
            if indexPath.section == 2 || indexPath.section == 6 || section3Index.contains(indexPath.section)  {
              
                let cell3 = collectionerView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! MainThreeCollectionViewCell
            cell3.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
        
                if let urli = articles[rowNumber].imageUrl {
                    if urli != "none" {
                        let url = URL(string: urli)
                        cell3.imagerView.kf.setImage(with: url, placeholder: image)
                    } else {
                        cell3.imagerView.image = UIImage(named: "news")
                    }
                } else {
                    cell3.imagerView.image = UIImage(named: "news")
                }
            
            cell3.titlerLabel.text = articles[rowNumber].titler
            cell3.externalButton.tag = rowNumber
            cell3.externalButton.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
            cell3.activeNumberLabel.text = "\(articles[rowNumber].active!)"
            cell3.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
           
            cell3.publisherImageView.image = nil
                if let sharedwithyou = articles[rowNumber].hereOther {
                    if let fromer = articles[rowNumber].hereFrom {
                        if sharedwithyou == "repost" {
                            cell3.labelSharedArticle.text = "\(fromer) reposted this article"
                        }
                        if sharedwithyou == "feedadd" {
                            cell3.labelSharedArticle.text = "\(fromer) added this article to your feed"
                        }
                        
                    } else {
                           if sharedwithyou == "highlighted" {
                                cell3.labelSharedArticle.text = "• Highlighted article"
                      
                            }
                    }
                } else {
                    cell3.labelSharedArticle.text = ""
                }
                if let urlOfPub = articles[rowNumber].publisherUrl {
                    if urlOfPub == "none" {
                        cell3.labelPubli.text = "\n\(articles[rowNumber].publisher!)"
                    } else {
                        cell3.labelPubli.text = ""
                        let url = URL(string: urlOfPub)
                       cell3.publisherImageView.kf.setImage(with: url)
                    }
                }
            cell3.timeLabel.text = articles[rowNumber].time
            cell3.viewLabel.text = "\(articles[rowNumber].views!) views"
                
                if let urLikeDislike = articles[rowNumber].personalLikeDis {
                    if urLikeDislike == "Like" {
                        cell3.likeImageView.image = UIImage(named: "blueLike")
                        
                        cell3.dislikeImageView.image = UIImage(named: "down1")
                    }
                    if urLikeDislike == "Dislike" {
                        cell3.dislikeImageView.image = UIImage(named: "blueDis")
                        cell3.likeImageView.image = UIImage(named: "up1")
                        
                    }
                } else {
                    cell3.likeImageView.image = UIImage(named: "up1")
                        cell3.dislikeImageView.image = UIImage(named: "down1")
                }
                
                if let ratio = articles[rowNumber].ratio {
                    cell3.percentLabel.text = "\(ratio)%"
                    if ratio >= 50 {
                        cell3.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
                    } else {
                        cell3.percentLabel.textColor = UIColor(red: 0.7373, green: 0.1961, blue: 0, alpha: 1.0)
                    }
                }
                
                if let comCount = articles[rowNumber].comCount {
                                   if comCount == 1 {
                                       cell3.externalImage.image = #imageLiteral(resourceName: "feedChat")
                                   } else {
                                       cell3.externalImage.image = nil
                                   }
                               } else {
                                   cell3.externalImage.image = nil
                               }
                
            if let bias = articles[rowNumber].bias {
              if bias == -2  {
                cell3.shapeLayer.strokeColor = UIColor.blue.cgColor
            }
            if bias == -1  {
                cell3.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
            }
             if bias == 0 {
                cell3.shapeLayer.strokeColor = UIColor.purple.cgColor
            }
             if bias == 1 {
                cell3.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
            if bias == 2 {
                cell3.shapeLayer.strokeColor = UIColor.red.cgColor
            }
                }
            return cell3
            }
        }
        if articles.count > 3 {
            if indexPath.section == 3 || indexPath.section == 7 || section4Index.contains(indexPath.section) {
                
                
            let cell4 = collectionerView.dequeueReusableCell(withReuseIdentifier: "cell4", for: indexPath) as! SecondCollectionViewCell
                
             
               
                if let urli = articles[rowNumber].imageUrl {
                    if urli != "none" {
                 let url = URL(string: urli)
                cell4.imagerView.kf.setImage(with: url, placeholder: image)
                    } else {
                    cell4.imagerView.image = UIImage(named: "news")
                    }
                } else {
                    cell4.imagerView.image = UIImage(named: "news")
                }
           cell4.buttonExternalLink.tag = rowNumber
                cell4.buttonExternalLink.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
            cell4.titlerLabel.text = articles[rowNumber].titler
            cell4.timeLabel.text = articles[rowNumber].time
            cell4.activeLabel.text = "\(articles[rowNumber].active!)"
                if let comCount = articles[rowNumber].comCount {
                                   if comCount == 1 {
                                       cell4.externalImage.image = #imageLiteral(resourceName: "feedChat")
                                   } else {
                                       cell4.externalImage.image = nil
                                   }
                               } else {
                                   cell4.externalImage.image = nil
                               }
              if let bias = articles[rowNumber].bias {
                if bias == -2  {
                    cell4.shapeLayer.strokeColor = UIColor.blue.cgColor
                }
                if bias == -1  {
                    cell4.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
                }
                if bias == 0 {
                    cell4.shapeLayer.strokeColor = UIColor.purple.cgColor
                }
                if bias == 1 {
                    cell4.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
                if bias == 2 {
                    cell4.shapeLayer.strokeColor = UIColor.red.cgColor
                }
                }
           
            return cell4
            
            }
        }
        
        if indexPath.section == 0 && articles.count == 0 {
            let cell = collectionerView.dequeueReusableCell(withReuseIdentifier: "noneCell", for: indexPath) as! nothingCell
            return cell
        }
        
        let cell = collectionerView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
       
       return cell
    }
    
    @objc func clickedOnExternalLink (sender: UIButton) {
        if let url = articles[sender.tag].mainUrl {
            if let mySavedDes = UserDefaults.standard.value(forKey: "dataLog") as? Int {
                       if mySavedDes >= 4 {
                        let radOne = Int.random(in: 1..<8)
                        if radOne == 5 || radOne == 4 || radOne == 1 {
                            self.openIt(urli: url)
                        } else {
                            print("noo")
                          //nothing
                        }
                       } else {
                         self.openIt(urli: url)
                }
                }  else {
                self.openIt(urli: url)
                           }
            }
        }
    
    func openIt (urli: String) {
        let url = URL(string: urli)
    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    var oneCalli = false
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
         let rowNumber = returnPositionForThisIndexPath(indexPath: indexPath as NSIndexPath, insideThisTable: collectionerView)
        if articles[rowNumber].mainUrl != "none" {
            if self.oneCalli == false {
                self.oneCalli = true
        self.performSegue(withIdentifier: "seguer", sender: self)
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1.08, execute: {
                    self.oneCalli = false
                })
            }
        }
    
    }
    
     func returnPositionForThisIndexPath(indexPath:NSIndexPath, insideThisTable theTable:UICollectionView)->Int{
        
        var i = 0
        var rowCount = 0
        
        while i < indexPath.section {
            
            rowCount += theTable.numberOfItems(inSection: i)
            i += 1
        }
        
        rowCount += indexPath.row
        
        return rowCount
    }
    
    
  
    override func viewWillDisappear(_ animated: Bool) {
      //  self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backbtn = UIBarButtonItem()
        backbtn.title = ""
        if let indexPaths : NSArray = self.collectionerView.indexPathsForSelectedItems as NSArray? {
            if let selectedrow : IndexPath = indexPaths[0] as? IndexPath {
        let rowNumber = returnPositionForThisIndexPath(indexPath: selectedrow as NSIndexPath, insideThisTable: collectionerView)
            if let cell = collectionerView.cellForItem(at: selectedrow as IndexPath) as? MainCollectionViewCell {
            
            if let imager = cell.imagerView.image {

                if let destination = segue.destination as? SelectedArticleViewController {
                    destination.img = imager
                    destination.delegate = self
                    if let titlerr = cell.titleLabel.text {
                        if let urli = articles[rowNumber].mainUrl {
                        destination.titler = titlerr
                        destination.indexPathi = selectedrow as IndexPath
                        destination.cell = "1"
                        destination.publisher = articles[rowNumber].publisher
                        destination.urlToLoad = urli
                        destination.aid = articles[rowNumber].aid
                            if let urlPub = articles[rowNumber].publisherUrl {
                                if urlPub != "none" {
                                    destination.publisherImageUrl = urlPub
                                }
                            }
                        destination.timer = articles[rowNumber].time
               
                            if let alreadyActiveDone = articles[rowNumber].updatedActiveAleady {
                                destination.activeUpdatedAlready = alreadyActiveDone
                            } else {
                                print("proceed and update active!")
                            }
                            if let allowedToBias = articles[rowNumber].allowedToRateBias {
                                destination.allowedToRateBias = allowedToBias
                            } else {
                                print("cant rate bias unless they alreaduy have")
                            }
                            
                            
                            if let personBias = articles[rowNumber].personalBias {
                                destination.personalBias = personBias
                            }
                            if let personalLikeDis = articles[rowNumber].personalLikeDis {
                                destination.personLikeDis = personalLikeDis
                            }
                        print("segued")
                    }
                    }
                }
            }

        }
            if let cell2 = collectionerView.cellForItem(at: selectedrow) as? MainTwoCollectionViewCell {
            if let imager = cell2.imagerView.image {
                
                if let destination = segue.destination as? SelectedArticleViewController {
                    destination.img = imager
                    destination.delegate = self
                    if let titlerr = cell2.titlerLabel.text {
                           if let urli = articles[rowNumber].mainUrl {
                        destination.titler = titlerr
                            destination.indexPathi = selectedrow as IndexPath
                        destination.cell = "2"
                       
                            destination.urlToLoad = urli
                            destination.publisher = articles[rowNumber].publisher
                            destination.aid = articles[rowNumber].aid
                              destination.timer = articles[rowNumber].time

                            if let personBias = articles[rowNumber].personalBias {
                                destination.personalBias = personBias
                            }
                            if let personalLikeDis = articles[rowNumber].personalLikeDis {
                                destination.personLikeDis = personalLikeDis
                            }
                            if let urlPub = articles[rowNumber].publisherUrl {
                                                        if urlPub != "none" {
                                                            destination.publisherImageUrl = urlPub
                                                        }
                                                    }
                            if let alreadyActiveDone = articles[rowNumber].updatedActiveAleady {
                                destination.activeUpdatedAlready = alreadyActiveDone
                            } else {
                                print("proceed and update active!")
                            }
                            if let allowedToBias = articles[rowNumber].allowedToRateBias {
                                destination.allowedToRateBias = allowedToBias
                            } else {
                                print("cant rate bias unless they alreaduy have")
                            }
                    }
                    }
                }
            }
            }
            
            if let cell3 = collectionerView.cellForItem(at: selectedrow) as? MainThreeCollectionViewCell {
                if let imager = cell3.imagerView.image {
                    
                    if let destination = segue.destination as? SelectedArticleViewController {
                        destination.img = imager
                        destination.delegate = self
                        if let titlerr = cell3.titlerLabel.text {
                            if let urli = articles[rowNumber].mainUrl {
                            destination.titler = titlerr
                            destination.indexPathi = selectedrow as IndexPath
                            destination.cell = "3"
                            destination.publisher = articles[rowNumber].publisher
                            destination.urlToLoad = urli
                                  destination.timer = articles[rowNumber].time
               
                                destination.aid = articles[rowNumber].aid

                                if let personBias = articles[rowNumber].personalBias {
                                    destination.personalBias = personBias
                                }
                                if let personalLikeDis = articles[rowNumber].personalLikeDis {
                                    destination.personLikeDis = personalLikeDis
                                }
                                if let alreadyActiveDone = articles[rowNumber].updatedActiveAleady {
                                    destination.activeUpdatedAlready = alreadyActiveDone
                                } else {
                                    print("proceed and update active!")
                                }
                                if let urlPub = articles[rowNumber].publisherUrl {
                                                            if urlPub != "none" {
                                                                destination.publisherImageUrl = urlPub
                                                            }
                                                        }
                                if let allowedToBias = articles[rowNumber].allowedToRateBias {
                                    destination.allowedToRateBias = allowedToBias
                                } else {
                                    print("cant rate bias unless they alreaduy have")
                                }
                            }
                        }
                    }
                }

            }
        
        if let cell4 = collectionerView.cellForItem(at: selectedrow) as? SecondCollectionViewCell {
            if let imager = cell4.imagerView.image {
                
                if let destination = segue.destination as? SelectedArticleViewController {
                    destination.img = imager
                    destination.delegate = self
                    if let titlerr = cell4.titlerLabel.text {
                        if let urli = articles[rowNumber].mainUrl {
                            destination.titler = titlerr
                            destination.indexPathi = selectedrow as IndexPath
                            destination.publisher = articles[rowNumber].publisher
                            destination.cell = "4"
                            destination.urlToLoad = urli
                             //destination.noID = self.noID
                            destination.aid = articles[rowNumber].aid
                              destination.timer = articles[rowNumber].time

                            if let personBias = articles[rowNumber].personalBias {
                                destination.personalBias = personBias
                            }
                            if let personalLikeDis = articles[rowNumber].personalLikeDis {
                                destination.personLikeDis = personalLikeDis
                            }
                            if let alreadyActiveDone = articles[rowNumber].updatedActiveAleady {
                                destination.activeUpdatedAlready = alreadyActiveDone
                            } else {
                                print("proceed and update active!")
                            }
                            if let urlPub = articles[rowNumber].publisherUrl {
                                                        if urlPub != "none" {
                                                            destination.publisherImageUrl = urlPub
                                                        }
                                                    }
                            if let allowedToBias = articles[rowNumber].allowedToRateBias {
                                destination.allowedToRateBias = allowedToBias
                            } else {
                                print("cant rate bias unless they alreaduy have")
                            }
                        }
                    }
                }
            }
            
        }
        }
        }
        self.navigationItem.backBarButtonItem = backbtn
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
    
    let thumb = CALayer.init()
    let shapeLayer = CAShapeLayer()
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
        
        let layerFrame = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        
        
        
        
        
        shapeLayer.path = CGPath(rect: layerFrame, transform: nil)
        if origColor == false {
           
            thumb.frame = layerFrame
            
            let frame2 = CGRect(x: 0, y: 0, width: 30, height: 30)
            shapeLayer.path = CGPath(rect: frame2, transform: nil)
            shapeLayer.fillColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
            
            shapeLayer.cornerRadius = 15.0
            //shapeLayer.masksToBounds = true
            thumb.addSublayer(shapeLayer)
            
           // thumb.borderColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
           // thumb.borderWidth = 1.0
            thumb.cornerRadius = 15.0
            thumb.masksToBounds = true
            UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
        
        thumb.render(in: UIGraphicsGetCurrentContext()!)
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        slider.setThumbImage(thumbImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .highlighted)
            origColor = true
        }
    }

  
    var scrool:CGFloat = 0;
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        scrool = scrollView.contentOffset.y
        print("\(scrool) scroll y")
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
         
            if self.loadAttempts < 10 && self.onBias == false {
            self.loadMore()
            } else {
                if self.onBias == true && self.loadAttempts < 10 && self.stopSearching == false  {
                    self.loadingMasBasedOnBias(bias: slideBar.value)
                }
            }
        }
    }
    
    
    var changedTo = 20
    var value = Float(0)
   
    
    @objc func Tap () {
        if changedColor == true {
    shapeLayer.fillColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
        //UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
    
    thumb.borderColor = UIColor.lightGray.cgColor
    thumb.borderWidth = 0250
    
    UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
    
    thumb.render(in: UIGraphicsGetCurrentContext()!)
    let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    slideBar.setThumbImage(thumbImage, for: .normal)
    slideBar.setThumbImage(thumbImage, for: .highlighted)
           
            view.addSubview(activity)
            activity.startAnimating()
            self.timesOpperated = 0
          
            self.loadAttempts = 2
            self.sectionNumber = 4
            self.articles.removeAll()
            self.onBias = false
            self.waitCall = false
            self.checlArray.removeAll()
            self.getFeed()
            changedColor = false
           self.collectionerView.isScrollEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.activity.stopAnimating()
                self.activity.removeFromSuperview()
                self.collectionerView.isScrollEnabled = true
            })
        }
        
            
    }
    var currentCol = 0;
    var currentlyLoading = false
    var changedColor = false
    var origColor = false
    @objc func movedSlider () {
       
        if changedColor == false {
            shapeLayer.fillColor =  UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0).cgColor
            
          thumb.borderColor = UIColor.black.cgColor
         thumb.borderWidth = 1.0
            thumb.borderWidth = 1.0
             thumb.cornerRadius = 15.0
            thumb.masksToBounds = true
            
            UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
            
            thumb.render(in: UIGraphicsGetCurrentContext()!)
            let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            slideBar.setThumbImage(thumbImage, for: .normal)
           slideBar.setThumbImage(thumbImage, for: .highlighted)
            changedColor = true
        }
        
        if currentlyLoading == false {
        self.loadBasedOnBias(bias: slideBar.value)
        }
         value = slideBar.value
       
       // collectionerView.isScrollEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
         
           
        })
        
        
    }
    
    func nowAllowBiasVote(index: IndexPath) {
        let rowNumber = returnPositionForThisIndexPath(indexPath: index as NSIndexPath, insideThisTable: collectionerView)
        
        articles[rowNumber].allowedToRateBias = 1
    }
    
    func userAlreadyUpdatedActive(index: IndexPath) {
        //basically each article only needs to have the active updated once, not everytime you click on the article. If the user spam clicks, this is the catch here (;
        let rowNumber = returnPositionForThisIndexPath(indexPath: index as NSIndexPath, insideThisTable: collectionerView)
        
        articles[rowNumber].updatedActiveAleady = 1
       
    }
    
    
    func userDidChangeBias(biasScore: Float, aid: String, index: IndexPath, myId: String, cell: String) {
        
        if articles.count > 0 {
         let rowNumber = returnPositionForThisIndexPath(indexPath: index as NSIndexPath, insideThisTable: collectionerView)
        
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
                                
                               
                              
                                    let inty = roundf(final)
                                    let newInty = Int(inty)
                                
                                 self.articles[rowNumber].bias = newInty
                                self.fixCell(cell: cell, newBias: newInty, index: index)
                                
                                print("\(final) averg")
                            }
                            else {
                                
                                let upRef = Database.database().reference().child("Feed").child(aid)
                                let feedo: [String : Any] = ["bias" : "\(biasScore)"]
                                upRef.updateChildValues(feedo)
                                
                                let inty = roundf(biasScore)
                                let newInty = Int(inty)
                                 self.articles[rowNumber].bias = newInty
                                  self.fixCell(cell: cell, newBias: newInty, index: index)
                                
                            }
                            
                        })
            
        
        articles[rowNumber].personalBias = biasScore
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
        
       
        if cell == "1" {
            
            if let celler = collectionerView.cellForItem(at: index) as? MainCollectionViewCell {
                if type == "Like" {
                    celler.likeView.image = UIImage(named: "blueLike")
                    celler.dislikeView.image = #imageLiteral(resourceName: "down1")
                }
                if type == "Dislike" {
                    celler.likeView.image = #imageLiteral(resourceName: "up1")
                    celler.dislikeView.image = UIImage(named: "blueDis")
                }
                if type == "None" {
                    celler.likeView.image = #imageLiteral(resourceName: "up1")
                    celler.dislikeView.image = #imageLiteral(resourceName: "down1")
                }
               
            }
        }
        if cell == "2" {
            
            if let celler = collectionerView.cellForItem(at: index) as? MainTwoCollectionViewCell {
                if type == "Like" {
                    celler.likeImageView.image = UIImage(named: "blueLike")
                    celler.dislikeImageView.image = #imageLiteral(resourceName: "down1")
                }
                if type == "Dislike" {
                    celler.likeImageView.image = #imageLiteral(resourceName: "up1")
                    celler.dislikeImageView.image = UIImage(named: "blueDis")
                }
                if type == "None" {
                    celler.likeImageView.image = #imageLiteral(resourceName: "up1")
                    celler.dislikeImageView.image = #imageLiteral(resourceName: "down1")
                }
                
            }
        }
        if cell == "3" {
            
            if let celler = collectionerView.cellForItem(at: index) as? MainThreeCollectionViewCell {
                if type == "Like" {
                    celler.likeImageView.image = UIImage(named: "blueLike")
                    celler.dislikeImageView.image = #imageLiteral(resourceName: "down1")
                }
                if type == "Dislike" {
                    celler.likeImageView.image = #imageLiteral(resourceName: "up1")
                    celler.dislikeImageView.image = UIImage(named: "blueDis")
                }
                if type == "None" {
                    celler.likeImageView.image = #imageLiteral(resourceName: "up1")
                    celler.dislikeImageView.image = #imageLiteral(resourceName: "down1")
                }
                
            }
        }
        
      
        
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
        
        var newRatio:Float = 0
        var changedRatio = false
        let upDateRef = Database.database().reference().child("Feed").child(aid)
        let ref = Database.database().reference().child("artItems").child(aid).child("likeArray")
        let refDis = Database.database().reference().child("artItems").child(aid).child("dislikeArray")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let likes = snapshot.value as? [String : AnyObject] {
                refDis.observeSingleEvent(of: .value, with: {(snap) in
                    if let dislikes = snap.value as? [String : AnyObject] {
                        let total:Float = Float(dislikes.count + likes.count)
                        let likesi:Float = Float(likes.count)
                        let ratio:Float = Float(likesi / total)
                        let finalRat:Float = Float(ratio * 100)
                        print("\(ratio) \(finalRat) \(likes.count) updating rat")
                        let feedo: [String : Any] = ["ratio" : "\(finalRat)"]
                        upDateRef.updateChildValues(feedo)
                        newRatio = ratio
                        changedRatio = true
                    } else {
                        let ratio = Float(100)
                        let feedo: [String : Any] = ["ratio" : "\(ratio)"]
                        upDateRef.updateChildValues(feedo)
                        newRatio = ratio
                        changedRatio = true
                    }
                })
            } else {
                let ratio = Float(0)
                newRatio = ratio
                changedRatio = true
                let feedo: [String : Any] = ["ratio" : "\(ratio)"]
                upDateRef.updateChildValues(feedo)
            }
        })
        
        if articles.count > 0 {
        print("type \(type)")
        let rowNumber = returnPositionForThisIndexPath(indexPath: index as NSIndexPath, insideThisTable: collectionerView)
        
        articles[rowNumber].personalLikeDis = type
        if changedRatio == true {
        articles[rowNumber].ratio = Int(newRatio)
        }
        }
    }
    //handle hit link!
    
    
    let activity = UIActivityIndicatorView()
    
    var feedArray = [Article]()
    func loadFromFriends () {
        //load all them into array
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        if let uid = Auth.auth().currentUser?.uid {
            let refer = Database.database().reference().child("users").child(uid).child("Feed")
            refer.observeSingleEvent(of: .value, with: {(snapshotl) in
                if let valrs = snapshotl.value as? [String : AnyObject] {
                      let dispatcherGroup = DispatchGroup()
                    for (_,one) in valrs {
                          dispatcherGroup.enter()
                        if let timeiet = one["timeSent"] as? Int {
                            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                            let timer = timeStamp - timeiet
                            let days = timer / 86400
                            print("\(days) days")
                            if days < 2 {
                                if let aid = one["aid"] as? String {
                                    let econdRef = Database.database().reference().child("Feed").child(aid)
                                    econdRef.observeSingleEvent(of: .value, with: {(shap) in
                                        let valuei = shap.value as? [String : AnyObject]
                                        if let titler = valuei?["title"] as? String, let url = valuei?["url"] as? String, let namert = valuei?["publisher"] as? String, let publishedAt = valuei?["publishedAt"] as? String  {
                                            
                                            let newArt = Article()
                                            newArt.publisher = "---"
                                            //print("\(loop) looooop")
                                            let stringl = namert
                                            let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                                            let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                                            newArt.publisher = last.capitalized
                                            
                                            newArt.publisherUrl = self.publishers(name: last.capitalized)
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                            let newpdate = dateFormatter.date(from: publishedAt)
                                            if let localiDate = newpdate {
                                                let timey = Date().offset(from: localiDate)
                                                print("hired \(timey)")
                                                
                                                newArt.time = timey
                                            } else {
                                                
                                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                                if let leeeps = dateFormatter.date(from: publishedAt) {
                                                    let timey = Date().offset(from: leeeps)
                                                    print("hired \(timey)")
                                                    let newString = timey.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                                                    newArt.time = newString
                                                    
                                                }
                                                
                                            }
                                            newArt.aid = aid
                                            
                                            if let urlImg = valuei?["urlToImage"] as? String {
                                                newArt.imageUrl = urlImg
                                            } else {
                                                newArt.imageUrl = "none"
                                            }
                                            
                                            if let ratio = valuei?["ratio"] as? String {
                                                let intVersion = Float(ratio)
                                                if intVersion == 100.0 {
                                                    newArt.ratio = 99
                                                } else {
                                                    newArt.ratio = Int(intVersion!)
                                                }
                                            } else {
                                                newArt.ratio = 99
                                            }
                                            
                                            let hours = timer / 3600
                                            newArt.hoursFromNow = hours
                                            
                                            if let biasi = valuei?["bias"] as? String {
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
                                            
                                            if let active = valuei?["active"] as? String {
                                                newArt.active = Int(active)
                                            } else {
                                                newArt.active = 0
                                            }
                                            
                                        
                                            if let sentFrom = one["sentFrom"] as? String {
                                                newArt.hereFrom = sentFrom
                                                
                                            }
                                            if let hereFrom = one["typeSent"] as? String {
                                                
                                                newArt.hereOther = "repost"
                                                if hereFrom == "feedadd" {
                                                    newArt.hereOther = "feedadd"
                                                }
                                            } else {
                                                newArt.hereOther = "feedadd"
                                            }
                                            
                                            
                                            
                                            
                                            if likeArraySave.contains(aid) {
                                                newArt.personalLikeDis = "Like"
                                                print("GOT A LIKE")
                                            }
                                            
                                            if dislikeArraySave.contains(aid) {
                                                newArt.personalLikeDis = "Dislike"
                                            }
                                            newArt.mainUrl = url
                                            
                                            
                                            newArt.titler = titler
                                            
                                            if let views = valuei?["views"] as? String {
                                                newArt.views = Int(views)
                                            } else {
                                                newArt.views = 0
                                            }
                                            if let comCount = valuei?["comCount"] as? String {
                                                if comCount == "0" {
                                                    newArt.comCount = 0
                                                } else {
                                                    newArt.comCount = 1
                                                }
                                            } else {
                                            newArt.comCount = 0
                                            }
                                
                                          
                                            if self.checlArray.contains(aid) {
                                                
                                            } else {
                                                self.checlArray.append(aid)
                                            self.feedArray.append(newArt)
                                            }
                                            
                                        }
                                        
                                          dispatcherGroup.leave()
                                    })
                                }
                            } else {
                             if let aid = one["aid"] as? String {
                                let refRemove = Database.database().reference().child("users").child(uid).child("Feed").child(aid)
                                refRemove.removeValue()
                                 dispatcherGroup.leave()
                                }
                            }
                        }
                      
                    }
                       dispatcherGroup.notify(queue: DispatchQueue.main) {
                        print("CALLED GET FEED")
                        self.getFeed()
                        self.waitCallRefresh = false
                        return
                    }
                } else {
                    self.getFeed()
                    self.waitCallRefresh = false
                    return
                }
            })
        } else {
            self.getFeed()
            self.waitCallRefresh = false
            return
        }
    }
    
    
    var checkBeforeReload = false;
    var reloadNowOk = true
    
    var removes = [String]()
    var radOne = Int.random(in: 2..<4)
    var radTwo = Int.random(in: 2..<4)
    var checlArray = [String]()
    func getFeed () {
        print("radone\(radOne)")
        print("radtwo\(radTwo)")
        let defaults = UserDefaults.standard
           let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
         let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        let sequenceCount:Int = radOne + radTwo + 5
        let seeLessArray = defaults.stringArray(forKey: "seeLessArray") ?? [String]()
        var dataLoopSeqCount:Int = radOne + radTwo + 5
        if seeLessArray.count > 0 {
           dataLoopSeqCount+=4
        }
        var maxadd = 1
        if self.feedArray.count > 0 {
            for each in feedArray {
                if maxadd < 4 {
                if each.hoursFromNow < 7 {
                    if self.checkBeforeReload == false {
                   self.articles.append(each)
                    //dataLoopSeqCount-=1 //removed because error encured if new artice was added here
                    maxadd+=1
                    } else {
                        
                        if self.articles.contains(where: { $0.aid == each.aid }) {
                            //already here
                          
                        } else {
                            let obj =  self.articles[articles.count-1].aid
                           
                            self.checlArray = self.checlArray.filter{$0 != obj}
                           self.articles.remove(at: articles.count-1)
                            self.articles.insert(each, at: 0)
                          //  dataLoopSeqCount-=1
                            maxadd+=1
                            self.reloadNowOk = true
                            
                        }
                        
                    }
                   
                }
                }
            }
        }
        let ref = Database.database().reference().child("Feed")
        ref.queryLimited(toLast: UInt(dataLoopSeqCount)).queryOrdered(byChild: "publishedAt").observeSingleEvent(of: .value, with: {(snapshot) in
       
            print("Connection Loading \(dataLoopSeqCount) ")
            if let values = snapshot.value as? [String : AnyObject] {
               
                for (_,each) in values {
                    if let titler = each["title"] as? String, let url = each["url"] as? String, let namert = each["publisher"] as? String, let publishedAt = each["publishedAt"] as? String, let aid = each["aid"] as? String  {
                       
                        if seeLessArray.count > 0 {
                            //remove up to 4
                            if seeLessArray.contains(namert) {
                                if self.removes.count < 4 {
                                self.removes.append(aid)
                                    print("REMOVED ONE")
                                }
                            }
                        }
                        if self.removes.contains(aid) {
                            
                        } else {
                        let newArt = Article()
                        newArt.publisher = "NBC"
                            //print("\(loop) looooop")
                       let stringl = namert
                        let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                        let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                            newArt.publisher = last.capitalized
                            
                            newArt.publisherUrl = self.publishers(name: last.capitalized)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                        let newpdate = dateFormatter.date(from: publishedAt)
                        if let localiDate = newpdate {
                        let timey = Date().offset(from: localiDate)
                            print("hired \(timey)")
                            
                            newArt.time = timey
                        } else {
                            
                          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                            if let leeeps = dateFormatter.date(from: publishedAt) {
                                let timey = Date().offset(from: leeeps)
                               
                                 let newString = timey.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                                newArt.time = newString
                                
                            }
                         
                        }
                        newArt.aid = aid
                        
                        if let urlImg = each["urlToImage"] as? String {
                            newArt.imageUrl = urlImg
                        } else {
                            newArt.imageUrl = "none"
                        }
                        
                        if let ratio = each["ratio"] as? String {
                            let intVersion = Float(ratio)
                            if intVersion == 100.0 {
                                newArt.ratio = 99
                            } else {
                                newArt.ratio = Int(intVersion!)
                            }
                        } else {
                            newArt.ratio = 99
                        }
                        
                        if let biasi = each["bias"] as? String {
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
                          let radney = Int.random(in: 1..<4)
                            if let active = each["active"] as? String {
                                newArt.active = Int(active)
                                 if Int(active) == 0 {
                                    newArt.active = radney
                                }
                            } else {
                                newArt.active = 0
                            }
                            
                           
                        if let views = each["views"] as? String {
                                newArt.views = Int(views)
                            if Int(views) == 0 {
                                newArt.views = radney
                            }
                        } else {
                            newArt.views = 0
                            }
                     
                        if likeArraySave.contains(aid) {
                            newArt.personalLikeDis = "Like"
                            print("GOT A LIKE")
                        }
                       
                        if dislikeArraySave.contains(aid) {
                            newArt.personalLikeDis = "Dislike"
                        }
                            if let comCount = each["comCount"] as? String {
                                if comCount == "0" {
                                    newArt.comCount = 0
                                } else {
                                    newArt.comCount = 1
                                }
                            } else {
                                newArt.comCount = 0
                            }
                            
                        newArt.mainUrl = url
                        
                       // newArt.publisher = "Nyt"
                        newArt.titler = titler
                       
                            if let highlighted = each["highlighted"] as? String {
                                if highlighted == "highlighted" {
                                newArt.hereOther = highlighted
                                }
                            }

                    
                            if self.checlArray.contains(aid) {
                              if let fooOffset = self.articles.firstIndex(where: {$0.aid == aid}) {
                                self.articles[fooOffset].bias = newArt.bias
                                self.articles[fooOffset].time = newArt.time
                                self.articles[fooOffset].views = newArt.views
                                self.articles[fooOffset].ratio = newArt.ratio
                                self.articles[fooOffset].active = newArt.active
                                }
                               // print("NO BC ALREADY HERE \(newArt.titler)")
                                
                            } else {
                                if self.checkBeforeReload == false {
                                        if self.articles.count < sequenceCount {
                            self.articles.append(newArt)
                            self.checlArray.append(newArt.aid)
                                    print("\(self.articles.count) seq \(sequenceCount)")
                                    self.reloadNowOk = true
                                    }
                                } else {
                                    if self.articles.count >= sequenceCount {
                                    let obj =  self.articles[self.articles.count-1].aid
                                    self.checlArray = self.checlArray.filter{$0 != obj}
                                    self.articles.remove(at: self.articles.count-1)
                                    self.articles.insert(newArt, at: 0)
                                    self.checlArray.append(newArt.aid)
                                    self.reloadNowOk = true
                                    }
                                }
                        }
                            }
                        
                        
                    }
                }
                if self.articles.count != 0 {
                    if self.articles.count < sequenceCount {
                        
                        //should not happen but add articles until full again
                        while self.articles.count < sequenceCount {
                            let newArt = Article()
                            newArt.titler = "Failed to load this article"
                            newArt.time = "----"
                            newArt.mainUrl = "none"
                            newArt.imageUrl = "none"
                            newArt.active = 0
                            newArt.aid = "none"
                            newArt.bias = 0
                            newArt.ratio = 99
                            newArt.views = 0
                            newArt.publisher = "nil publisher"
                            newArt.publisherUrl = "none"
                            
                            self.articles.append(newArt)
                        }
                    }
              //  self.articles.sort(by: { $0.arraySpot < $1.arraySpot })
                    if self.reloadNowOk == true {
                DispatchQueue.main.async {
                self.collectionerView.reloadData()
                        }
                        print("&&&&&&& RELOADED &&&&&&&&")
                        print(self.articles.count)
                        if self.checkBeforeReload == true {
                            self.checkBeforeReload = false
                            self.refreshControl.endRefreshing()
                        }
                        let timePud = Int(NSDate().timeIntervalSince1970)
                        self.lastReload = timePud
                    } else {
                        self.checkBeforeReload = false
                        self.refreshControl.endRefreshing()
                        let timePud = Int(NSDate().timeIntervalSince1970)
                        self.lastReload = timePud
                    }
                   
                }
                self.loadingView.removeFromSuperview()
                self.activity.stopAnimating()
                self.activity.removeFromSuperview()
                self.collectionerView.isScrollEnabled = true
                self.collectionerView.allowsSelection = true
            }
            
            }, withCancel: nil)
    }
    var waitCall = false
    var timesOpperated = 0
    var loadAttempts = 2
    func loadMore () {
        
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
          let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        
        let sequenceCount:Int = radOne + radTwo + 5
        let sequenceSort:Int = (sequenceCount) * loadAttempts
        if waitCall == false {
            waitCall = true
       
            
            
            var dataSequenceLoop: Int = (sequenceCount) * loadAttempts
            
             let seeLessArray = defaults.stringArray(forKey: "seeLessArray") ?? [String]()
            if seeLessArray.count > 0 {
              dataSequenceLoop+=5
            }
            
            var maxadd = 1
            if self.feedArray.count > 0 {
                for each in feedArray {
                    if maxadd < 4 {
                        if each.hoursFromNow < (6 * loadAttempts) {
                            if self.articles.contains(where: { $0.aid == each.aid }) {
                                //here already
                                  } else {
                                print("APPENDING!!!!!!!!")
                                self.articles.append(each)
                                dataSequenceLoop-=1
                                maxadd+=1
                                }
                            }
                        
                    }
                }
            }
        var removesCount = 1
        let ref = Database.database().reference().child("Feed")
        ref.queryLimited(toLast: UInt(dataSequenceLoop)).queryOrdered(byChild: "publishedAt").observeSingleEvent(of: .value, with: {(snapshot) in
            if let values = snapshot.value as? [String : AnyObject] {
                
                for (_,each) in values {
                    if let titler = each["title"] as? String, let url = each["url"] as? String, let namert = each["publisher"] as? String, let publishedAt = each["publishedAt"] as? String, let aid = each["aid"] as? String  {
                        
                        if seeLessArray.count > 0 {
                            //remove up to 3
                            
                            if seeLessArray.contains(namert) {
                                if removesCount < 4 {
                                    self.removes.append(aid)
                                    removesCount+=1
                                } else {
                                    print("MORE THAN FOUR")
                                }
                            }
                        }
                      
                        
                        //check if already in array
                        if self.checlArray.contains(aid) || self.removes.contains(aid) {
                            if self.removes.contains(aid) {
                          print("turned down \(namert)")
                            }
                        } else {
                            let newArt = Article()
                            let stringl = namert
                            let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                            let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                            newArt.publisher = last.capitalized
                            
                            newArt.publisherUrl = self.publishers(name: last.capitalized)
                            
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
                            newArt.aid = aid
                            
                        if let urlImg = each["urlToImage"] as? String {
                            newArt.imageUrl = urlImg
                        } else {
                            newArt.imageUrl = "none"
                        }
                            
                         let radney = Int.random(in: 1..<3)
                           
                            if let biasi = each["bias"] as? String {
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
                            
                          
                            if likeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Like"
                            }
                          
                            if dislikeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Dislike"
                            }
                            
                            if let ratio = each["ratio"] as? String {
                                let intVersion = Int(ratio)
                                if intVersion == 100 {
                                    newArt.ratio = 99
                                } else {
                                    newArt.ratio = intVersion
                                }
                            } else {
                                newArt.ratio = 99
                            }
                            
                       
                            if let active = each["active"] as? String {
                                    newArt.active = Int(active)
                                     if Int(active) == 0 {
                                        newArt.active = radney
                                    }
                                } else {
                                    newArt.active = 0
                                }
                               
                            if let views = each["views"] as? String {
                                    newArt.views = Int(views)
                                if Int(views) == 0 {
                                    newArt.views = radney
                                }
                            } else {
                                newArt.views = 0
                                }
                            if let comCount = each["comCount"] as? String {
                                            if comCount == "0" {
                                                newArt.comCount = 0
                                            } else {
                                            newArt.comCount = 1
                                            }
                            } else {
                                newArt.comCount = 0
                            }
                            
                      
                        newArt.mainUrl = url
                        
                        newArt.titler = titler
                       
                        if let highlighted = each["highlighted"] as? String {
                            print(highlighted)
                            if highlighted == "highlighted" {
                                                           newArt.hereOther = highlighted
                                                           }
                        }
                            
                        if self.articles.count < sequenceSort {
                            self.articles.append(newArt)
                            self.checlArray.append(newArt.aid)
                            
                
                        
                            print("\(self.articles.count) seq \(sequenceSort)")
                        }
                        print("appended!")
                    }
                    } else {
                        
                    }
                }
                if self.articles.count != 0 {
                 
                    if self.articles.count < sequenceSort {
                        
                        //should not happen but add articles until full again
                        while self.articles.count < sequenceSort {
                            let newArt = Article()
                            newArt.titler = "Failed to load this article"
                            newArt.time = "----"
                            newArt.mainUrl = "none"
                            newArt.imageUrl = "none"
                            newArt.active = 0
                            newArt.aid = "none"
                            newArt.bias = 0
                            newArt.ratio = 99
                            newArt.views = 0
                            newArt.publisher = "none"
                            newArt.publisherUrl = "none"
                            
                            self.articles.append(newArt)
                        }
                    }
                    self.sectionNumber = self.sectionNumber + 4
                    self.loadAttempts+=1
                    self.waitCall = false
                    if self.loadAttempts <= 10 {
                      
                      DispatchQueue.main.async {
                      self.collectionerView.reloadData()
                    self.collectionerView.performBatchUpdates(nil, completion: nil)
                        }

                    self.collectionerView.allowsSelection = true
                    }
                    print("\(self.sectionNumber) section number \(self.articles.count) tO \(sequenceSort)")
                    print("&&&&&&& RELOADED &&&&&&&&&")
                  
                }
               
            }
        })
        }
        
    }
    
    
    /// bias bar movement
    var currentVote: Float = 8;
    var onBias = false
    func loadBasedOnBias (bias: Float) {
        let biasMi = Float(bias)
      
        if roundf(currentVote) == roundf(biasMi) {
            
        } else {
        print("LOADBASEDONBIAS FUNC CALLED")
       self.activity.startAnimating()
        collectionerView.addSubview(activity)
            self.onBias = true
            self.collectionerView.isScrollEnabled = false
            self.stopSearching = false
            self.sectionNumber = 4
            self.loopNumber = 1
            self.testArray.removeAll()
            self.equalArray.removeAll()
            self.timesOpperated = 0
            self.loadAttempts = 2
            firstGrabBias(bias: bias)
            currentVote = bias
        }
    }
    
    
    var currentLoad = false
    var testArray = [String]()
    var equalArray = [Article]()
    var loopNumber = 1
    func firstGrabBias(bias: Float) {
        if currentLoad == false {
            currentLoad = true
            let defaults = UserDefaults.standard
            let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
             let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        let ref = Database.database().reference().child("Feed")
        let sequenceCount:Int = radOne + radTwo + 5
       let targetNum = self.loopNumber * 20
        ref.queryLimited(toLast: UInt(targetNum)).queryOrdered(byChild: "publishedAt").observeSingleEvent(of: .value, with: {(snapshot) in
            if let values = snapshot.value as? [String : AnyObject] {
                
                for (_,each) in values {
                    if let biasi = each["bias"] as? String {
                        print("atleast here")
                        let biasit = Float(biasi)
                        let biasMi = Float(bias)
                        
                        if roundf(biasit!) == roundf(biasMi) {
                            print("bias equal, orig\(bias)")
                    if let titler = each["title"] as? String, let url = each["url"] as? String, let namert = each["publisher"] as? String, let publishedAt = each["publishedAt"] as? String, let aid = each["aid"] as? String  {
                        if self.testArray.contains(aid) {
                            
                        } else {
                             print("one here")
                            
                            let newArt = Article()
                            newArt.publisher = "NBC"
                            let stringl = namert
                            let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                            let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                            newArt.publisher = last.capitalized
                            
                            newArt.publisherUrl = self.publishers(name: last.capitalized)
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                            let newpdate = dateFormatter.date(from: publishedAt)
                            if let localiDate = newpdate {
                                let timey = Date().offset(from: localiDate)
                                print("hired \(timey)")
                                
                                newArt.time = timey
                            } else {
                                
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                if let leeeps = dateFormatter.date(from: publishedAt) {
                                    let timey = Date().offset(from: leeeps)
                                    print("hired \(timey)")
                                    let newString = timey.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                                    newArt.time = newString
                                    
                                }
                                
                            }
                            
                            if let urlImg = each["urlToImage"] as? String {
                                newArt.imageUrl = urlImg
                            } else {
                                newArt.imageUrl = "none"
                            }
                            
                            if let ratio = each["ratio"] as? String {
                                let intVersion = Int(ratio)
                                if intVersion == 100 {
                                    newArt.ratio = 99
                                } else {
                                    newArt.ratio = intVersion
                                }
                            } else {
                                newArt.ratio = 99
                            }
                            
                            if let biasi = each["bias"] as? String {
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
                            
                            if let comCount = each["comCount"] as? String {
                            if comCount == "0" {
                                    newArt.comCount = 0
                                        } else {
                                    newArt.comCount = 1
                                }
                            } else {
                                newArt.comCount = 0
                               }
                            
                           
                            if likeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Like"
                            }
                           
                            if dislikeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Dislike"
                            }
                            
                            
                             let radney = Int.random(in: 1..<3)
                            if let active = each["active"] as? String {
                                newArt.active = Int(active)
                                       if Int(active) == 0 {
                                                  newArt.active = radney
                                           }
                                              } else {
                                                newArt.active = 0
                                                       }
                                                      
                                        if let views = each["views"] as? String {
                                            newArt.views = Int(views)
                                        if Int(views) == 0 {
                                            newArt.views = radney
                                            }
                                    } else {
                                newArt.views = 0
                            }
                            
                            
                            // let current = self.articles.count + 1
                          
                            
                            // newArt.arraySpot = current
                            
                           
                            newArt.mainUrl = url
                            newArt.aid = aid
                            // newArt.publisher = "Nyt"
                            newArt.titler = titler
                            
                          
                            if self.testArray.count < sequenceCount {
                            self.equalArray.append(newArt)
                            self.testArray.append(aid)
                                                            }
                        }
                        
                       
                    }
                        }
                    }
                }
                if self.testArray.count == sequenceCount {
                    self.articles.removeAll()
                    self.articles = self.equalArray
                   
                      DispatchQueue.main.async {
                    self.collectionerView.reloadData()
                    }
                    self.currentLoad = false
                    print("&&&&&&& RELOADED &&&&&&&&&")
                    
                    self.activity.stopAnimating()
                    self.activity.removeFromSuperview()
                    self.collectionerView.isScrollEnabled = true
                } else {
                    if self.loopNumber <= 8 {
                    self.loopNumber = self.loopNumber + 1
                          self.currentLoad = false
                    self.firstGrabBias(bias: bias)
                      
                    print("not enough, call again")
                    } else {
                        let alert = UIAlertController(title: "No recent articles found.", message: "We have not found any articles from the past 24 hours with the average bias you are looking for. Please note that the bias of an article only changes when users rate it. This means over the last 24 hours, not enough articles have been rated with this average bias to appear.", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                        print("reached limit")
                        self.currentLoad = false
                        self.activity.stopAnimating()
                       self.activity.removeFromSuperview()
                        self.collectionerView.isScrollEnabled = true
                    }
                    
                }
            }
        })
        }
    }

    var stopSearching = false
    func loadingMasBasedOnBias(bias: Float) {
        if currentLoad == false {
            currentLoad = true
            let defaults = UserDefaults.standard
            let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
            let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
            let ref = Database.database().reference().child("Feed")
            let sequenceCount:Int = radOne + radTwo + 5
            let sequenceSort:Int = (sequenceCount) * loadAttempts
            let targetNum = self.loopNumber * 20
            ref.queryLimited(toLast: UInt(targetNum)).queryOrdered(byChild: "publishedAt").observeSingleEvent(of: .value, with: {(snapshot) in
                if let values = snapshot.value as? [String : AnyObject] {
                    
                    for (_,each) in values {
                        if let biasi = each["bias"] as? String {
                          
                            let biasit = Float(biasi)
                            let biasMi = Float(bias)
                            
                            if roundf(biasit!) == roundf(biasMi) {
                                print("bias equal, orig\(bias)")
                                if let titler = each["title"] as? String, let url = each["url"] as? String, let namert = each["publisher"] as? String, let publishedAt = each["publishedAt"] as? String, let aid = each["aid"] as? String  {
                                    if self.testArray.contains(aid) {
                                        
                                    } else {
                                       
                                        
                                        let newArt = Article()
                                        newArt.publisher = " "
                                        let stringl = namert
                                        let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                                        let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                                        newArt.publisher = last.capitalized
                                        
                                        newArt.publisherUrl = self.publishers(name: last.capitalized)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                        let newpdate = dateFormatter.date(from: publishedAt)
                                        if let localiDate = newpdate {
                                            let timey = Date().offset(from: localiDate)
                                            print("hired \(timey)")
                                            
                                            newArt.time = timey
                                        } else {
                                            
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                            if let leeeps = dateFormatter.date(from: publishedAt) {
                                                let timey = Date().offset(from: leeeps)
                                                print("hired \(timey)")
                                                let newString = timey.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                                                newArt.time = newString
                                                
                                            }
                                            
                                        }
                                        
                                        if let urlImg = each["urlToImage"] as? String {
                                            newArt.imageUrl = urlImg
                                        } else {
                                            newArt.imageUrl = "none"
                                        }
                                        
                                        if let ratio = each["ratio"] as? String {
                                            let intVersion = Int(ratio)
                                            if intVersion == 100 {
                                                newArt.ratio = 99
                                            } else {
                                                newArt.ratio = intVersion
                                            }
                                        } else {
                                            newArt.ratio = 99
                                        }
                                        
                                        if let biasi = each["bias"] as? String {
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
                                        
                                        
                                        if likeArraySave.contains(aid) {
                                            newArt.personalLikeDis = "Like"
                                        }
                                        
                                        if dislikeArraySave.contains(aid) {
                                            newArt.personalLikeDis = "Dislike"
                                        }
                                        if let views = each["views"] as? String {
                                            newArt.views = Int(views)
                                        } else {
                                            newArt.views = 0
                                        }
                                        
                                        if let active = each["active"] as? String {
                                            newArt.active = Int(active)
                                        } else {
                                            newArt.active = 0
                                        }
                                        
                                        if let comCount = each["comCount"] as? String {
                                            if comCount == "0" {
                                            newArt.comCount = 0
                                            } else {
                                            newArt.comCount = 1
                                            }
                                        } else {
                                            newArt.comCount = 0
                                        }
                                        
                                        
                                        // let current = self.articles.count + 1
                                      
                                        
                                        newArt.mainUrl = url
                                        newArt.aid = aid
                                        // newArt.publisher = "Nyt"
                                        newArt.titler = titler
                                    
                                        newArt.cellType = 3
                                        if self.testArray.count < sequenceSort  {
                                            self.equalArray.append(newArt)
                                            self.testArray.append(aid)
                                              print("APPENDING BIAS MAS")
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                    if self.testArray.count == sequenceSort && self.loadAttempts < 10  {
                        self.articles.removeAll()
                        self.articles = self.equalArray
                        
                        self.loadAttempts+=1
                         self.sectionNumber = self.sectionNumber + 4
                      
                        self.collectionerView.reloadData()
                        self.collectionerView.performBatchUpdates(nil, completion: nil)
                        self.currentLoad = false
                       print("&&&&&&& RELOADED &&&&&&&&&")
                        print("\(self.sectionNumber) section number \(self.articles.count) \(self.equalArray.count) tO \(sequenceSort)")
                       
                        
                    } else {
                        if self.loopNumber <= 9 {
                            self.loopNumber = self.loopNumber + 1
                            self.currentLoad = false
                            self.loadingMasBasedOnBias(bias: bias)
                            
                            print("not enough, call again")
                        } else {
                            let alert = UIAlertController(title: "No more recent articles found.", message: "We have not found any more recent articles with the average bias you are looking for.", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                            print("reached limit")
                            self.currentLoad = false
                            self.stopSearching = true
                        }
                        
                    }
                }
            })
        }
    }
    let button1 = UIButton()
    let button2 = UIButton()
    func tutorialMode () {
       
        button1.frame = CGRect(x: 15, y: self.view.frame.height - 162, width: self.view.frame.width-30, height: 50)
        button1.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        button1.setTitle("Take Tutorial", for: .normal)
        button1.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
        button1.clipsToBounds = true
        button1.layer.cornerRadius = 18.0
        button1.titleLabel?.textColor = .white
        button1.tag = 0
        button1.addTarget(self, action: #selector(self.takeTutorial(sender:)), for: .touchUpInside)
        button2.frame = CGRect(x: 15, y: self.view.frame.height - 105, width: self.view.frame.width-30, height: 50)
        button2.backgroundColor = .gray
         button2.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        button2.setTitle("Skip Tutorial", for: .normal)
        button2.layer.cornerRadius = 18.0
        button2.clipsToBounds = true
        button2.titleLabel?.textColor = .white
        button2.addTarget(self, action: #selector(self.skipTutorial), for: .touchUpInside)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
            case 2436:
                print("iPhone X, XS")
               button1.frame = CGRect(x: 15, y: self.view.frame.height - 212, width: self.view.frame.width-30, height: 50)
                button2.frame = CGRect(x: 15, y: self.view.frame.height - 155, width: self.view.frame.width-30, height: 50)
            case 2688:
                print("iPhone XS Max")
                button1.frame = CGRect(x: 15, y: self.view.frame.height - 212, width: self.view.frame.width-30, height: 50)
                button2.frame = CGRect(x: 15, y: self.view.frame.height - 155, width: self.view.frame.width-30, height: 50)
            case 1792:
                print("iPhone XR")
                button1.frame = CGRect(x: 15, y: self.view.frame.height - 212, width: self.view.frame.width-30, height: 50)
                button2.frame = CGRect(x: 15, y: self.view.frame.height - 155, width: self.view.frame.width-30, height: 50)
            default:
                print("Unknown")
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            button1.frame = CGRect(x: 15, y: self.view.frame.height - 212, width: self.view.frame.width-30, height: 50)
            button2.frame = CGRect(x: 15, y: self.view.frame.height - 155, width: self.view.frame.width-30, height: 50)
        }
        self.view.addSubview(button2)
        self.view.addSubview(button1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0, execute: {
            
            self.button1.removeFromSuperview()
            self.button2.removeFromSuperview()
        })
        
    }
    
     let imageViewTut = UIImageView()
      let totalView = UIView()
     let nextButton = UIButton()
    @objc func takeTutorial (sender:UIButton) {
       
        self.button1.removeFromSuperview()
        self.button2.removeFromSuperview()
        totalView.backgroundColor = .clear
        
       
    
        
      nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        nextButton.backgroundColor = UIColor(red: 0, green: 0.5294, blue: 1, alpha: 1.0)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 15.0
        nextButton.titleLabel?.textColor = .white
        
        nextButton.addTarget(self, action: #selector(self.takeTutorial(sender:)), for: .touchUpInside)
        
        if sender.tag == 0 {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                     totalView.frame = CGRect(x: 5, y: self.view.frame.height - 300, width: self.view.frame.width - 10, height: 250)
                case 1334:
                    print("iPhone 6/6S/7/8")
                     totalView.frame = CGRect(x: 5, y: self.view.frame.height - 300, width: self.view.frame.width - 10, height: 250)
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    totalView.frame = CGRect(x: 5, y: self.view.frame.height - 310, width: self.view.frame.width - 10, height: 250)
                case 2436:
                    print("iPhone X, XS")
                   totalView.frame = CGRect(x: 5, y: self.view.frame.height - 400, width: self.view.frame.width - 10, height: 250)
                case 2688:
                    print("iPhone XS Max")
                   totalView.frame = CGRect(x: 5, y: self.view.frame.height - 400, width: self.view.frame.width - 10, height: 250)
                case 1792:
                    print("iPhone XR")
                   totalView.frame = CGRect(x: 5, y: self.view.frame.height - 400, width: self.view.frame.width - 10, height: 250)
                default:
                    print("Unknown")
                }
            }
            nextButton.frame = CGRect(x: 15, y: totalView.frame.height - 50, width: self.totalView.frame.width - 30, height: 40)
            nextButton.setTitle("Next", for: .normal)
           
        imageViewTut.frame = CGRect(x: 0, y: 5, width: totalView.frame.width , height: 200)
            imageViewTut.contentMode = .scaleAspectFill
           nextButton.tag = 1
        self.totalView.addSubview(imageViewTut)
            self.totalView.addSubview(nextButton)
            self.view.addSubview(totalView)
            imageViewTut.image = #imageLiteral(resourceName: "zTut2")
            UserDefaults.standard.set("showTutorial", forKey: "showTutorial")
          
        }
        if sender.tag == 2 {
            totalView.removeFromSuperview()
        }
        if sender.tag == 1 {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    totalView.frame = CGRect(x: 5, y: 200, width: self.view.frame.width - 10, height: 250)
                case 1334:
                    print("iPhone 6/6S/7/8")
                     totalView.frame = CGRect(x: 5, y: 200, width: self.view.frame.width - 10, height: 250)
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                      totalView.frame = CGRect(x: 5, y: 210, width: self.view.frame.width - 10, height: 250)
                case 2436:
                    print("iPhone X, XS")
                    totalView.frame = CGRect(x: 5, y: 220, width: self.view.frame.width - 10, height: 250)
                case 2688:
                    print("iPhone XS Max")
                  totalView.frame = CGRect(x: 5, y: 220, width: self.view.frame.width - 10, height: 250)
                case 1792:
                    print("iPhone XR")
                    totalView.frame = CGRect(x: 5, y: 220, width: self.view.frame.width - 10, height: 250)
                default:
                    print("Unknown")
                }
            } 
            
            nextButton.tag = 2
            imageViewTut.image = #imageLiteral(resourceName: "zTut7")
            nextButton.setTitle("Next, select an article.", for: .normal)
            
        }
       
        
    }
    @objc func skipTutorial () {
        button2.removeFromSuperview()
        button1.removeFromSuperview()
    }
    
    
    func doStuff () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid).child("username")
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshit = snapshot.value as? String {
                    UserDefaults.standard.set(snapshit, forKey: "username")
                }
                
            })
            UserDefaults.standard.set("showBrowser", forKey: "showBrowser")
             UserDefaults.standard.set("showPersonalize", forKey: "showPersonalize")
           // self.loadFromFriends()
        }
       
        self.viewR.removeFromSuperview()
        self.noView.removeFromSuperview()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        if UIDevice().userInterfaceIdiom == .phone {
         self.tutorialMode()
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
    
    func fixCell (cell: String, newBias: Int, index: IndexPath) {
        let rowNumber = returnPositionForThisIndexPath(indexPath: index as NSIndexPath, insideThisTable: collectionerView)
        
        if cell == "1" {
            
            if let celler = collectionerView.cellForItem(at: index) as? MainCollectionViewCell {
                if let bias = articles[rowNumber].bias {
                    if bias == -2  {
                        celler.shapeLayer.strokeColor = UIColor.blue.cgColor
                    }
                    if bias == -1  {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
                    }
                    if bias == 0 {
                        celler.shapeLayer.strokeColor = UIColor.purple.cgColor
                    }
                    if bias == 1 {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
                    if bias == 2 {
                        celler.shapeLayer.strokeColor = UIColor.red.cgColor
                    }
                }
                
            }
        }
        if cell == "2" {
            
            if let celler = collectionerView.cellForItem(at: index) as? MainTwoCollectionViewCell {
                if let bias = articles[rowNumber].bias {
                    if bias == -2  {
                        celler.shapeLayer.strokeColor = UIColor.blue.cgColor
                    }
                    if bias == -1  {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
                    }
                    if bias == 0 {
                        celler.shapeLayer.strokeColor = UIColor.purple.cgColor
                    }
                    if bias == 1 {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
                    if bias == 2 {
                        celler.shapeLayer.strokeColor = UIColor.red.cgColor
                    }
                }
                
            }
        }
        if cell == "3" {
            
            if let celler = collectionerView.cellForItem(at: index) as? MainThreeCollectionViewCell {
                if let bias = articles[rowNumber].bias {
                    if bias == -2  {
                        celler.shapeLayer.strokeColor = UIColor.blue.cgColor
                    }
                    if bias == -1  {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
                    }
                    if bias == 0 {
                        celler.shapeLayer.strokeColor = UIColor.purple.cgColor
                    }
                    if bias == 1 {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
                    if bias == 2 {
                        celler.shapeLayer.strokeColor = UIColor.red.cgColor
                    }
                }
                
            }
        }
        if cell == "4" {
            
            if let celler = collectionerView.cellForItem(at: index) as? SecondCollectionViewCell {
                if let bias = articles[rowNumber].bias {
                    if bias == -2  {
                        celler.shapeLayer.strokeColor = UIColor.blue.cgColor
                    }
                    if bias == -1  {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.2824, green: 0, blue: 0.7098, alpha: 1.0).cgColor
                    }
                    if bias == 0 {
                        celler.shapeLayer.strokeColor = UIColor.purple.cgColor
                    }
                    if bias == 1 {
                        celler.shapeLayer.strokeColor = UIColor(red: 0.7765, green: 0, blue: 0.4157, alpha: 1.0) .cgColor           }
                    if bias == 2 {
                        celler.shapeLayer.strokeColor = UIColor.red.cgColor
                    }
                }
                
            }
        }
        
    }
    

}


extension UIImageView {
    func downloadImageFrom(link: String) {
        URLSession.shared.dataTask(with: URL(string: link)!) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.image = UIImage(data: data)
            }
            }.resume()
    }
}




class nothingCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


class largeCell: UITableViewCell {
    
    let mainImageView = UIImageView()
    let publisherImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 1 { return "\(weeks(from: date)) weeks ago"   }
        if weeks(from: date)   == 1 { return "\(weeks(from: date)) week ago"   }
        if days(from: date)    > 1 { return "\(days(from: date)) days ago"    }
        if days(from: date)    == 1 { return "\(days(from: date)) day ago"    }
        if hours(from: date)   > 1 { return "\(hours(from: date)) hrs ago"   }
        if hours(from: date)   == 1 { return "\(hours(from: date)) hour ago"   }
        if minutes(from: date) > 1 { return "\(minutes(from: date)) mins ago" }
        if minutes(from: date) == 1 { return "\(minutes(from: date)) min ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds ago" }
        return "\(hours(from: date)) hours ago"
    }
}


class headerView:  UICollectionReusableView {
    
}
class headerGone:  UICollectionReusableView {
    
}


extension UIColor {
    
    static var systemBlue: UIColor {
        return UIButton(type: .system).tintColor
    }
    
}
