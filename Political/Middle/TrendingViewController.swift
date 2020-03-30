//
//  TrendingViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 10/5/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class TrendingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, changedValues {
    
     var refreshControl = UIRefreshControl()
    
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
        
        self.stuff[index.section].personalLikeDis = type
        
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
    

   // var myId: String?
    let activity = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

       self.tabBarController?.tabBar.items?[2].badgeValue = nil
        tablerView.delegate = self
        tablerView.dataSource = self
        tablerView.frame = CGRect(x: 0, y: 24, width: self.view.frame.width, height: self.view.frame.height - 67)
        refreshControl.tintColor = UIColor(red: 0.8196, green: 0, blue: 0.3804, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tablerView.addSubview(refreshControl)
        respondView.frame = CGRect(x: 15, y: self.view.frame.height, width: self.view.frame.width - 30, height: 0)
        self.view.addSubview(respondView)
        activity.frame = CGRect(x: 0, y: 160, width: self.view.frame.width, height: view.frame.height - 150)
        activity.backgroundColor = .black
        activity.color = .white
        
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
                tablerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 97)
                
            case 2688:
                print("iPhone XS Max")
                tablerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 97)
            case 1792:
                print("iPhone XR")
                tablerView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 97)
            default:
                print("Unknown")
            }
        }
        self.view.addSubview(activity)
        activity.startAnimating()
        
        self.loadYourStuff()
     
        // Do any additional setup after loading the view.
    }
    var currentlyCalled = true
  @objc func refresh(sender:AnyObject) {
    if self.currentlyCalled == true {
        if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isAnonymous == false  {
        self.reloadRefresh = true
        self.currentlyCalled = false
        self.loadYourStuff()
        } else {
            self.currentlyCalled = true
            self.refreshControl.endRefreshing()
        }
    }
    }
    
    
    
    var stuff = [MessageInbox]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if stuff.count == 0 {
        return 1
        }
        return stuff.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if stuff.count > 0 {
        if let sthings = stuff[indexPath.section].type {
            if sthings == "message" {
                return 80
            } else {
                if stuff[indexPath.section].caption != nil {
                    return 160
                }
                return 170
            }
        }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
        let viewy = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        let colorfulView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        let politc = UILabel()
        colorfulView.backgroundColor = UIColor(red: 0, green: 0.1059, blue: 0.2667, alpha: 1.0)
        politc.textAlignment = .left
        politc.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        politc.frame = CGRect(x: 15, y: 20, width: view.frame.width - 30, height: 46)
        politc.text = "Inbox"
        politc.textColor = .red
        let sublabel = UILabel(frame: CGRect(x: 20, y: 68, width: self.view.frame.width - 30, height: 30))
        sublabel.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        sublabel.textColor = .white
        sublabel.text = "Stay updated here"
        sublabel.textAlignment = .left
        
        let lineview = UIView()
        lineview.backgroundColor = .white
        lineview.frame = CGRect(x: 15, y: 72, width: self.view.frame.width - 100, height: 5)
        
            viewy.addSubview(colorfulView)
        viewy.addSubview(politc)
        //view.addSubview(lineview)
        viewy.addSubview(sublabel)
            if stuff.count > 0 {
            if let type = stuff[section].type {
                if type == "message" {
                    
                } else {
                  
                    let subview = UIView(frame: CGRect(x: 0, y: viewy.frame.height+10, width: viewy.frame.width, height: 30))
                    subview.backgroundColor = .clear
                        //UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                    viewy.addSubview(subview)
                    let labelt = UILabel(frame: CGRect(x: 15, y: viewy.frame.height+10, width: 350, height: 30))
                    labelt.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
                    labelt.textColor = .white
                        //UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
                    labelt.text = "\(stuff[section].senderName!) sent you this article!"
                    viewy.addSubview(labelt)
                
                 
                    
                }
            }
            }
        return viewy
        }
        
        if let type = stuff[section].type {
            if type == "message" {
                //message

            } else {
                //article
                let viewi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
                viewi.backgroundColor = .clear
                    //UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                let labelt = UILabel(frame: CGRect(x: 15, y: 0, width: 350, height: 30))
                labelt.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
                labelt.textColor = .white
                    //UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
                labelt.text = "\(stuff[section].senderName!) sent you this article!"
                viewi.addSubview(labelt)
              
                return viewi
            }
        }
        
         let viewi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        return viewi
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if stuff.count > 0 {
            if let type = stuff[section].type {
                if type == "art" {
                    return 150
                }
                
            }
            }
        return 120
                
        } else if let type = stuff[section].type {
            if type == "message" {
                return 0
            } else {
                return 25
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if stuff.count > 0 {
        if let type = stuff[indexPath.section].type {
            if type == "message" {
                let cell = tablerView.dequeueReusableCell(withIdentifier: "cellMessageInbox", for: indexPath) as! cellMessage
                cell.labelMain.text = stuff[indexPath.section].message
                if let react = self.stuff[indexPath.section].reaction {
                    if react == 1 {
                        cell.imageViewReact.image = #imageLiteral(resourceName: "faceLike")
                    }
                    if react == 2 {
                         cell.imageViewReact.image = #imageLiteral(resourceName: "faceLol")
                    }
                    if react == 4 {
                         cell.imageViewReact.image = #imageLiteral(resourceName: "faceAngry")
                    }
                    if react == 3 {
                         cell.imageViewReact.image = #imageLiteral(resourceName: "faceNeutral")
                    }
                } else {
                    cell.imageViewReact.image = nil
                }
                if self.stuff[indexPath.section].unseen != nil {
                    cell.imageViewCircleUnseen.image = #imageLiteral(resourceName: "circle")
                } else {
                    cell.imageViewCircleUnseen.image = nil
                }
                return cell
            } else {
            
                let cell = tablerView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! TrendingTableViewCell
                cell.buttonExternalLink.tag = indexPath.section
                cell.buttonExternalLink.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
                let image2 = UIImage(named: "news")
                cell.titleLabel.text = stuff[indexPath.section].titler
                cell.timeLabel.text = stuff[indexPath.section].time
                cell.labelPubli.text = stuff[indexPath.section].publisher
                if let urli = stuff[indexPath.section].imageUrl {
                    if urli != "none" {
                        let url = URL(string: urli)
                        cell.imagerView.kf.setImage(with: url, placeholder: image2)
                    } else {
                        cell.imagerView.image = UIImage(named: "news")
                    }
                } else {
                    cell.imagerView.image = UIImage(named: "news")
                }
                if self.stuff[indexPath.section].unseen != nil {
                    cell.imageViewCircleUnseen.image = #imageLiteral(resourceName: "circle")
                } else {
                    cell.imageViewCircleUnseen.image = nil
                }
                if let bias = stuff[indexPath.section].bias {
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
        }
        
         let cell = tablerView.dequeueReusableCell(withIdentifier: "emptyCepp", for: indexPath) as! emptyCepp
        return cell
        
    }
    let respondView = UIView()
    var respondViewOpen = false
     let cancelButton = UIButton()
    @objc func clickedOnExternalLink (sender: UIButton) {
           if let url = stuff[sender.tag].mainUrl {
            if let fromThemId = stuff[sender.tag].senderId {
                if let aid = stuff[sender.tag].aid {
             self.reactUrl = url
                    self.reactAid = aid
                    self.reactId = fromThemId
                    self.reactPub = stuff[sender.tag].publisher
            
            if self.respondViewOpen == false {
                self.respondViewOpen = true
                self.respondView.layer.cornerRadius = 8.0
               
                cancelButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
                cancelButton.addTarget(self, action: #selector(self.cancelAct), for: .touchUpInside)
                cancelButton.setTitle("Cancel", for: .normal)
                cancelButton.layer.cornerRadius = 12.0
                cancelButton.clipsToBounds = true
                self.view.addSubview(cancelButton)
                respondView.backgroundColor = #colorLiteral(red: 0.05993906409, green: 0.0599572584, blue: 0.059936665, alpha: 0.8348646567)
               let imageView1 = UIImageView()
                imageView1.frame = CGRect(x: respondView.center.x - 155, y: 5, width: 48, height: 48)
                imageView1.image = #imageLiteral(resourceName: "faceLike")
                respondView.addSubview(imageView1)
                let button1 = UIButton()
                button1.frame = imageView1.frame
                button1.setTitle("", for: .normal)
                button1.tag = 1
                respondView.addSubview(button1)
                let imageView2 = UIImageView()
                imageView2.frame = CGRect(x: respondView.center.x - 100, y: 5, width: 45, height: 45)
                imageView2.image = #imageLiteral(resourceName: "faceLol")
                respondView.addSubview(imageView2)
                let button2 = UIButton()
                               button2.frame = imageView2.frame
                               button2.setTitle("", for: .normal)
                               button2.tag = 2
                               respondView.addSubview(button2)
                let imageView3 = UIImageView()
                imageView3.frame = CGRect(x: respondView.center.x+10, y: 5, width: 45, height: 45)
                imageView3.image = #imageLiteral(resourceName: "faceNeutral")
                respondView.addSubview(imageView3)
                let button3 = UIButton()
                               button3.frame = imageView3.frame
                               button3.setTitle("", for: .normal)
                               button3.tag = 3
                               respondView.addSubview(button3)
                let imageView4 = UIImageView()
                imageView4.frame = CGRect(x: respondView.center.x - 46, y: 1, width: 52, height: 52)
                imageView4.image = #imageLiteral(resourceName: "faceAngry")
                respondView.addSubview(imageView4)
                let button4 = UIButton()
                               button4.frame = imageView4.frame
                               button4.setTitle("", for: .normal)
                               button4.tag = 4
                               respondView.addSubview(button4)
                
                button1.addTarget(self, action: #selector(self.SendMessageReact(sender:)), for: .touchUpInside)
                 button2.addTarget(self, action: #selector(self.SendMessageReact(sender:)), for: .touchUpInside)
                 button3.addTarget(self, action: #selector(self.SendMessageReact(sender:)), for: .touchUpInside)
                 button4.addTarget(self, action: #selector(self.SendMessageReact(sender:)), for: .touchUpInside)
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                    self.respondView.frame = CGRect(x: 50, y: self.view.frame.height / 1.3, width: self.view.frame.width - 100, height: 58)
                    self.cancelButton.frame = CGRect(x: self.respondView.frame.midX - 50, y: self.respondView.frame.midY + 35, width: 100, height: 28)
                        //self.respondView.backgroundColor = .white
                }, completion: nil)
            }
           }
            }
        }
    }
    var titleOfAnimate = "Sent!"
        let labelShow = UILabel()
        let overView = UIView()
       func animateRepost () {
          
           overView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: 0)
          
           labelShow.text = titleOfAnimate
           labelShow.textAlignment = .center
           labelShow.frame = CGRect(x: 20, y: 10, width: overView.frame.width - 40, height: 30)
           labelShow.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
           labelShow.textColor = .white
           overView.backgroundColor = UIColor(red: 0.349, green: 0, blue: 0.1216, alpha: 1.0)
           overView.layer.cornerRadius = 20.0
           overView.clipsToBounds = true
           self.view.addSubview(overView)
           overView.addSubview(labelShow)
           UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
              self.overView.frame = CGRect(x: 20, y: self.view.frame.height - 180, width: self.view.frame.width - 40, height: 55)
               
           }, completion: { finished in
               self.closeAnimateRepost()
           })
       }
       
       func closeAnimateRepost () {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
               self.overView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.overView.frame.width - 40, height: 0)
               self.overView.removeFromSuperview()
               self.labelShow.removeFromSuperview()
           })
       }
    
    var sentAlreadys = [""]
    var reactUrl = ""
    var reactId = ""
    var reactAid = ""
    var reactPub = ""
    @objc func SendMessageReact (sender:UIButton) {
        if self.reactUrl != "" && self.reactId != "" && self.reactAid != "" && reactPub != "" {
            if self.sentAlreadys.contains(reactAid) {
                
            } else {
             let theirUid = self.reactId
                               let refUse = Database.database().reference()
                               let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                                let time = Int(NSDate().timeIntervalSince1970)
                               let ref3 = Database.database().reference()
                               if let myId = Auth.auth().currentUser?.uid  {
                                if let myName = Auth.auth().currentUser?.displayName {
                                    let setip = ["notification" : "\(myName) reacted \n to the article you sent!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "key" : key!, "publisher" : reactPub, "aid" : reactAid, "url" : reactUrl, "unseen" : "unseen", "react" : "\(sender.tag)"] as [String : Any]
                                       
                                       let final = [key : setip]
                                       ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                                    self.sentAlreadys.append(reactAid)
                                    self.sendNotifNow()
                                    self.animateRepost()
                                    
                               }
            }
            }
        
    }
    }
    func sendNotifNow () {
         let theirId = self.reactId
        let ref = Database.database().reference().child("users").child(theirId).child("userKey")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let userkey = snapshot.value as? String {
                if let myNme = Auth.auth().currentUser?.displayName {
                let messgae = "\(myNme) reacted to the article you sent!"
                print("sending notif")
                let data = [
                    "contents": ["en": "\(messgae)"],
                    "include_player_ids":["\(userkey)"],
                    "ios_badgeType": "Increase",
                    "ios_badgeCount": 1
                    ] as [String : Any]
                OneSignal.postNotification(data)
                }
            }
            self.cancelAct()
            
        })
        
    }
    
    @objc func cancelAct () {
        self.respondView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        self.cancelButton.removeFromSuperview()
        self.respondViewOpen = false
        self.respondView.subviews.forEach({ $0.removeFromSuperview() })
        self.reactAid = ""
        self.reactId = ""
        self.reactUrl = ""
        self.reactPub = ""
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.stuff.count > 0 {
            if self.stuff[section].caption == nil {
               return 0
            }
        }
        tableView.estimatedSectionFooterHeight = 36;
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if stuff.count > 0 {
        if let cption = stuff[section].caption {
        let label: UILabel = {
            let lb = UILabel()
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.text = cption
            lb.backgroundColor = .clear
            
            lb.font =  UIFont(name: "HelveticaNeue-Medium", size: 16)
            lb.textColor = UIColor(red: 0, green: 0.5294, blue: 1, alpha: 1.0)
            lb.numberOfLines = 0
            return lb
        }()
        
        let header: UIView = {
            let hd = UIView()
            hd.backgroundColor = .clear
            hd.addSubview(label)
            label.leadingAnchor.constraint(equalTo: hd.leadingAnchor, constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: hd.topAnchor, constant: 0).isActive = true
            label.trailingAnchor.constraint(equalTo: hd.trailingAnchor, constant: -10).isActive = true
            label.bottomAnchor.constraint(equalTo: hd.bottomAnchor, constant: -8).isActive = true
            return hd
        }()
        return header
        }
        }
        let viewr = UIView()
        return viewr
    }
    var working = false
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
            if scrollView == tablerView {
                if self.loadAttempts < 10 {
                    if self.working == false {
                      //  self.loadingMore = true
                        self.loadYourStuff()
                    }
                }
            }
        }
    }
     let emblem = UIImageView()
 let subLabel = UILabel()
    var reloadRefresh = false
    var loadAttempts = 1;
    func loadYourStuff() {
        var addedOneReload = false
        self.working = true
        var searchInt = loadAttempts*6
        if self.reloadRefresh == true {
            searchInt = 6
        }
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
         if Auth.auth().currentUser?.isAnonymous == false {
        if let uid = Auth.auth().currentUser?.uid {
           
            let ref = Database.database().reference().child("users").child(uid).child("inbox")
            ref.queryLimited(toLast: UInt(searchInt)).queryOrdered(byChild: "timeSent").observeSingleEvent(of: .value, with: { (snapshoti) in
                if let reposts = snapshoti.value as? [String : AnyObject] {
                    let dispatcherGroup = DispatchGroup()
                    for (_,lip) in reposts {
                        dispatcherGroup.enter()
                        if let aidi = lip["aid"] as? String, let sentBy = lip["sentFrom"] as? String, let timeSent = lip["timeSent"] as? Int, let idSender = lip["sentBy"] as? String {
                            let ref2 = Database.database().reference().child("Feed").child(aidi)
                            ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                                let titlr = snapshot.value as? [String : AnyObject]
                                
                                
                                if let titler = titlr?["title"] as? String, let url = titlr?["url"] as? String, let namert = titlr?["publisher"] as? String, let publishedAt = titlr?["publishedAt"] as? String {
                                    let newArt = MessageInbox()
                                    let stringl = namert
                                    let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                                    let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                                    newArt.publisher = last.capitalized
                                    newArt.senderId = idSender
                                    newArt.senderName = sentBy
                                    newArt.type = "art"
                                    newArt.key = aidi
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
                                    
                                    if likeArraySave.contains(aidi) {
                                        newArt.personalLikeDis = "Like"
                                        print("GOT A LIKE")
                                    }
                                    
                                    if dislikeArraySave.contains(aidi) {
                                        newArt.personalLikeDis = "Dislike"
                                    }
                                    
                                    if let unseen = lip["unseen"] as? String {
                                        newArt.unseen = unseen
                                    } else {
                                        
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
                                    
                                    if let urlImg = titlr?["urlToImage"] as? String {
                                        newArt.imageUrl = urlImg
                                    } else {
                                        newArt.imageUrl = "none"
                                    }
                                    if let caption = lip["caption"] as? String {
                                        newArt.caption = caption
                                    }
                                    newArt.timeSent = timeSent
                                    newArt.aid = aidi
                                    newArt.titler = titler
                                    newArt.mainUrl = url
                                    if self.stuff.contains( where: { $0.mainUrl == newArt.mainUrl } ) {
                                        print("no")
                                    } else {
                                        if self.stuff.count < searchInt {
                                            if self.reloadRefresh == false {
                                            self.stuff.append(newArt)
                                            } else {
                                                self.stuff.insert(newArt, at: 0)
                                            }
                                           addedOneReload = true
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                dispatcherGroup.leave()
                            })
                            
                        }
                        else {
                            if let notification = lip["notification"] as? String, let sentBy = lip["receivedFrom"] as? String, let timeSent = lip["timeSent"] as? Int, let nameSender = lip["sentFrom"] as? String, let key = lip["key"] as? String {
                                  let newArt = MessageInbox()
                                newArt.timeSent = timeSent
                                newArt.message = notification
                                newArt.senderId = sentBy
                                newArt.senderName = nameSender
                                newArt.key = key
                                if let aid = lip["aid"] as? String, let mainUrl = lip["url"] as? String {
                                    newArt.aid = aid
                                    newArt.mainUrl = mainUrl
                                }
                                if let unseen = lip["unseen"] as? String {
                                    newArt.unseen = unseen
                                }
                                if let reaction = lip["react"] as? String {
                                    newArt.reaction = Int(reaction)
                                }
                                if let publi = lip["publisher"] as? String {
                                    newArt.publisher = publi
                                }
                                print("HEREPT")
                                newArt.type = "message"
                                if self.stuff.contains( where: { $0.key == newArt.key } ) {
                                    print("no")
                                } else {
                                    if self.stuff.count < searchInt {
                                        
                                        if self.reloadRefresh == false {
                                            self.stuff.append(newArt)
                                        } else {
                                            self.stuff.insert(newArt, at: 0)
                                        }
                                        addedOneReload = true
                                    }
                                    
                                }
                            }
                            dispatcherGroup.leave()
                        }
                       
                        
                        
                    }
                    
                    // self.activityIndc.stopAnimating()
                    
                    dispatcherGroup.notify(queue: DispatchQueue.main) {
                      
                        if addedOneReload == true {
                        
                        self.tablerView.reloadData()
                        self.activity.stopAnimating()
                         
                                print("reled")
                        self.loadAttempts+=1
                            
                            self.subLabel.removeFromSuperview()
                            self.emblem.removeFromSuperview()
                            
                        self.refreshControl.endRefreshing()
                            self.working = false
                        } else {
                        self.refreshControl.endRefreshing()
                            self.working = false
                        }
                           self.reloadRefresh = false
                    }
                    
                  
                } else {
                    self.refreshControl.endRefreshing()
                    self.activity.stopAnimating()
                    self.working = false
                    
                        self.emblem.frame = CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 3, width: 60, height: 60)
                        self.emblem.image = UIImage(named: "news")
                        
                        self.subLabel.frame = CGRect(x: 20, y: self.view.frame.height / 3 + 70, width: self.view.frame.width - 40, height: 100)
                        self.subLabel.text = "This is your inbox, you have no messages yet."
                        self.subLabel.textAlignment = .center
                        self.subLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
                        
                        self.subLabel.numberOfLines = 3
                        self.subLabel.textColor =  UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
                        self.tablerView.addSubview(self.emblem)
                        self.tablerView.addSubview(self.subLabel)
                    
                }
               
                
            }, withCancel: nil)
            }
            self.currentlyCalled = true
           
        } else {
           
            emblem.frame = CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 3, width: 60, height: 60)
            emblem.image = UIImage(named: "news")
           
            subLabel.frame = CGRect(x: 20, y: self.view.frame.height / 3 + 70, width: self.view.frame.width - 40, height: 100)
            subLabel.text = "This is your inbox, sign in or create an account to recieve updates and articles from friends!"
            subLabel.textAlignment = .center
            subLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            
            subLabel.numberOfLines = 3
            subLabel.textColor =  UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
            self.tablerView.addSubview(emblem)
            self.tablerView.addSubview(subLabel)
            self.working = false
            self.activity.stopAnimating()
        }
    
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            if let theDeleteOne = self.stuff[indexPath.section].key {
                if let uid = Auth.auth().currentUser?.uid {
                    if Auth.auth().currentUser?.isAnonymous == false {
                        let ref = Database.database().reference().child("users").child(uid).child("inbox").child(theDeleteOne)
                        ref.removeValue()
                        self.stuff.remove(at: indexPath.section)
                        self.tablerView.reloadData()
                        return
                    }
                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tablerView: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
            navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tablerView.cellForRow(at: indexPath) as? TrendingTableViewCell {
            if cell.imageViewCircleUnseen.image != nil {
            cell.imageViewCircleUnseen.image = nil
                if let uid = Auth.auth().currentUser?.uid {
                    if let key = stuff[indexPath.section].aid {
                let ref = Database.database().reference().child("users").child(uid).child("inbox").child(key).child("unseen")
                        ref.removeValue()
                self.stuff[indexPath.section].unseen = nil
                    
                }
                }
            }
        }
        if let cell2 = tablerView.cellForRow(at: indexPath) as? cellMessage {
            if cell2.imageViewCircleUnseen.image != nil {
                cell2.imageViewCircleUnseen.image = nil
                if let uid = Auth.auth().currentUser?.uid {
                    if let key = stuff[indexPath.section].key {
                        let ref = Database.database().reference().child("users").child(uid).child("inbox").child(key).child("unseen")
                        ref.removeValue()
                        self.stuff[indexPath.section].unseen = nil
                        
                    }
                }
            }
        }
        if self.stuff[indexPath.section].mainUrl != "following" {
        self.performSegue(withIdentifier: "segueSelectedTrending", sender: self)
        } else {
            if self.stuff.count > 0 {
            if self.stuff[indexPath.section].senderId != Auth.auth().currentUser?.uid {
                let vx: UserViewController? = UserViewController()
                let aObjNavi = UINavigationController(rootViewController: vx!)
                DispatchQueue.main.async {
                    aObjNavi.modalPresentationStyle = .fullScreen
                    vx!.namer = self.stuff[indexPath.section].senderName
                    vx!.theirUid = self.stuff[indexPath.section].senderId
                    vx!.username = self.stuff[indexPath.section].senderName
                    self.present(aObjNavi, animated: true, completion: nil)
                    
                }
            }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRow = tablerView.indexPathForSelectedRow {
        if let destination = segue.destination as? SelectedArticleViewController {
            if let urli = stuff[selectedRow.section].mainUrl {
                
                if let celli = tablerView.cellForRow(at: selectedRow) as? TrendingTableViewCell {
                    if let imager = celli.imagerView.image {
                        destination.img = imager
                    }
                }
                
               destination.delegate = self
                destination.indexPathi = selectedRow as IndexPath
              //  destination.useID = self.myId
                if let personalLikeDis = self.stuff[selectedRow.section].personalLikeDis {
                    destination.personLikeDis = personalLikeDis
                }
                
                destination.timer = self.stuff[selectedRow.section].time
                  destination.titler = self.stuff[selectedRow.section].titler
                destination.cell = "1"
                destination.publisher = stuff[selectedRow.section].publisher
                destination.urlToLoad = urli
                destination.aid = stuff[selectedRow.section].aid
                print("helpre")
            }
            }
        }
    }
    
  
    func userDidChangeBias(biasScore: Float, aid: String, index: IndexPath, myId: String, cell: String) {

        if stuff.count > 0 {
          
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
                    self.stuff[index.section].bias = newInty
                 
                }
                else {
                    
                    let upRef = Database.database().reference().child("Feed").child(aid)
                    let feedo: [String : Any] = ["bias" : "\(biasScore)"]
                    upRef.updateChildValues(feedo)
                    let inty = roundf(biasScore)
                    let newInty = Int(inty)
                      self.stuff[index.section].bias = newInty
                  
                }
                
            })
            
        }
    }
  
    
}


class cellMessage: UITableViewCell {
    let labelMain = UILabel()
    let tinyLabel = UILabel()
    let imageSenter = UIImageView()
    let imageViewCircleUnseen = UIImageView()
    let imageViewReact = UIImageView()
    
    override func layoutSubviews() {
       imageSenter.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        imageSenter.image = #imageLiteral(resourceName: "empty")
       // imageSenter.layer.cornerRadius
        imageSenter.clipsToBounds = true
        contentView.addSubview(imageSenter)
        //contentView.addSubview(tinyLabel)
        contentView.addSubview(imageViewCircleUnseen)
        contentView.addSubview(labelMain)
        imageViewReact.frame = CGRect(x: 14, y: contentView.frame.height / 2 - 17, width: 33, height: 33)
        contentView.addSubview(imageViewReact)
        labelMain.textAlignment = .center
    labelMain.translatesAutoresizingMaskIntoConstraints = false
    labelMain.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
    labelMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    labelMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
    labelMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        imageViewCircleUnseen.frame = CGRect(x: contentView.frame.width - 40, y: 6, width: 24, height: 24)
//        tinyLabel.translatesAutoresizingMaskIntoConstraints = false
//        tinyLabel.topAnchor.constraint(equalTo: labelMain.bottomAnchor, constant: 5).isActive = true
//        tinyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82).isActive = true
//        tinyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
//        tinyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
        
        labelMain.textColor = UIColor.white
        tinyLabel.textColor = .lightGray
        labelMain.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        tinyLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        labelMain.numberOfLines = 0
        tinyLabel.numberOfLines = 1
       
    }
    
}




class emptyCepp: UITableViewCell {
    
}

class tempSet {
    var theId: String?
    func getId () {
        let newId = "hert"
        theId = newId
    }
}


extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor(red: 0.949, green: 0.251, blue: 0, alpha: 1.0), andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(9)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y + 2), size: CGSize(width: 8, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
