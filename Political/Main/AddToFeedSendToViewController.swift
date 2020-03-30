//
//  AddToFeedSendToViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 7/17/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class AddToFeedSendToViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    
 override var prefersStatusBarHidden: Bool {
    return true
    }
    
    var url: String?
    var key: String?
    var type: String?
    var publisher: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .grouped)
        view.addSubview(tablerView)
        tablerView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        self.automaticallyAdjustsScrollViewInsets = false 
        view.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        tablerView.delegate = self
        tablerView.dataSource = self
        tablerView.register(cellSendAdd.self, forCellReuseIdentifier: "cellSendAdd")
        //tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        textviewA.delegate = self
        sendButton.frame = CGRect(x: view.frame.width - 95, y: view.frame.height - 90, width: 70, height: 70)
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowRadius = 1.0
        sendButton.layer.shadowOpacity = 0.5
        sendButton.setTitle("", for: .normal)
        sendButton.setImage(UIImage(named: "airSend"), for: .normal)
        sendButton.backgroundColor = UIColor(red: 0, green: 0.5922, blue: 0.9373, alpha: 1.0)
        sendButton.layer.cornerRadius = 35
        sendButton.clipsToBounds = true
        sendButton.isHidden = true
        sendButton.addTarget(self, action: #selector(self.postToFeeds), for: .touchUpInside)
        self.view.addSubview(sendButton)
        
        self.loadYourFollowers()
        // Do any additional setup after loading the view.
    }
    var followers = [Useri]()
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSendAdd", for: indexPath) as! cellSendAdd
      let image = UIImage(named: "profile")
        if followers.count > 0 {
            cell.namerLabel.text = followers[indexPath.row].namer
            
            if let urli = followers[indexPath.row].profilePhotoUrl {
                if urli != "none" {
                    let url = URL(string: urli)
                    cell.profileImage.kf.setImage(with: url, placeholder: image)
                } else {
                    cell.profileImage.image = UIImage(named: "profile")
                }
            } else {
                cell.profileImage.image = UIImage(named: "profile")
            }
            cell.changeView.layer.cornerRadius = 10.5
            cell.changeView.clipsToBounds = true
            cell.changeView.layer.borderColor = UIColor.darkGray.cgColor
            cell.changeView.layer.borderWidth = 1.0
            if let yep = followers[indexPath.row].isUnseen {
                if yep == "yep" {
                    cell.changeView.backgroundColor = UIColor(red: 0, green: 0.651, blue: 0.9098, alpha: 1.0)
                } else if yep == "nope" {
                    cell.changeView.backgroundColor = .clear
                }
            } else {
                cell.changeView.backgroundColor = .clear
            }
        }
        return cell
    }
    let sendButton = UIButton()
    let view1 = UIView()
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewl = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        let exitButton = UIButton()
        exitButton.frame = CGRect(x: 10, y: 15, width: 35, height: 35)
        exitButton.setImage(UIImage(named: "downwe"), for: .normal)
        viewl.backgroundColor = UIColor(red: 0.1294, green: 0.1294, blue: 0.1255, alpha: 1.0)
        exitButton.addTarget(self, action: #selector(self.exit), for: .touchUpInside)
        let captionButton = UIButton()
        if let tye = self.type {
            if tye == "send" {
               captionButton.frame = CGRect(x: viewl.frame.width - 45, y: 20, width: 35, height: 35)
                captionButton.setImage(UIImage(named: "caption"), for: .normal)
                captionButton.addTarget(self, action: #selector(self.openComment), for: .touchUpInside)
                viewl.addSubview(captionButton)
            }
        }
        let labelTop = UILabel()
        labelTop.frame = CGRect(x: 100, y: 15, width: self.view.frame.width - 200, height: 55)
        labelTop.numberOfLines = 2
        labelTop.textAlignment = .center
        labelTop.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        labelTop.textColor = .white
        labelTop.text = "Add to someone's feed"
      
        
       index = 1
        let labelTapAll = UILabel(frame: CGRect(x: 50, y: 108, width: view.frame.width - 75, height: 30))
        labelTapAll.textColor = .lightGray
        labelTapAll.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        labelTapAll.text = "Add to ALL my follower's feeds"
        if let tye = self.type {
            if tye == "send" {
                 labelTop.text = "Send to someone"
                labelTapAll.text = "Send to all my followers"
            } else {
                
            }
        }
        view1.frame = CGRect(x: 15, y: 110, width: 24, height: 24)
        view1.layer.cornerRadius = 12
        view1.clipsToBounds = true
        view1.layer.borderWidth = 1.0
        
        let buttonView1 = UIButton(frame: CGRect(x: 5, y: 95, width: self.view.frame.width - 10, height: 55))
        buttonView1.setTitle("", for: .normal)
        buttonView1.addTarget(self, action: #selector(self.buttonAct1), for: .touchUpInside)
        
        view1.layer.borderColor = UIColor.white.cgColor
        view1.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        let otherWiseLabel = UILabel()
        otherWiseLabel.frame = CGRect(x: 10, y: viewl.frame.height - 26, width: 240, height: 25)
        otherWiseLabel.text = "Or select who:"
        otherWiseLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        otherWiseLabel.textColor = .gray
        otherWiseLabel.textAlignment = .left
        viewl.addSubview(otherWiseLabel)
        
       
        
        viewl.addSubview(view1)
        viewl.addSubview(labelTapAll)
        viewl.addSubview(buttonView1)
        viewl.addSubview(labelTop)
        viewl.addSubview(exitButton)
        
        return viewl
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 190
    }
    
    var tablerView = UITableView()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func exit() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var index: Int?
    @objc func buttonAct1 () {
        if strings.count == 0 {
            if index == 1 {
            index = 0
            view1.backgroundColor = .blue
                sendButton.isHidden = false
            } else {
                index = 1
                sendButton.isHidden = true
                view1.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
            }
        }
        
    }
  
    var strings = [String]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let already = followers[indexPath.row].isUnseen {
            if already == "yep" {
                
                strings = strings.filter{$0 != followers[indexPath.row].uider}
                followers[indexPath.row].isUnseen = "nope"
                self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                if strings.count == 0 {
                    index = 0
                    
                    buttonAct1()
                }
            } else {
                strings.append(followers[indexPath.row].uider)
                sendButton.isHidden = false
                followers[indexPath.row].isUnseen = "yep"
                self.tablerView.reloadRows(at: [indexPath], with: .automatic)
                view1.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
               
                index = 3
            }
        } else {
            strings.append(followers[indexPath.row].uider)
            
           followers[indexPath.row].isUnseen = "yep"
            self.tablerView.reloadRows(at: [indexPath], with: .automatic)
            view1.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
            sendButton.isHidden = false
            index = 3
        }
        print(strings)
    }
    
    var checkArray = [String]()
    func loadYourFollowers () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid).child("followers")
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let snap = snapshot.value as? [String : String] {
                    print("entint")
                     let dispatcherGroup = DispatchGroup()
                    for (_,each) in snap {
                        dispatcherGroup.enter()
                        let secondRef = Database.database().reference().child("users").child(each)
                        secondRef.observeSingleEvent(of: .value, with: {(snaply) in
                           
                            let valuei = snaply.value as? [String : AnyObject]
                            if let usernamer = valuei?["username"] as? String, let namerl = valuei?["name"] as? String {
                                        let newUserl = Useri()
                                        print("newuser")
                                        newUserl.namer = namerl
                                        newUserl.uider = each
                                        newUserl.username = usernamer
                                        if let profileimg = valuei?["profileUrl"] as? String {
                                            newUserl.profilePhotoUrl = profileimg
                                        } else {
                                        newUserl.profilePhotoUrl = "none"
                                        }
                                if let theirKey = valuei?["userKey"] as? String {
                                    newUserl.userKey = theirKey
                                }
                                        if self.checkArray.contains(each) {
                                            
                                        } else {
                                            print("appending")
                                            self.checkArray.append(each)
                                            self.followers.append(newUserl)
                                        }
                                
                                        
                                    }
                            dispatcherGroup.leave()
                            })
                    }
                    dispatcherGroup.notify(queue: DispatchQueue.main) {
                        self.tablerView.reloadData()
                    }
                }
                
            })
                        
                        
            

        }
    }
    

    let activy = UIActivityIndicatorView()
    var onces = false
    @objc func postToFeeds () {
      if Auth.auth().currentUser?.isAnonymous == false {
        if self.onces == false {
            onces = true
            activy.color =  UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
            activy.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(activy)
            activy.startAnimating()
        if self.strings.count > 0 {
            for each in self.strings {
                if let url = self.url {
                    if let key = self.key {
                         if self.publisher != nil {
                if let myUid = Auth.auth().currentUser?.uid {
                    if let myName = Auth.auth().currentUser?.displayName {
                     let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                var ref = Database.database().reference().child("users").child(each).child("Feed")
                        if let tye = self.type {
                            if tye == "send" {
                            ref = Database.database().reference().child("users").child(each).child("inbox")
                            }
                        }
                        
                        let update: [String : Any] = ["sentBy" : myUid, "sentFrom" : myName, "unseen" : "unseen", "timeSent" : timeStamp, "url" : url, "aid" : key, "caption" : textviewtext, "publisher" : self.publisher!]
                    let lastUpd = [key : update]
                   
                    ref.updateChildValues(lastUpd)
                   
                   
                        
                    }
                        }
                        }
                    }
                }
            }
             self.activy.stopAnimating()
            if self.type == "send" {
            self.sendOutNotifs()
            } else {
                 self.sendOutUpdate()
            }
             self.dismiss(animated: true, completion: nil)
        } else if self.index == 0 {
            print("would send to all")
            self.strings.removeAll()
            for each in followers {
                self.strings.append(each.uider)
            }
            if strings.count > 0 {
                for each in strings {
                if let url = self.url {
                    if self.publisher != nil {
                    if let key = self.key {
                        if let myUid = Auth.auth().currentUser?.uid {
                            if let myName = Auth.auth().currentUser?.displayName {
                                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                var ref = Database.database().reference().child("users").child(each).child("Feed")
                                if let tye = self.type {
                                    if tye == "send" {
                                        ref = Database.database().reference().child("users").child(each).child("inbox")
                                    }
                                }
                                
                                
                                
                                let update: [String : Any] = ["sentBy" : myUid, "sentFrom" : myName, "timeSent" : timeStamp, "unseen" : "unseen", "url" : url, "aid" : key, "caption" : textviewtext, "publisher" : self.publisher!]
                                let lastUpd = [key : update]
                                
                                ref.updateChildValues(lastUpd)
                               
                                
                            }
                        }
                    }
                    }
                }
            }
                self.activy.stopAnimating()
                if self.type == "send" {
                self.sendOutNotifs()
                } else {
                    self.sendOutUpdate()
                }
                self.dismiss(animated: true, completion: nil)
        }
        }
        }
        }
    }
    
    func sendOutNotifs () {
        if self.strings.count != 0 && self.followers.count != 0 {
            for each in self.followers {
                if self.strings.contains(each.uider) {
                    if let userKey = each.userKey {
                        if let myNme = Auth.auth().currentUser?.displayName {
                        let messgae = "\(myNme) sent you an article!"
                        print("sending notif")
                        let data = [
                            "contents": ["en": "\(messgae)"],
                            "include_player_ids":["\(userKey)"],
                            "ios_badgeType": "Increase",
                            "ios_badgeCount": 1
                            ] as [String : Any]
                        OneSignal.postNotification(data)
                        print("send out")
                    }
                    }
                }
            }
        }
    }
    //this function basically tells the server that this user has recieved an article! So send them a notification if they haven't recieved any notifs recently
    func sendOutUpdate () {
        if self.strings.count != 0 && self.followers.count != 0 {
            for each in self.followers {
                if self.strings.contains(each.uider) {
                    if let userKey = each.userKey {
                        print(userKey)
                          let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                          let ref = Database.database().reference().child("users").child(each.uider)
                        let update = ["recievedFeedAdd" : timeStamp]
                        ref.updateChildValues(update)
                    }
                }
            }
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != UIColor.black {
            textView.textColor = .black
        }
    }
    var textviewtext = ""
    let textviewA = UITextView()
    let exitButtonComment = UIButton()
    let divideViewComment = UIView()

    func setUpComment () {
        
        textviewA.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        
        if self.textviewtext != "" {
            textviewA.text = self.textviewtext
        } else {
            
        }
        
    
        textviewA.frame = CGRect(x: 0, y: 51, width: self.view.frame.width, height: 100)
        divideViewComment.frame = CGRect(x: 0, y: 0, width: commentingView.frame.width , height: 50)
        divideViewComment.backgroundColor = UIColor(red: 0.8863, green: 0.8706, blue: 0.898, alpha: 1.0)
        commentingView.layer.shadowColor = UIColor.gray.cgColor
        commentingView.layer.shadowOpacity = 1
        commentingView.layer.shadowOffset = CGSize.zero
        commentingView.layer.shadowRadius = 2
        commentingView.layer.cornerRadius = 8.0
        divideViewComment.roundCorners([.topLeft, .topRight], radius: 8.0)
        let labelTitle = UILabel()
        labelTitle.frame = CGRect(x: divideViewComment.frame.midX - 50, y: 10, width: 100, height: 35)
        labelTitle.text = "Caption"
        labelTitle.textColor = .black
        labelTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        divideViewComment.addSubview(labelTitle)
        commentingView.addSubview(divideViewComment)
        commentingView.backgroundColor = .white
        exitButtonComment.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        exitButtonComment.setTitle("Exit", for: .normal)
        exitButtonComment.addTarget(self, action: #selector(self.closeComment), for: .touchUpInside)
        exitButtonComment.setTitleColor(.gray, for: .normal)
        
        let postButton = UIButton()
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
        
        return numberOfChars < 150
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
        textviewtext = textviewA.text
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
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


class cellSendAdd: UITableViewCell {
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        profileImage.frame = CGRect(x: 15, y: 5, width: 50, height: 50)
        profileImage.layer.cornerRadius = 25
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        namerLabel.frame = CGRect(x: 70, y: 8, width: contentView.frame.width - 78, height: 25)
        namerLabel.font = UIFont(name: "HelveticaNeue-Heavy", size: 17)
        namerLabel.textAlignment = .left
        namerLabel.textColor = .white
        contentView.addSubview(profileImage)
        contentView.addSubview(namerLabel)
        
        changeView.frame = CGRect(x: contentView.frame.width - 38, y: contentView.frame.height / 2.7, width: 20, height: 20)
        contentView.addSubview(changeView)
    }
    var changeView = UIView()
    let profileImage = UIImageView()
    let namerLabel = UILabel()
    
}

