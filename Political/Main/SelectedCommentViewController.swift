//
//  SelectedCommentViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 4/7/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class SelectedCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

      var loadAttempts = 1
    var publisher: String?
    var commentId: String?
    var commenter: String?
    var aid: String?
    var replyCount: Int?
    var commentLike: Int?
    var commentDislike: Int?
    var selectedLikeOrDislike: String?
    var commentTime: Int? 
    var commentUn: String?
    //var iid: String?
    var comments = [Comment]()
    var urlToLoad: String? 
     var refreshControl = UIRefreshControl()
    
    
      var checkArr = [String]()
    func grabReplies () {
        if let aid = self.aid {
            if let commentID = self.commentId {
                if let uid = Auth.auth().currentUser?.uid {
    let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(commentID).child("replies")
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let replies = snapshot.value as? [String : AnyObject] {
                     
               for (_,one) in replies {
                         if let message = one["message"] as? String, let sender = one["sender"] as? String, let time = one["timeStamp"] as? Int, let key = one["key"] as? String, let likes = one["likes"] as? [String : AnyObject], let dislikes = one["dislikes"] as? [String : AnyObject], let senderUn = one["senderUn"] as? String {
                                                        
                               let newComment = Comment()
                                 newComment.youLikeDis = "None"
                                       if likes[uid] != nil {
                                   newComment.youLikeDis = "Liked"
                                                            
                                                        }
                                                        if dislikes[uid] != nil {
                                                            newComment.youLikeDis = "Disliked"
                                                        }
                                if let theirKey = one["userKey"] as? String {
                                    newComment.userKey = theirKey
                                } else {
                                newComment.userKey = " "
                                }
                                                        
                                                      
                                                        newComment.message = message
                                                        newComment.likes = likes.count-1
                                                        newComment.dislikes = dislikes.count - 1
                                                        newComment.sender = sender
                                                        newComment.key = key
                                                        newComment.time = time
                                                        newComment.senderUn = senderUn
                                                        if self.checkArr.contains(key) {
                                                            
                                                        } else {
                                                            self.comments.append(newComment)
                                                            self.checkArr.append(key)
                                                        }
                                                        //update it here, basically im lazy or laxy? either way it works :P
                                                        let update = ["likeCount" : likes.count-1]
                                                        ref.child(key).updateChildValues(update)
                                                        
                            
                                                        }
                
                                                    }
                            }
                    //get original comment
                     let ref2 = Database.database().reference().child("artItems").child(aid).child("comments").child(commentID)
                    ref2.observeSingleEvent(of: .value, with: {(snap) in
                         let valuei = snap.value as? [String : AnyObject]
                         if let message = valuei?["message"] as? String, let sender = valuei?["sender"] as? String, let time = valuei?["timeStamp"] as? Int, let key = valuei?["key"] as? String, let likes = valuei?["likes"] as? [String : AnyObject], let dislikes = valuei?["dislikes"] as? [String : AnyObject], let senderUn = valuei?["senderUn"] as? String, let replyCount = valuei?["replyCount"] as? Int {
                                let newComment = Comment()
                            newComment.message = message
                            newComment.likes = likes.count-1
                            newComment.dislikes = dislikes.count - 1
                            newComment.sender = sender
                            newComment.key = key
                            newComment.time = time
                            newComment.senderUn = senderUn
                            newComment.replyCount = replyCount
                            if likes[uid] != nil {
                                newComment.youLikeDis = "Liked"
                                
                            }
                            
                            if let theirKey = valuei?["userKey"] as? String {
                                newComment.userKey = theirKey
                            } else {
                                newComment.userKey = " "
                            }
                            if dislikes[uid] != nil {
                                newComment.youLikeDis = "Disliked"
                            }
                            
                            if self.checkArr.contains(key) {
                                
                            } else {
                                self.comments.insert(newComment, at: 0)
                                self.checkArr.append(key)
                            }
                            
                        }
                         self.tablerView.reloadData()
                    })
                     self.oneTimeRef = false 
                })
           
            }
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
       // automaticallyAdjustsScrollViewInsets = false
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50)
        topView.backgroundColor = UIColor(red: 0.9373, green: 0.9451, blue: 1, alpha: 1.0)
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowOpacity = 1
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowRadius = 2
        self.view.addSubview(topView)
        let buttonExit = UIButton()
        buttonExit.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        buttonExit.setTitle("", for: .normal)
       buttonExit.setImage(#imageLiteral(resourceName: "arrowOut"), for: .normal)
        buttonExit.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        
       tablerView.frame = CGRect(x: 0, y: 18, width: self.view.frame.width, height: self.view.frame.height - 60)
      
        tablerView.estimatedRowHeight = 30.0;
        tablerView.rowHeight = UITableView.automaticDimension
         self.automaticallyAdjustsScrollViewInsets = false
        tablerView.delegate = self
        tablerView.dataSource = self
       self.view.backgroundColor = UIColor.groupTableViewBackground
       
      self.grabReplies()
        textviewA.delegate = self
       
        
        
        let labelAddComment = UILabel()
        labelAddComment.frame = CGRect(x: 65, y: 7, width: topView.frame.width - 80, height: 36)
        labelAddComment.text = "  Share a reply..."
        labelAddComment.layer.cornerRadius = 4.0
        labelAddComment.layer.borderColor = UIColor.lightGray.cgColor
        labelAddComment.textColor = .gray
        labelAddComment.layer.borderWidth = 1.0
        topView.addSubview(labelAddComment)
        topView.addSubview(buttonExit)
        
        let buttonOVerComment = UIButton(frame: CGRect(x: 0, y: 0, width: labelAddComment.frame.width, height: labelAddComment.frame.height))
        buttonOVerComment.setTitle("", for: .normal)
        labelAddComment.addSubview(buttonOVerComment)
        buttonOVerComment.addTarget(self, action: #selector(self.openComment), for: .touchUpInside)
        labelAddComment.isUserInteractionEnabled = true
        labelAddComment.addSubview(buttonOVerComment)
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
                 tablerView.frame = CGRect(x: 0, y: 48, width: self.view.frame.width, height: self.view.frame.height - 105)
                topView.frame = CGRect(x: 0, y: self.view.frame.height - 77, width: self.view.frame.width, height: 50)
                let view2 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 27, width: self.view.frame.width, height: 27))
                view2.backgroundColor = UIColor(red: 0.9373, green: 0.9451, blue: 1, alpha: 1.0)
                self.view.addSubview(view2)
            case 2688:
                print("iPhone XS Max")
                topView.frame = CGRect(x: 0, y: self.view.frame.height - 77, width: self.view.frame.width, height: 50)
                tablerView.frame = CGRect(x: 0, y: 48, width: self.view.frame.width, height: self.view.frame.height - 105)
                let view2 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 27, width: self.view.frame.width, height: 27))
                view2.backgroundColor = UIColor(red: 0.9373, green: 0.9451, blue: 1, alpha: 1.0)
                self.view.addSubview(view2)
            case 1792:
                print("iPhone XR")
                topView.frame = CGRect(x: 0, y: self.view.frame.height - 77, width: self.view.frame.width, height: 50)
                tablerView.frame = CGRect(x: 0, y: 48, width: self.view.frame.width, height: self.view.frame.height - 105)
                let view2 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 27, width: self.view.frame.width, height: 27))
                view2.backgroundColor = UIColor(red: 0.9373, green: 0.9451, blue: 1, alpha: 1.0)
                self.view.addSubview(view2)
            default:
                print("Unknown")
            }
        }
        
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tablerView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }

    var oneTimeRef = false
    @objc func refresh (sender:AnyObject) {
        if oneTimeRef == false {
            self.oneTimeRef = true
        self.comments.removeAll()
        self.checkArr.removeAll()
        self.loadAttempts = 1
        self.tablerView.reloadData()
        self.grabReplies()
        self.refreshControl.endRefreshing()
        }
    }
    
    @objc func close () {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tablerView: UITableView!
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return 25
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
    
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let viewi = UIView()
        viewi.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25)
        let labelName = UILabel(frame: CGRect(x: 10, y: 5, width: 250, height: 20))
        labelName.font = UIFont(name: "HelveticaNeue", size: 12)
        labelName.textColor = .gray
        labelName.text = "Username,  --"
        if let lasterMess = comments[section].time {
            if var usernamer = comments[section].senderUn {
                if section == 0 {
                    if self.commentUn != nil {
                        usernamer = self.commentUn!
                    }
                }
                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                let timer = timeStamp - lasterMess
                
                if timer <= 59 {
                    labelName.text = "\(usernamer), \(timer)s ago"
                }
                
                if timer > 59 && timer < 3600 {
                    let minuters = timer / 60
                    labelName.text = "\(usernamer), \(minuters) mins ago"
                    if minuters == 1 {
                        labelName.text = "\(usernamer), \(minuters) min ago"
                    }
                }
                if timer > 59 && timer >= 3600 && timer < 86400 {
                    
                    let hours = timer / 3600
                    
                    if hours == 1 {
                        labelName.text = "\(usernamer), \(hours) hr ago"
                    } else {
                        labelName.text = "\(usernamer), \(hours) hrs ago"
                    }
                    
                    
                }
                if timer > 86400 {
                    
                    
                    let days = timer / 86400
                    labelName.text = "\(usernamer), \(days)days ago"
                    if days == 1 {
                        labelName.text = "\(usernamer), \(days)day ago"
                    }
                    
                }
            }
        }
        viewi.addSubview(labelName)
        return viewi
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        let footerFoot = Bundle.main.loadNibNamed("SelectedCommentAreaTableViewCell", owner: self, options: nil)?.first as! SelectedCommentAreaTableViewCell
        let divideView = UIView()
        divideView.frame = CGRect(x: 5, y: footerFoot.contentView.frame.height - 2, width: footerFoot.frame.width - 20, height: 1)
        divideView.backgroundColor = .lightGray
        footerFoot.addSubview(divideView)
        footerFoot.buttonLikeChat.tag = section
        footerFoot.buttonDislikeChat.tag = section
        
        
        
        footerFoot.labelLikeCount.text = "\(comments[section].likes!)"
        footerFoot.labelDislikesCount.text = "\(comments[section].dislikes!)"
       
        footerFoot.buttonLikeChat.addTarget(self, action: #selector(self.clickedCommentUp), for: .touchUpInside)
        footerFoot.buttonDislikeChat.addTarget(self, action: #selector(self.clickedCommendDown), for: .touchUpInside)
       
        // "Replies • 12"
        
        if section == 0 {
            footerFoot.repliesButton.setTitle("Replies • \(self.comments[section].replyCount!)", for: .normal)
            let wideVuew = UIView()
            wideVuew.frame = CGRect(x: 0, y: footerFoot.frame.height - 5, width: view.frame.width, height: 3)
            wideVuew.backgroundColor = .black
            footerFoot.addSubview(wideVuew)
        } else {
            footerFoot.repliesButton.setTitle("", for: .normal)
        }
        if self.clickedArray.contains(section) {
            footerFoot.buttonLikeChat.setImage(UIImage(named: "blueLike"), for: .normal)
        }
        if self.disClickedArray.contains(section) {
            footerFoot.buttonDislikeChat.setImage(UIImage(named: "blueDis"), for: .normal)
        }
        
        if let likedOrDis = comments[section].youLikeDis {
            if likedOrDis == "Liked" {
                footerFoot.buttonLikeChat.setImage(UIImage(named: "blueLike"), for: .normal)
                 clickedArray.append(section)
            }
            if likedOrDis == "Disliked" {
                footerFoot.buttonDislikeChat.setImage(UIImage(named: "blueDis"), for: .normal)
                 disClickedArray.append(section)
            }
        }
        return footerFoot
    }
    
    
    @objc func clickedCommentUp(sender: UIButton) {
        print(sender.tag)
        
        if clickedArray.contains( where: { $0 == sender.tag } ){
            print("ik")
            clickedArray = clickedArray.filter { $0 != (sender.tag) }
            if let aid = self.aid {
                if let uid = Auth.auth().currentUser?.uid {
                    if let comId = self.commentId {
                    let id = comments[sender.tag].key!
                  
                        if sender.tag == 0 {
            let ref2 = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("likes").child(uid)
                             ref2.removeValue()
                        } else {
            let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("replies").child(id).child("likes").child(uid)
                    ref.removeValue()
                        
                        }
                }
                }
            }
            
            
        } else {
            clickedArray.append(sender.tag)
            let id = comments[sender.tag].key!
            if inQueueArray.contains(id) {
                
            } else {
                let userkEy = comments[sender.tag].userKey
                queue(id: comments[sender.tag].sender!, type: "Like", key: id, userkKey: userkEy!)
                
            }
        }
        disClickedArray = disClickedArray.filter { $0 != (sender.tag) }
    }
    
    var disClickedArray = [Int]()
    @objc func clickedCommendDown(sender: UIButton) {
        if disClickedArray.contains( where: { $0 == sender.tag } ){
            print("ik")
            disClickedArray = disClickedArray.filter { $0 != (sender.tag) }
            if let aid = self.aid {
                 if let comId = self.commentId {
                if let uid = Auth.auth().currentUser?.uid {
                    let id = comments[sender.tag].key!
                    if sender.tag == 0 {
                        let ref2 = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("dislikes").child(uid)
                        ref2.removeValue()
                    } else {
                        let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("replies").child(id).child("dislikes").child(uid)
                        ref.removeValue()
                        
                    }
                }
                }
            }
            
        } else {
            disClickedArray.append(sender.tag)
            let id = comments[sender.tag].key!
            if inQueueArray.contains(id) {
                
            } else {
                queue(id: comments[sender.tag].sender!, type: "Dislike", key: id, userkKey: "")
                
            }
        }
        clickedArray = clickedArray.filter { $0 != (sender.tag) }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSelCom", for: indexPath) as! SelectedCommentAreaTableViewCell
        
        
        
        print(comments.count)
        
        if indexPath.section == 0 {
            if self.commenter != nil {
           cell.textviewet.text = self.commenter
            }
        }
        if indexPath.section > 0 {
            cell.textviewet.text = comments[indexPath.section].message
        }
        
        
        return cell
    }
   
    
    
    
    
    var clickedArray = [Int]()
    
   
    
    var inQueueArray = [""]
    func queue (id: String, type: String, key: String, userkKey: String) {
        inQueueArray.append(id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
           
            if let uid = Auth.auth().currentUser?.uid {
                if let aid = self.aid {
                    if let comId = self.commentId {
                    if type == "Like" {
                        var ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("replies").child(key).child("likes")
                        var refDis = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("replies").child(key).child("dislikes").child(uid)
                        if id == self.commentId {
                            ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("likes")
                            refDis = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("dislikes").child(uid)
                        }
                        let feeder: [String : Any] = [uid : "like"]
                        ref.updateChildValues(feeder)
                        refDis.removeValue()
                        self.inQueueArray = self.inQueueArray.filter { $0 != (id) }
                        if userkKey != " " {
                        self.sendoffNotif(theirUid: id, userkey: userkKey, comId: key)
                        }
                    } else {
                        var ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("replies").child(key).child("dislikes")
                        var refLik = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("replies").child(key).child("likes").child(uid)
                        if id == self.commentId {
                            ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("dislikes")
                            refLik = Database.database().reference().child("artItems").child(aid).child("comments").child(comId).child("likes").child(uid)
                        }
                        let feeder: [String : Any] = [uid : "dislike"]
                        ref.updateChildValues(feeder)
                        refLik.removeValue()
                        self.inQueueArray = self.inQueueArray.filter { $0 != (id) }
                        
                    }
                }
                }
            }
        })
    }
    
   
    var textviewA = UITextView()
    var commentOpen = false
    let commentingView = UIView()
    @objc func openComment () {
        if Auth.auth().currentUser?.uid != nil  && Auth.auth().currentUser?.isAnonymous == false  {
            commentingView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
            self.view.addSubview(commentingView)
            setUpComment()
            commentOpen = true
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.commentingView.frame = CGRect(x: 0, y: self.view.frame.height / 3.4, width: self.view.frame.width, height: self.view.frame.height - self.view.frame.height / 3.4)
                self.textviewA.becomeFirstResponder()
            }, completion: nil)
        } else {
            let alertMore = UIAlertController(title: "Error!", message: "Sorry you cannot comment unless you create or sign into an account.", preferredStyle: .alert)
            let cancel2 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            
            alertMore.addAction(cancel2)
            self.present(alertMore, animated: true, completion: nil)
        }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if comments.count > 0 {
                if indexPath.section > 0 {
        if let uid = Auth.auth().currentUser?.uid {
            if Auth.auth().currentUser?.isAnonymous == false {
            if self.comments[indexPath.section].sender == uid {
                 return true
            }
            }
        }
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let comid = self.commentId {
        if comments.count > 0 {
            if indexPath.section > 0 {
                if let uid = Auth.auth().currentUser?.uid {
                    print(uid)
                    if let key = self.comments[indexPath.section].key {
                        if let aid  = self.aid {
                            let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comid).child("replies").child(key)
                            ref.removeValue()
                        self.comments.remove(at: indexPath.section)
                        self.tablerView.reloadData()
                    }
                    }
                }
            }
        }
        }
    }
    
    let exitButtonComment = UIButton()
    let divideViewComment = UIView()
    func setUpComment () {
        
        textviewA.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        
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
        let postButton = UIButton()
        postButton.frame = CGRect(x: self.commentingView.frame.width - 95, y: 8, width: 80, height: 34)
        postButton.backgroundColor = UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0)
        postButton.setTitleColor(.white, for: .normal)
        postButton.setTitle("Post", for: .normal)
        postButton.layer.cornerRadius = 10.0
        postButton.clipsToBounds = true
        postButton.addTarget(self, action: #selector(self.postComment), for: .touchUpInside)
        self.commentingView.addSubview(postButton)
        self.commentingView.addSubview(exitButtonComment)
        self.commentingView.addSubview(textviewA)
    }
    
    var oncep = false
    @objc func postComment() {
       
            var myUserKey = " "
            if let myKey = UserDefaults.standard.value(forKey: "userKey") as? String {
                myUserKey = myKey
            }
            if let message = self.textviewA.text {
                if message.count > 2 {
                    let string1 = message.lowercased()
                    if  string1.contains(";") || string1.contains(")") || string1.contains("$") || string1.contains("&") || string1.contains("@")  || string1.contains("cock") || string1.contains("penis") || string1.contains("lick") || string1.contains("vagina") || string1.contains("pussy") || string1.contains("fag") || string1.contains("tit") || string1.contains("anal")  || string1.contains("cunt") ||  string1.contains("porn") || string1.contains("nigger") || string1.contains("beaner") || string1.contains("coon") || string1.contains("spic") || string1.contains("wetback") || string1.contains("chink") || string1.contains("gook") || string1.contains("porn") || string1.contains("twat") || string1.contains("crow")  || string1.contains("darkie") || string1.contains("god hates") || string1.contains("  ") || string1.contains("klux") || string1.contains("kkk") || string1.contains("nigga") || string1.contains("kike")
                        
                    {
                        let alertMore = UIAlertController(title: "Error!", message: "This has a word or character that violates our comments policy. Please remove any vulgar words or characters, then post the comment (:", preferredStyle: .alert)
                        let cancel2 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                        
                        alertMore.addAction(cancel2)
                        self.present(alertMore, animated: true, completion: nil)
                        return
                    }
            let time = Int(NSDate().timeIntervalSince1970)
            if self.oncep == false {
                self.oncep = true
                if let aid = self.aid {
                    if let uid = Auth.auth().currentUser?.uid {
                        
                        if let comId = self.commentId {
                        let ref = Database.database().reference()
                        
                        if let mySavedUn = UserDefaults.standard.value(forKey: "username") as? String {
                            
                            
                            let key = ref.child("artItems").child(aid).child("comments").child(comId).child("replies").childByAutoId().key
                            let feedLi = ["message" : message,"userKey" : myUserKey, "sender" : uid, "senderUn" : mySavedUn, "timeStamp" : time, "key" : key!, "likeCount" : 0, "likes" : ["none" : "none"], "dislikes" : ["none" : "none"]] as [String : Any]
                            let mySetup = [key : feedLi]
                            
                            ref.child("artItems").child(aid).child("comments").child(comId).child("replies").updateChildValues(mySetup)
                            self.oncep = false
                            
                            self.textviewA.text = ""
                            self.closeComment()
                            print("POSTED!")
                            // sendNotification()
                            self.updateCount()
                            self.sendNotif()
                            self.animateRepost()
                        }
                    }
                }
                }
                    }
                }
            }
       
    }
    
    
    func updateCount () {
        if let aid = self.aid {
            if let comKey = self.commentId {
        let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(comKey).child("replies")
                ref.observeSingleEvent(of: .value, with: {(snap) in
                    
                    if let amountCount = snap.value as? [String : Any] {
                  let mySetup = ["replyCount" : amountCount.count]
                        let ref3 = Database.database().reference().child("artItems").child(aid).child("comments").child(comKey)
                        ref3.updateChildValues(mySetup)
                    }
                })
            
        }
        }
        
    }
    var alreadySentReply = false
    func sendNotif () {
        
        if self.alreadySentReply == false && self.comments[0].sender != Auth.auth().currentUser?.uid && self.aid != nil {
            self.alreadySentReply = true
            if self.comments.count > 0 {
                if let userkey = self.comments[0].userKey  {
                    if let myNme = Auth.auth().currentUser?.displayName {
                        let messgae = "\(myNme) replied to your comment!"
                        print("sending notif")
                        let data = [
                            "contents": ["en": "\(messgae)"],
                            "include_player_ids":["\(userkey)"],
                            "ios_badgeType": "Increase",
                            "ios_badgeCount": 1
                            ] as [String : Any]
                        OneSignal.postNotification(data)
                        print("send out")
                        if let theirUid = self.comments[0].sender {
                        let refUse = Database.database().reference()
                        let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                         let time = Int(NSDate().timeIntervalSince1970)
                        let ref3 = Database.database().reference()
                        if let myId = Auth.auth().currentUser?.uid  {
                            if self.aid != nil && self.urlToLoad != nil && self.publisher != nil {
                                let setip = ["notification" : "\(myNme) replied to your comment!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "key" : key!, "publisher" : self.publisher!, "aid" : self.aid!, "url" : self.urlToLoad!, "unseen" : "unseen"] as [String : Any]
                                
                                let final = [key : setip]
                                ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                            }
                        }
                        }
                    }
                } else {
                    if let theirUid = self.comments[0].sender {
                        if let myNme = Auth.auth().currentUser?.displayName {
                        let refUse = Database.database().reference()
                        let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                        let time = Int(NSDate().timeIntervalSince1970)
                        let ref3 = Database.database().reference()
                        if let myId = Auth.auth().currentUser?.uid  {
                            if self.aid != nil && self.urlToLoad != nil {
                                let setip = ["notification" : "\(myNme) replied to your comment!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "key" : key!, "aid" : self.aid!, "url" : self.urlToLoad!, "unseen" : "unseen"] as [String : Any]
                                
                                let final = [key : setip]
                                ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                            }
                        }
                    }
                    }
                }
            }
            
        }
    }
    
    
    var updatedAlready = [String]()
    func sendoffNotif (theirUid: String, userkey: String, comId: String) {
        if updatedAlready.contains(theirUid) || theirUid == Auth.auth().currentUser?.uid {
            return
        } else {
            if userkey != " " {
                let time = Int(NSDate().timeIntervalSince1970)
                let ref = Database.database().reference().child("users").child(theirUid).child("lastNotif")
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? Int {
                        
                        if time - value > 21000 {
                            let feedTime = ["lastNotif" : time]
                            
                            //update last notif
                            let ref1 = Database.database().reference()
                            ref1.child("users").child(theirUid).updateChildValues(feedTime)
                            let messgae = "Someone just liked your comment!"
                            print("sending notif")
                            let data = [
                                "contents": ["en": "\(messgae)"],
                                "include_player_ids":["\(userkey)"],
                                "ios_badgeType": "Increase",
                                "ios_badgeCount": 1
                                ] as [String : Any]
                            OneSignal.postNotification(data)
                            print("send out")
                            self.updatedAlready.append(theirUid)
                            let refUse = Database.database().reference()
                            let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                            //let notification = lip["notification"] as? String, let sentBy = lip["receivedFrom"] as? String, let timeSent = lip["timeSent"] as? Int, let nameSender = lip["sentFrom"] as? String, let key = lip["key"] as? String   if let aid = lip["aid"] as? String, let mainUrl = lip["url"] as? String {
                            
                            if let myId = Auth.auth().currentUser?.uid  {
                                if self.aid != nil && self.urlToLoad != nil {
                                    let setip = ["notification" : "Someone liked your comment!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "key" : key!, "aid" : self.aid!, "url" : self.urlToLoad!, "unseen" : "unseen"] as [String : Any]
                                    
                                    let final = [key : setip]
                                    ref1.child("users").child(theirUid).child("inbox").updateChildValues(final)
                                }
                            }
                            
                            return
                            
                        } else {
                            print("too early")
                            return
                        }
                        
                        
                    } else {
                        
                        //update last notif
                        let feedTime = ["lastNotif" : time]
                        let ref3 = Database.database().reference()
                        ref3.child("users").child(theirUid).updateChildValues(feedTime)
                        let messgae = "Someone just liked your comment!"
                        print("sending notif")
                        let data = [
                            "contents": ["en": "\(messgae)"],
                            "include_player_ids":["\(userkey)"],
                            "ios_badgeType": "Increase",
                            "ios_badgeCount": 1
                            ] as [String : Any]
                        OneSignal.postNotification(data)
                        print("send out")
                        self.updatedAlready.append(theirUid)
                        
                        let refUse = Database.database().reference()
                        let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                        
                        
                        if let myId = Auth.auth().currentUser?.uid  {
                            if self.aid != nil && self.urlToLoad != nil {
                                let setip = ["notification" : "Someone liked your comment!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "key" : key!, "aid" : self.aid!, "url" : self.urlToLoad!, "unseen" : "unseen"] as [String : Any]
                                
                                let final = [key : setip]
                                ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                            }
                        }
                        return
                        
                    }
                    
                })
                
                
            }
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        return numberOfChars < 501
    }
    
    
    var titleOfAnimate = "Reply posted!"
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
            self.overView.frame = CGRect(x: 20, y: self.view.frame.height - 80, width: self.view.frame.width - 40, height: 55)
            
        }, completion: { finished in
            self.closeAnimateRepost()
        })
    }
    
    func closeAnimateRepost () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.overView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.overView.frame.width - 40, height: 0)
            self.overView.removeFromSuperview()
            self.labelShow.removeFromSuperview()
        })
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
