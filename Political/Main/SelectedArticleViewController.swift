//
//  SelectedArticleViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 10/5/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import Firebase
import OneSignal
import SafariServices
import ReadabilityKit
import Kingfisher

protocol changedValues {
    func userDidChangeBias(biasScore: Float, aid: String, index: IndexPath, myId: String, cell:String)
    func userDidChangeLikeDislike(type: String, index: IndexPath, cell: String, aid: String, myId: String)
    func userAlreadyUpdatedActive(index: IndexPath)
    func nowAllowBiasVote(index: IndexPath)
}

class SelectedArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SFSafariViewControllerDelegate {

    var delegate: changedValues?
    // importants
    var aid: String?
    var publisher: String?
    var titler: String?
    var views: String?
    var likes: Int?
    var dislikes: Int?
    var timer: String?
    var bias: Int?
    var personalBias: Float?
    var personLikeDis: String?
    var indexPathi: IndexPath?
    var cell: String?
    var publishedAt: Int?
   // var noID: String?
   // var useID: String?
    var activeUpdatedAlready: Int?
    var allowedToRateBias: Int?
    var allowedToGoToProfile: Int?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
     var biasAllow = true
    
    var refreshControl = UIRefreshControl()
    var refreshBiasVotes = UIRefreshControl()

    override func viewWillLayoutSubviews() {
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
        //UIApplication.shared.statusBarStyle = .lightContent
        
    }
    override func viewWillDisappear(_ animated: Bool) {
     //  self.saveYourBias()
        if self.changedBias == true {
            if let aid = self.aid {
                if let uid = Auth.auth().currentUser?.uid {
                 if indexPathi != nil {
                       if cell != nil {
                 let bias = uislideer.value
                    self.delegate?.userDidChangeBias(biasScore: bias, aid: aid, index: indexPathi!, myId: uid, cell: cell!)
                print("delegate passed")
            }
                }
                }
            }
        }
        
            if changedShit == true {
            if indexPathi != nil {
                if let uid = Auth.auth().currentUser?.uid {
                if cell != nil {
                    print("called")
                    print(whatOn)
                    self.delegate?.userDidChangeLikeDislike(type: whatOn, index: indexPathi!, cell: cell!, aid: aid!, myId: uid)
                    
                }
                }
            }
        }
        if self.updatedActive == true {
            if indexPathi != nil {
                if Auth.auth().currentUser?.uid != nil {
                   
                        self.delegate?.userAlreadyUpdatedActive( index: indexPathi!)
                    
                }
            }
        }
        if self.biasAllow == true {
            if indexPathi != nil {
                if self.allowedToRateBias == nil {
                self.delegate?.nowAllowBiasVote(index: indexPathi!)
                }
            }
        }
        
    }
    
      var clickedArray = [Int]()
    var putdown = false
    let viewer = UIView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if tutorial
      
        
        if allowedToRateBias != nil {
            uislideer.isUserInteractionEnabled = true
        } else {
           // uislideer.isUserInteractionEnabled = false
        }
        
        viewl.frame = CGRect(x: 0, y: -250, width: self.view.frame.width, height: 250)
        viewl.backgroundColor = .darkText
        self.view.backgroundColor = .darkText
        tablerView.estimatedRowHeight = 40.0;
        tablerView.rowHeight = UITableView.automaticDimension
        tablerView.delegate = self
        tablerView.dataSource = self
            //UIColor(red: 0.9373, green: 0.9373, blue: 0.9569, alpha: 1.0)
        self.tableviewSetUp()
       
        grabBias()
       
        grabBiasCount()
        grabLikeDislike()
        grabYourLike()
        self.checkIfArticleIsVideo()
            //UIColor.groupTableViewBackground
        self.bottomView.frame = CGRect(x: 0, y: self.view.frame.height - 47, width: self.view.frame.width, height: 47)
        self.bottomView.addSubview(backButton)
        bottomView.layer.addBorder(edge: .top, color: .lightGray, thickness: 0.5)
        viewer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        viewer.backgroundColor = .white
       setupBottomBarg()
        view.addSubview(self.viewer)
        labelType.layer.cornerRadius = 4.0
        labelType.layer.borderColor = UIColor.gray.cgColor
        labelType.layer.borderWidth = 1.0
        labelType.clipsToBounds = true
       
        self.tabBarController?.tabBar.isHidden = true
        self.setToolbarItems(nil, animated: true)
      //  tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
       //viewChats.addSubview(tablerView)
        tablerView.allowsSelection = false
        loader.frame = CGRect(x: view.frame.width / 2 - 20, y: 280, width: 40, height: 50)
        loader.color = UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
       textviewA.delegate = self 
        
      // uislideer.isUserInteractionEnabled = false 
        self.bottomView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
       
        self.automaticallyAdjustsScrollViewInsets = false
        
         refreshBiasVotes.tintColor = UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0)

        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
             //   self.buttonOverOpenComments.frame = labelType.frame
            case 1334:
                print("iPhone 6/6S/7/8")
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
            case 2436:
                print("iPhone X, XS")
                self.bottomView.frame = CGRect(x: 0, y: self.view.frame.height - 77, width: self.view.frame.width, height: 50)
                let view2 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 27, width: self.view.frame.width, height: 27))
               view2.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                self.view.addSubview(view2)
            case 2688:
                print("iPhone XS Max")
                self.bottomView.frame = CGRect(x: 0, y: self.view.frame.height - 77, width: self.view.frame.width, height: 50)
                let view2 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 27, width: self.view.frame.width, height: 27))
                view2.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                self.view.addSubview(view2)
            case 1792:
                print("iPhone XR")
                self.bottomView.frame = CGRect(x: 0, y: self.view.frame.height - 77, width: self.view.frame.width, height: 50)
                let view2 = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 27, width: self.view.frame.width, height: 27))
                
                view2.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                self.view.addSubview(view2)
            default:
                print("Unknown")
            }
        }
        
//        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
      //  tablerView.addSubview(refreshControl)
        
      
        refreshBiasVotes.addTarget(self, action: #selector(refreshBias(sender:)), for: UIControl.Event.valueChanged)
        tablerView.addSubview(refreshBiasVotes)
        
        self.viewUpdate()
        self.addActive()
        uislideer.addTarget(self, action: #selector(self.movedSlider), for: .valueChanged)
        
        
          if let mySavedUn = UserDefaults.standard.value(forKey: "showTutorial") as? String {
            print(mySavedUn)
        let buttonGo = UIButton()
        buttonGo.tag = 0
        buttonGo.addTarget(self, action: #selector(self.takeTutorial(sender:)), for: .touchUpInside)
        buttonGo.sendActions(for: .touchUpInside)
        }
        // Do any additional setup after loading the view.
    }
    
    
    let gestureCantRateBias = UIPanGestureRecognizer()
    let topViewDislikes = UIView()
     let labelDislikesCount = UILabel()
    let labelLikesCount = UILabel()
  let labelBiasCount = UILabel()
    let imageViewLikesi = UIImageView()
     let imageviewDislikes = UIImageView()
    let uislideer = UISlider()
       let viewl = UIView()
      let centerLabel = UILabel()
     let blueView = UIView()
    let shawdowView2 = UIView()
     let topview = UIView()
    let shawdowView1 = UIView()
    func layoutHeader () {
       
        shawdowView1.frame = CGRect(x: 5, y: 8, width: self.view.frame.width - 10, height: 80)
       
        shawdowView1.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        shawdowView1.layer.shadowColor = UIColor.gray.cgColor
        shawdowView1.layer.cornerRadius = 8.0
        shawdowView1.layer.shadowOpacity = 1
        shawdowView1.layer.shadowOffset = CGSize.zero
        shawdowView1.layer.shadowRadius = 2
        viewl.addSubview(shawdowView1)
       
       
        topview.backgroundColor = .lightGray
           // UIColor(red: 0.3647, green: 0.7294, blue: 0, alpha: 1.0)
        topview.frame = CGRect(x: 10, y: 10, width: shawdowView1.frame.width - 20, height: 8)
        topview.layer.cornerRadius = 2
        topview.clipsToBounds = true
        
       // self.topViewDislikes.frame = CGRect(x: shawdowView1.frame.width - 150, y: 0, width: 140, height: 8)
        topViewDislikes.backgroundColor = .red
        topview.layer.cornerRadius = 2
        topViewDislikes.clipsToBounds = true
        
        
        imageViewLikesi.frame = CGRect(x: 20, y: 28, width: 35, height: 35)
      //  imageViewLikesi.image = #imageLiteral(resourceName: "up1")
        
       
        imageviewDislikes.frame = CGRect(x: self.view.frame.width - 55, y: 28, width: 35, height: 35)
       // imageviewDislikes.image = #imageLiteral(resourceName: "down1")
        
        let actionButtonLikes = UIButton()
        actionButtonLikes.frame = CGRect(x: imageViewLikesi.frame.origin.x - 10, y: 20, width: 45, height: 45)
        actionButtonLikes.addTarget(self, action: #selector(self.likeAction), for: .touchUpInside)
        
        let actionButtonDislikes = UIButton()
        actionButtonDislikes.frame = CGRect(x: imageviewDislikes.frame.origin.x - 10, y: 20, width: 45, height: 45)
        actionButtonDislikes.addTarget(self, action: #selector(self.dislikeAction), for: .touchUpInside)
        
        
        labelLikesCount.frame = CGRect(x: 22, y: shawdowView1.frame.height - 22, width: 100, height: 20)
        labelLikesCount.textAlignment = .left
        labelLikesCount.textColor = .lightGray
        labelLikesCount.text = "---"
       // labelLikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
        shawdowView1.addSubview(labelLikesCount)
        
       
        labelDislikesCount.frame = CGRect(x: shawdowView1.frame.width - 122, y: shawdowView1.frame.height - 22, width: 100, height: 20)
        labelDislikesCount.textAlignment = .right
        labelDislikesCount.textColor = .lightGray
        labelDislikesCount.text = "---"
      //  labelDislikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
        shawdowView1.addSubview(labelDislikesCount)
       
        shawdowView1.addSubview(imageviewDislikes)
        shawdowView1.addSubview(imageViewLikesi)
        shawdowView1.addSubview(topview)
        shawdowView1.addSubview(actionButtonLikes)
        topview.addSubview(topViewDislikes)
        shawdowView1.addSubview(actionButtonDislikes)
       
          shawdowView1.addSubview(centerLabel)
       centerLabel.translatesAutoresizingMaskIntoConstraints = false
        centerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1).isActive = true
        centerLabel.topAnchor.constraint(equalTo: shawdowView1.topAnchor, constant: 28).isActive = true
        self.centerLabel.frame.size.width = 120
        self.centerLabel.frame.size.height = 60
        
       
        shawdowView2.frame = CGRect(x: 5, y: 98, width: self.view.frame.width - 10, height: 80)
        
        shawdowView2.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
            //UIColor.white
        shawdowView2.layer.shadowColor = UIColor.gray.cgColor
        shawdowView2.layer.cornerRadius = 8.0
        shawdowView2.layer.shadowOpacity = 1
        shawdowView2.layer.shadowOffset = CGSize.zero
        shawdowView2.layer.shadowRadius = 2
        viewl.addSubview(shawdowView2)
        
       
        shawdowView2.addSubview(uislideer)
        
       
        
        uislideer.translatesAutoresizingMaskIntoConstraints = false
        uislideer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1).isActive = true
        uislideer.topAnchor.constraint(equalTo: shawdowView2.topAnchor, constant: 10).isActive = true
        self.uislideer.frame.size.width = self.viewl.frame.width - 30
        self.uislideer.frame.size.height = 20
        uislideer.minimumValue = -2
        uislideer.maximumValue = 2
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
        self.uislideer.addGestureRecognizer(panGesture)
        if self.allowedToRateBias == nil {
            gestureCantRateBias.minimumNumberOfTouches = 1
            gestureCantRateBias.accessibilityFrame = CGRect(x: 15, y: 10, width: self.viewl.frame.width - 30, height: 30)
            gestureCantRateBias.addTarget(self, action: #selector(self.noRatePopUp))
            //viewl.addGestureRecognizer(gestureCantRateBias)
        }
        
        
        let labelLeftBias = UILabel()
        let labelRightBias = UILabel()
        let unBias = UILabel()
        
     
        labelLeftBias.frame = CGRect(x: 20, y: 35, width: 65, height: 20)
        labelLeftBias.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        labelLeftBias.text = "Left"
        labelLeftBias.textColor = .lightGray
        shawdowView2.addSubview(labelLeftBias)
        
     
      
        
        //label avg
        if uislideer.value <= 1.7 && uislideer.value >= -1.7 {
        labelAvg.frame = CGRect(x: uislideer.thumbCenterX - 6, y: shawdowView2.frame.height - 42, width: 40, height: 15)
        labelAvg.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        labelAvg.textColor = .lightGray
        labelAvg.textAlignment = .center
        labelAvg.text = "Avg."
        shawdowView2.addSubview(labelAvg)
        }
        
        
        shawdowView2.addSubview(unBias)
        unBias.translatesAutoresizingMaskIntoConstraints = false
        unBias.centerXAnchor.constraint(equalTo: shawdowView2.centerXAnchor, constant: 0).isActive = true
        unBias.topAnchor.constraint(equalTo: shawdowView2.topAnchor, constant: 48).isActive = true
        unBias.frame.size.height = 20
        unBias.frame.size.width = 120
        unBias.font = UIFont(name: "HelveticaNeue-Medium", size: 21)
        unBias.text = "Bias"
        unBias.textColor = .white
        
        labelRightBias.frame = CGRect(x: shawdowView2.frame.width - 85, y: 35, width: 65, height: 20)
        labelRightBias.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        labelRightBias.text = "Right"
        labelRightBias.textColor = .lightGray
        labelRightBias.textAlignment = .right
        shawdowView2.addSubview(labelRightBias)
        
      
        labelBiasCount.text = "-- votes"
        labelBiasCount.frame = CGRect(x: 19, y: shawdowView2.frame.height - 22, width: 150, height: 20)
        labelBiasCount.font = UIFont(name: "HelveticaNeue", size: 12)
        labelBiasCount.textAlignment = .left
        labelBiasCount.textColor = .lightGray
        
        shawdowView2.addSubview(labelBiasCount)
        
        let chatsIcon = UIImageView()
       chatsIcon.frame = CGRect(x: 50, y: viewl.frame.height - 55, width: 35, height: 35)
        chatsIcon.loadGif(name: "chatterGif")
        chatsIcon.contentMode = .scaleAspectFit
        viewl.addSubview(chatsIcon)
        let chatsButtoner = UIButton()
        chatsButtoner.frame = CGRect(x: 45, y: viewl.frame.height - 60, width: 50, height: 50)
        chatsButtoner.setTitle("", for: .normal)
        chatsButtoner.addTarget(self, action: #selector(self.openChats), for: .touchUpInside)
        viewl.addSubview(chatsButtoner)
        
        let reShareicon = UIImageView()
       reShareicon.clipsToBounds = true
       
        
        viewl.addSubview(reShareicon)
        reShareicon.contentMode = .scaleAspectFill
        reShareicon.translatesAutoresizingMaskIntoConstraints = false
        reShareicon.centerXAnchor.constraint(equalTo: viewl.centerXAnchor, constant: 0).isActive = true
        reShareicon.centerYAnchor.constraint(equalTo: viewl.centerYAnchor, constant: 90).isActive = true
        reShareicon.frame.size.height = 40
        reShareicon.frame.size.width = 40
         reShareicon.image = UIImage(named: "sendShare.png")
        
        let reshareButton = UIButton()
        viewl.addSubview(reshareButton)
        reshareButton.translatesAutoresizingMaskIntoConstraints = false
        reshareButton.centerXAnchor.constraint(equalTo: viewl.centerXAnchor, constant: 0).isActive = true
        reshareButton.centerYAnchor.constraint(equalTo: viewl.centerYAnchor, constant: 80).isActive = true
        reshareButton.frame.size.height = 80
        reshareButton.frame.size.width = 60
        reshareButton.addTarget(self, action: #selector(self.openShare), for: .touchUpInside)
        
        let viewsIcon = UIImageView()
        viewsIcon.frame = CGRect(x: self.view.frame.width - 90, y: viewl.frame.height - 55, width: 35, height: 35)
        viewsIcon.image = UIImage(named: "linkArt.png")
        viewl.addSubview(viewsIcon)
        let buttunInfo = UIButton()
        buttunInfo.frame = CGRect(x: self.view.frame.width - 100, y: viewl.frame.height - 60, width: 45, height: 45)
        buttunInfo.addTarget(self, action: #selector(openInfo), for: .touchUpInside)
        viewl.addSubview(buttunInfo)
        

       setSlider(slider: uislideer)
     
       blueView.backgroundColor = UIColor(red: 0.1451, green: 0.5529, blue: 0.9882, alpha: 1.0)
        centerLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        centerLabel.text = "--% liked"
        centerLabel.textColor = .white
        centerLabel.textAlignment = .center
        
    }
    
    var doneRef = false
    @objc func refreshBias (sender:AnyObject) {
        if self.changedBiasForRefresh == true {
            self.changedBiasForRefresh = false
            doneRef = true
            let bias = uislideer.value
            if let uid =  Auth.auth().currentUser?.uid {
                if let aid = self.aid {
                    
            let ref1 = Database.database().reference().child("artItems").child(aid).child("biasVotes")
            
            let feeder: [String : Any] = [uid : bias]
            ref1.updateChildValues(feeder)
            
                    
        var zeroStart:Float = 0
                   
        self.personalBias = uislideer.value
        let refUpdateAll = Database.database().reference().child("artItems").child(aid).child("biasVotes")
        refUpdateAll.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let snapshot = snapshot.value as? [String : AnyObject] {
                            for (_,each) in snapshot {
                                let floatt = each as! NSNumber
                                //  array.append(floatt.floatValue)
                                zeroStart += floatt.floatValue
                            }
                            let final = zeroStart / Float(snapshot.count)
                            
                            
                            self.uislideer.value = final
                            
                            if final <= 1.7 && final >= -1.7 {
                                self.labelAvg.frame = CGRect(x: self.uislideer.thumbCenterX-18, y: self.shawdowView2.frame.height - 42, width: 40, height: 15)
                                print("setup avglbl")
                            } else {
                                self.labelAvg.isHidden = true
                            }
                            
                            
                            let slider = self.uislideer
                            self.sublay.frame = CGRect(x: slider.thumbCenterX - 16, y: 0, width: 10, height: self.uislideer.frame.height)
                            self.sublay.backgroundColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
                            self.tgl.addSublayer(self.sublay)
                            
                            UIGraphicsBeginImageContextWithOptions(self.tgl.frame.size, false, 0.0)
                            self.tgl.render(in: UIGraphicsGetCurrentContext()!)
                            let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            
                            
                            slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
                            slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
                            
                            
                            
                          
                        }
                        else {
                            let slider = self.uislideer
                            self.sublay.frame = CGRect(x: slider.thumbCenterX - 16, y: 0, width: 10, height: self.uislideer.frame.height)
                            self.sublay.backgroundColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
                            self.tgl.addSublayer(self.sublay)
                            
                            UIGraphicsBeginImageContextWithOptions(self.tgl.frame.size, false, 0.0)
                            self.tgl.render(in: UIGraphicsGetCurrentContext()!)
                            let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            
                            
                            slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
                            slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
                        }
                        self.grabYourBias()
                    })
            
            
        }
            }
        } else {
            self.refreshBiasVotes.endRefreshing()
        }
    }
    
    @objc func panGesture(gesture:UIPanGestureRecognizer){
        movedSlider()
        let currentPoint = gesture.location(in: uislideer)
        let percentage = currentPoint.x/uislideer.bounds.size.width;
        let delta = Float(percentage) *  (uislideer.maximumValue - uislideer.minimumValue)
        let value = uislideer.minimumValue + delta
        uislideer.setValue(value, animated: true)
    }
   
    var urlToLoad: String?
    var publisherImageUrl: String?
  
    func tableviewSetUp () {
    //webview
        var frame = CGRect(x: 0, y: 22, width: self.view.frame.width, height: self.view.frame.height - 69)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                
            case 2436:
                print("iPhone X, XS")
                
                frame = CGRect(x: 0, y: 42, width: self.view.frame.width, height: self.view.frame.height - 119)
            case 2688:
                print("iPhone XS Max")
                frame = CGRect(x: 0, y: 42, width: self.view.frame.width, height: self.view.frame.height - 119)
            case 1792:
                print("iPhone XR")
                frame = CGRect(x: 0, y: 42, width: self.view.frame.width, height: self.view.frame.height - 119)
            default:
                print("Unknown")
            }
        }
        tablerView.frame = frame
        tablerView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        tablerView.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
              
              tablerView.addSubview(viewl)
              layoutHeader()
              tablerView.bringSubviewToFront(viewl)
              let contenter = CGPoint(x: 0, y: -tablerView.contentInset.top)
              tablerView.setContentOffset(contenter, animated: false)
        
        tablerView.isOpaque = false
      
       
        view.addSubview(loader)
        loader.startAnimating()
        
        if publisherImageUrl == nil {
            if let pub = self.publisher {
                self.publisherImageUrl = self.publishers(name: pub)
            }
        }
        
        if let urler = urlToLoad {
            if let theurl = URL(string: urler) {
                Readability.parse(url: theurl, completion: { data in
                    let title = data?.title
                    let description = data?.description
                   // let keywords = data?.keywords
                    let imageUrl = data?.topImage
                    if let titleBefore = self.titler {
                        self.titleLer = titleBefore
                    } else {
                        if let title = title {
                          self.titleLer = title
                         print(title)
                    }
                    }
                    
                  //grabLargestDes
                    if let aid = self.aid {
                        let ref = Database.database().reference()
                ref.child("Feed").child(aid).child("description").observeSingleEvent(of: .value, with: { snapshot in
                            if let theDes = snapshot.value as? String {
                                if let desParse = description {
                                    if theDes.count > desParse.count {
                                        self.descrpi = theDes
                                    } else {
                                        if desParse.count < 1000 {
                                            self.descrpi = desParse
                                        } else {
                                            self.descrpi = theDes
                                        }
                                    }
                                }
                            } else {
                                 if let desParse = description {
                                    self.descrpi = desParse
                                 } else {
                                    self.descrpi = "No description..."
                                }
                            }
                            if self.img == nil {
                                print("going gtrab!")
                                if let imageUrl = imageUrl {
                            let url = URL(string: imageUrl)
                                               
                            DispatchQueue.global().async {
                                 let data = try? Data(contentsOf: url!)
                                    DispatchQueue.main.async {
                                        if data != nil {
                                           self.img = UIImage(data: data!)
                                          self.tablerView.reloadSections([0], with: .automatic)
                                        }
                                }
                                    }
                                }
                                                   
                            }
                             self.tablerView.reloadSections([1], with: .automatic)
                            self.loader.stopAnimating()
                    self.grabThreeComments()
                            })
                        
                    }
                    
                    
                   // let videoUrl = data?.topVideo
                  
                  
                })
                
                
            }
        }
       
            
        
    }
    
    var urlOfImage: String?
    
    var onceCallPop = false
    @objc func noRatePopUp () {
        if self.onceCallPop == false {
            self.onceCallPop = true
        let alert = UIAlertController(title: titleT, message: "", preferredStyle: .alert)
        let canel = UIAlertAction(title: "Got it", style: .cancel) {  (alert : UIAlertAction) -> Void in
            self.onceCallPop = false
            }
        alert.addAction(canel)
        self.present(alert, animated: true, completion: nil)
           
        }
    }
    
    var titleLer = " "
    var descrpi = " "
    
    var titleT = "Please read some of the article before rating bias."
    func checkIfArticleIsVideo () {
        if let publisher = self.publisher {
            if publisher.lowercased().contains("cbs") || publisher.lowercased().contains("cnn") || publisher.lowercased().contains("nbc") || publisher.lowercased().contains("abc") || publisher.lowercased().contains("msnbc") || publisher.lowercased().contains("bloomberg") || publisher.lowercased().contains("politico") {
                self.titleT = "Please read or watch some of the article/video before rating bias."
              DispatchQueue.main.asyncAfter(deadline: .now() + 30.0, execute: {
                self.biasAllow = true
                self.uislideer.isUserInteractionEnabled = true
                self.viewl.removeGestureRecognizer(self.gestureCantRateBias)
                })
            }
          
        }
    }
    
    
    func grabThreeComments () {
        if let aid = self.aid {
             if let uid = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference().child("artItems").child(aid).child("comments")
                            ref.queryLimited(toLast: 3).queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: {(snapshot) in
                            if let messages = snapshot.value as? [String : AnyObject] {
                                for (_,one) in messages {
                                    if let message = one["message"] as? String, let sender = one["sender"] as? String, let time = one["timeStamp"] as? Int, let key = one["key"] as? String, let likes = one["likes"] as? [String : AnyObject], let dislikes = one["dislikes"] as? [String : AnyObject], let senderUn = one["senderUn"] as? String, let replyCount = one["replyCount"] as? Int {
                                        
                                            let newComment = Comment()
                                        newComment.youLikeDis = "None"
                                        if likes[uid] != nil {
                                        newComment.youLikeDis = "Liked"
                                       
                                        }
                                        if dislikes[uid] != nil {
                                            newComment.youLikeDis = "Disliked"
                                        }
                                        if let senderName = one["senderName"] as? String {
                                            newComment.senderName = senderName
                                        } else {
                                            newComment.senderName = "Name not found"
                                        }
                                         if let theirKey = one["userKey"] as? String {
                                            newComment.userKey = theirKey
                                         } else {
                                            newComment.userKey = " "
                                        }
                                        
                                        newComment.replyCount = replyCount
                                      
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
                                if self.comments.count != 0 {
                                   // let refreshThem = self.comments.count
                                    self.numberOfChats = self.comments.count
                                    if self.comments.count == 1 {
                                        self.tablerView.insertSections([3], with: .automatic)
                                        self.tablerView.reloadSections([3], with: .automatic)
                                    } else if self.comments.count == 2 {
                                        self.tablerView.insertSections([3,4], with: .automatic)
                                        self.tablerView.reloadSections([3,4], with: .automatic)
                                    } else if self.comments.count == 3 {
                                        self.tablerView.insertSections([3,4,5], with: .automatic)
                                        self.tablerView.reloadSections([3,4,5], with: .automatic)
                                    }
                                    
                               
                                }
                               
                            } else {
                               
                                print("no comments")
                               
                            }
                                
                               // self.refreshControl.endRefreshing()
                                self.waitForInitial = true
                        })
                        }
        }
    }
    
  
var onceCallEDTRIP = false

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > -100 {
            if self.onceCallEDTRIP == false {
            self.biasAllow = true
            self.uislideer.isUserInteractionEnabled = true
            self.viewl.removeGestureRecognizer(gestureCantRateBias)
            }
        }
    }
    
  //  let goer = selectedArtsy()
     let imageViewshow = UIImageView()
    @objc func openSafari() {
        if let urli = self.urlToLoad {
             if let mySaved = UserDefaults.standard.value(forKey: "showBrowser") as? String {
            print(mySaved)
               
                imageViewshow.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
                imageViewshow.image = #imageLiteral(resourceName: "browserTutorial")
                let buttonGetOut = UIButton()
                buttonGetOut.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                buttonGetOut.setTitle("Got it", for: .normal)
                
             
                buttonGetOut.titleLabel?.textColor = .white
                buttonGetOut.frame = CGRect(x: view.frame.midX - 75, y: view.frame.midY + 100, width: 150, height: 50)
                buttonGetOut.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
                buttonGetOut.clipsToBounds = true
                buttonGetOut.layer.cornerRadius = 10.0
                buttonGetOut.addTarget(self, action:
                    #selector(self.nowOpenAfterBrowserTut), for: .touchUpInside)
                   imageViewshow.addSubview(buttonGetOut)
                imageViewshow.isUserInteractionEnabled = true
                
                self.view.addSubview(imageViewshow)
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    self.imageViewshow.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }, completion: nil)
          //  let url = URL(string: urli)
//            let svc = SFSafariViewController(url: url!)
//
//          self.present(svc, animated: true, completion: nil)
             } else if let mySavedBrowser = UserDefaults.standard.value(forKey: "browse") as? String  {
                print(mySavedBrowser)
                if let url = self.urlToLoad {
                    let urlString = URL(string: url)
                
                let vc = SFSafariViewController(url: urlString!)
                    self.present(vc, animated: true, completion: nil)
                }
             } else {
            UIApplication.shared.open(URL(string:urli)!, options: [:], completionHandler: nil)
         self.biasAllow = true
        self.uislideer.isUserInteractionEnabled = true
        self.viewl.removeGestureRecognizer(gestureCantRateBias)
            }
            
            //  let prefs = UserDefaults.standard
               //       prefs.removeObject(forKey: "showBrowser")
        }
    }
    
    @objc func nowOpenAfterBrowserTut () {
        if let urli = self.urlToLoad {
            UIApplication.shared.open(URL(string:urli)!, options: [:], completionHandler: nil)
                    self.biasAllow = true
                   self.uislideer.isUserInteractionEnabled = true
                   self.viewl.removeGestureRecognizer(gestureCantRateBias)
              let prefs = UserDefaults.standard
                prefs.removeObject(forKey: "showBrowser")
            self.imageViewshow.removeFromSuperview()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
            if scrollView == tablerView {
            if self.loadAttempts < 8 {
                
                self.fetchCommentstop()
                    
            }
            }
        }
    }
    
    //BACK BUTTON
    let backButton: UIButton = {
        let buttonBack = UIButton()
        buttonBack.frame = CGRect(x: 8, y: 6, width: 35, height: 35)
        buttonBack.setImage(#imageLiteral(resourceName: "arrowert"), for: .normal)
        buttonBack.addTarget(self, action: #selector(pushedBack), for: .touchUpInside)
        return buttonBack
    }()
    
    
    // BOTTOM BAR
    //let buttonOverOpenComments = UIButton()
    func setupBottomBarg () {
         let buttonComment = UIButton()
        imageLiker.frame = CGRect(x: self.view.frame.width - 90, y: 6, width: 35, height: 35)
        imageDislikers.frame = CGRect(x: self.view.frame.width - 45, y: 6, width: 35, height: 35)
       // buttonUpChats.frame = CGRect(x: self.view.frame.width - 135, y: 6, width: 35, height: 35)
        

        labelType.translatesAutoresizingMaskIntoConstraints = false
        labelType.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 6).isActive = true
        labelType.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10).isActive = true
        labelType.trailingAnchor.constraint(equalTo: imageLiker.leadingAnchor, constant: -10).isActive = true
        labelType.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -6).isActive = true
        
        buttonComment.frame = CGRect(x: labelType.frame.origin.x - 10, y: 5, width: labelType.frame.width + 30, height: labelType.frame.height)
        
     //   buttonOverOpenComments.frame = CGRect(x: self.buttonUpChats.frame.origin.x - 10, y: 5, width: 60, height: 40)
       // buttonOverOpenComments.addTarget(self, action: #selector(self.openChats), for: .touchUpInside)
   //     buttonOverOpenComments.setTitle("", for: .normal)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                
                
            case 1136:
                buttonComment.frame = CGRect(x: 70, y: 5, width: 100, height: labelType.frame.height)
        //        buttonOverOpenComments.frame = CGRect(x: self.view.frame.width - 140, y: 5, width: 42, height: 40)
                labelType.text = " Comment here.."
                
                
               case 2436:
                buttonComment.frame = CGRect(x: labelType.frame.origin.x - 10, y: 5, width: labelType.frame.width + 50, height: labelType.frame.height)
                case 2688:
                buttonComment.frame = CGRect(x: labelType.frame.origin.x - 10, y: 5, width: labelType.frame.width + 60, height: labelType.frame.height)
                case 1792:
             buttonComment.frame = CGRect(x: labelType.frame.origin.x - 10, y: 5, width: labelType.frame.width + 600, height: labelType.frame.height)
                
            default:
                print("Unknown")
            }
        }
      //  self.bottomView.addSubview(buttonOverOpenComments)
        
        let buttonLikeAct = UIButton()
        buttonLikeAct.frame = CGRect(x: self.imageLiker.frame.origin.x - 10, y: 5, width: 50, height: 50)
        buttonLikeAct.addTarget(self, action: #selector(self.likeAction), for: .touchUpInside)
        buttonLikeAct.setTitle("", for: .normal)
        self.bottomView.addSubview(buttonLikeAct)
        
        let buttonDisLikeAct = UIButton()
        buttonDisLikeAct.frame = CGRect(x: self.imageDislikers.frame.origin.x - 10, y: 5, width: 50, height: 50)
        buttonDisLikeAct.addTarget(self, action: #selector(self.dislikeAction), for: .touchUpInside)
        buttonDisLikeAct.setTitle("", for: .normal)
        self.bottomView.addSubview(buttonDisLikeAct)
        

       
        

       
        buttonComment.addTarget(self, action: #selector(self.openComment), for: .touchUpInside)
        self.bottomView.addSubview(buttonComment)
       
        
    }
    
    
    //COMMENT LAYOUT
    let textviewA = UITextView()
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
    
//   var onecall = false
//    let buttonSort = UIButton()
//    var alreadyOut = false
//    let buttonExpand = UIButton()
//    let buttonMiddleToggle = UIButton()
//    let divideView = UIView()
//    let buttonExitChat = UIButton()
//    func setUpViewchats () {
//
//        alreadyOut = true
//        divideView.frame = CGRect(x: 0, y: 0, width: viewChats.frame.width , height: 50)
//        divideView.backgroundColor = UIColor(red: 0.8863, green: 0.8706, blue: 0.898, alpha: 1.0)
//        divideView.layer.shadowColor = UIColor.gray.cgColor
//        divideView.layer.shadowOpacity = 1
//        divideView.layer.shadowOffset = CGSize.zero
//        divideView.layer.shadowRadius = 2
//        tablerView.frame = CGRect(x: 0, y: 50, width: viewChats.frame.width, height: viewChats.frame.height - 50)
//        self.viewChats.addSubview(divideView)
//
//        buttonExitChat.setTitleColor(UIColor.darkGray, for: .normal)
//        buttonExitChat.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
//        buttonExitChat.setTitle("Exit", for: .normal)
//        buttonExitChat.addTarget(self, action: #selector(self.exitChats), for: .touchUpInside)
//        self.viewChats.addSubview(buttonExitChat)
//
//        buttonSort.frame = CGRect(x: divideView.frame.width - 80, y: 5, width: 40, height: 40)
//        buttonSort.setTitle("", for: .normal)
//       buttonSort.setImage(UIImage(named: "sorti"), for: .normal)
//        buttonSort.addTarget(self, action: #selector(self.sortChats), for: .touchUpInside)
//        self.viewChats.addSubview(buttonSort)
//
//        buttonExpand.frame = CGRect(x: divideView.frame.width - 50, y: 2, width: 45, height: 45)
//        buttonExpand.setImage(UIImage(named: "expanderi"), for: .normal)
//        buttonExpand.setTitle("", for: .normal)
//        self.viewChats.addSubview(buttonExpand)
//        buttonExpand.addTarget(self, action: #selector(self.expand), for: .touchUpInside)
//        self.viewChats.addSubview(buttonMiddleToggle)
//        buttonMiddleToggle.translatesAutoresizingMaskIntoConstraints = false
//        buttonMiddleToggle.centerXAnchor.constraint(equalTo: divideView.centerXAnchor, constant: 0).isActive = true
//        buttonMiddleToggle.topAnchor.constraint(equalTo: divideView.topAnchor, constant: 0).isActive = true
//        buttonMiddleToggle.frame.size.width = 100
//        buttonMiddleToggle.frame.size.height = 50
//        buttonMiddleToggle.tag = 0
//        buttonMiddleToggle.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
//        buttonMiddleToggle.setTitleColor(UIColor.black, for: .normal)
//
//
//
//        buttonMiddleToggle.setTitleColor(.darkGray, for: .normal)
//        buttonMiddleToggle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
//        buttonMiddleToggle.titleLabel?.textAlignment = NSTextAlignment.center
//        buttonMiddleToggle.addTarget(self, action: #selector(self.pressedToggle(sender:)), for: .touchUpInside)
//        if self.onecall == false {
//        self.fetchCommentstop()
//            self.onecall = true
//        }
//    }
    
    //WEBVIEW DELEGATE METHODS ==== web view ====
    
   
    var oneLoad = false
    let loader = UIActivityIndicatorView()
   
  //  var onceRef = false
    
//    @objc func refresh (sender:AnyObject) {
//
//        if onceRef == false {
//            onceRef = true
//        self.comments.removeAll()
//        self.checkArr.removeAll()
//        self.loadAttempts = 1
//        self.tablerView.reloadData()
//            if self.onTop == true {
//        self.fetchCommentstop()
//
//            } else if self.onTop == false {
//                self.sortByTime()
//
//            }
//
//        self.refreshControl.endRefreshing()
//
//        }
//    }
    
    var comments = [Comment]()
   
    //TABLEVIEW DELEGATE METHODS ==== table view =======
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        if section == 0 {
            return 0
        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count + 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
             if let img = self.img {
                           let w = view.frame.size.width
                           let imgw = img.size.width
                           let imgh = img.size.height
                         
                                  
                           return w/imgw*imgh
                   }
        }
        if section == 2 {
            return 0.003
        }
        if section == 1 {
            return 35
        }
        return 25
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0.00001
        }
        if section == 0 {
            return 0.00001
        }
        if section == 2 {
            return 60
        }
        return 60
    }
    
    
    @objc func openProfile (sender:UIButton) {
        if self.comments[sender.tag-3].sender != Auth.auth().currentUser?.uid && self.allowedToGoToProfile == nil {
    let vx: UserViewController? = UserViewController()
    let aObjNavi = UINavigationController(rootViewController: vx!)
    DispatchQueue.main.async {
        aObjNavi.modalPresentationStyle = .fullScreen
        vx!.namer = self.comments[sender.tag-3].senderName
        vx!.theirUid = self.comments[sender.tag-3].sender
        vx!.username = self.comments[sender.tag-3].senderUn
        self.present(aObjNavi, animated: true, completion: nil)
      
    }
        }
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         var imagerBackView = UIImageView()
        if section == 0 {
           if let img = img {
                       imagerBackView = UIImageView(image: img)
                       imagerBackView.contentMode = .scaleAspectFill
                       imagerBackView.clipsToBounds = true
                      
                   }
                   return imagerBackView
        }
        if section == 2 {
            return nil
        }
        if section == 1 {
            let viewit = UIView()
                   viewit.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35)
            let publisher = UIImageView()
            publisher.frame = CGRect(x: 10, y: 5, width: 130, height: 34)
            publisher.contentMode = .scaleAspectFit
            viewit.addSubview(publisher)
            if let url = self.publisherImageUrl {
                if url != "none" {
                 let url2 = URL(string: url)
                publisher.kf.setImage(with: url2)
                }  else {
                              
                               if let pub = self.publisher {
                                   let labelPub = UILabel()
                                              labelPub.frame = CGRect(x: 10, y: 5, width: 250, height: 25)
                                              labelPub.textAlignment = .left
                                              labelPub.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                                   labelPub.font = UIFont(name: "Courier", size: 17)
                                   labelPub.text = pub
                                   viewit.addSubview(labelPub)
                                  
                               }
                           }
            }
           
            let labelTime = UILabel()
            labelTime.frame = CGRect(x: viewit.frame.width - 140, y: 5, width: 124, height: 25)
            labelTime.textAlignment = .right
            labelTime.textColor = .lightGray
            labelTime.font = UIFont(name: "AvenirNext-Medium", size: 17)
            if let timePub = self.timer {
                labelTime.text = timePub
            }
            viewit.addSubview(labelTime)
            
            return viewit
        }
        let viewi = UIView()
        viewi.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25)
        let labelName = UILabel(frame: CGRect(x: 10, y: 5, width: 250, height: 20))
        labelName.font = UIFont(name: "HelveticaNeue", size: 14)
        labelName.textColor = .gray
        labelName.text = "Username,  --"
        let buttonGoToProfile = UIButton()
        buttonGoToProfile.frame = viewi.frame
        buttonGoToProfile.tag = section
        buttonGoToProfile.setTitle("", for: .normal)
        buttonGoToProfile.addTarget(self, action: #selector(self.openProfile(sender:)), for: .touchUpInside)
        if let lasterMess = comments[section-3].time {
            if let usernamer = comments[section-3].senderUn {
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
        viewi.addSubview(buttonGoToProfile)
        return viewi
    }
    
    var numberOfChats = 0;
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        if section == 1 {
            return nil
        }
        if section == 2 {
            let viewb = UIView()
            viewb.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
            let labelChatsCount = UILabel()
            labelChatsCount.frame = CGRect(x: 20, y: 30, width: viewb.frame.width - 40, height: 25)
            labelChatsCount.textColor = .lightGray
            labelChatsCount.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            labelChatsCount.textAlignment = .center
            let devideView = UIView(frame: CGRect(x: 5, y: 15, width: viewb.frame.width - 10, height: 2))
            devideView.backgroundColor = #colorLiteral(red: 1, green: 0.849878788, blue: 0.2974225283, alpha: 0.4466329225)
            devideView.layer.cornerRadius = 6.0
            viewb.addSubview(devideView)
            if numberOfChats == 0 {
            labelChatsCount.text = "Be the first to reply!"
            } else {
                labelChatsCount.text = "See what people are saying below!"
            }
            viewb.addSubview(labelChatsCount)
            return viewb
        }
        let footerFoot = Bundle.main.loadNibNamed("CommentsChatTableViewCell", owner: self, options: nil)?.first as! CommentsChatTableViewCell
        let divideView = UIView()
        divideView.frame = CGRect(x: 5, y: footerFoot.contentView.frame.height - 2, width: footerFoot.frame.width - 20, height: 1)
        divideView.backgroundColor = .lightGray
        footerFoot.addSubview(divideView)
        footerFoot.buttonLikeChat.tag = section
        footerFoot.buttonDislikeChat.tag = section
        
        
        
        footerFoot.labelLikeCount.text = "\(comments[section-3].likes!)"
        footerFoot.labelDislikesCount.text = "\(comments[section-3].dislikes!)"
        footerFoot.repliesButton.setTitle("Replies • \(comments[section-3].replyCount!)", for: .normal)
        footerFoot.buttonLikeChat.addTarget(self, action: #selector(self.clickedCommentUp), for: .touchUpInside)
        footerFoot.repliesButton.tag = section
        footerFoot.buttonDislikeChat.addTarget(self, action: #selector(self.clickedCommendDown), for: .touchUpInside)
        footerFoot.repliesButton.addTarget(self, action: #selector(self.clickedGesture(sender:)), for: .touchUpInside)
        // "Replies • 12"
        if self.clickedArray.contains(section-3) {
            footerFoot.buttonLikeChat.setImage(UIImage(named: "blueLike"), for: .normal)
        } else {
            footerFoot.buttonLikeChat.setImage(UIImage(named: "up1"), for: .normal)
        }
        if self.disClickedArray.contains(section-3) {
            footerFoot.buttonDislikeChat.setImage(UIImage(named: "blueDis"), for: .normal)
        } else {
            footerFoot.buttonDislikeChat.setImage(UIImage(named: "down1"), for: .normal)
        }
        
        if let likedOrDis = comments[section-3].youLikeDis {
            if likedOrDis == "Liked" {
                 footerFoot.buttonLikeChat.setImage(UIImage(named: "blueLike"), for: .normal)
                 clickedArray.append(section-3)
            }
            if likedOrDis == "Disliked" {
                 footerFoot.buttonDislikeChat.setImage(UIImage(named: "blueDis"), for: .normal)
                disClickedArray.append(section-3)
            }
        } else {
            footerFoot.buttonLikeChat.setImage(UIImage(named: "up1"), for: .normal)
            footerFoot.buttonDislikeChat.setImage(UIImage(named: "down1"), for: .normal)
        }
    
       
        
        
        
        return footerFoot
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSelected", for: indexPath) as! CommentsChatTableViewCell
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                   let cell = tablerView.dequeueReusableCell(withIdentifier: "cellTopArt", for: indexPath) as! SelArtTableViewCell
                   
                   cell.textviewet.text = titleLer
                   return cell
                       }
                       let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSecoArt", for: indexPath) as! SelArt2TableViewCell
                       
                       cell.textviewet.text = descrpi
                       return cell
        }
        
      
        
        if indexPath.section == 2 {
            let cell2 = tablerView.dequeueReusableCell(withIdentifier: "cell2Comment", for: indexPath) as! AddCommentTopTableViewCell
            cell2.setUpClicks()
            cell2.gesture.addTarget(self, action: #selector(self.doChatOpenFromChat), for: .touchUpInside)
            return cell2
        }
        if indexPath.section == 0 {
            let cell = tablerView.dequeueReusableCell(withIdentifier: "cellNoneArt", for: indexPath) as! nonethingCell
            return cell
        }
        if indexPath.section > 2 {
             cell.textviewet.text = comments[indexPath.section-3].message
        }
        
       
        return cell
    }
    
    
    var repostedAlready = false
    @objc func openShare () {
        let alert = UIAlertController()
        alert.title = "Actions"
        let action1 = UIAlertAction(title: "Add to someone's feed", style: .default) {  (alert : UIAlertAction) -> Void in
            
                let vc = AddToFeedSendToViewController()
                vc.url = self.urlToLoad
                vc.publisher = self.publisher
                vc.modalPresentationStyle = .fullScreen
                vc.key = self.aid
            if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isAnonymous == false  {
                self.present(vc, animated: true, completion: nil)
            } else {
                let alertMore = UIAlertController(title: "Error!", message: "Sorry you cannot share, repost, or add articles to anyone's feeds. You must create or sign into an account to do that.", preferredStyle: .alert)
                let cancel2 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                
                alertMore.addAction(cancel2)
                self.present(alertMore, animated: true, completion: nil)
            }
            }
        let action2 = UIAlertAction(title: "Repost", style: .default) {  (alert : UIAlertAction) -> Void in
            
            let alertMore = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
             let actionCap = UIAlertAction(title: "Yes", style: .default) {  (alert : UIAlertAction) -> Void in
                let alertController = UIAlertController(title: "Add a caption", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Enter a caption..."
                    textField.autocorrectionType = .default
                    textField.keyboardType = .twitter
                    textField.keyboardAppearance = .dark
                    textField.autocapitalizationType = .sentences
                    textField.tintColor = .blue
                }
                let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
                
                subview.backgroundColor = UIColor(red: 0.0275, green: 0, blue: 0, alpha: 1.0)
                
                alertController.view.tintColor = UIColor.white
                let attributedString = NSAttributedString(string: "Add a caption", attributes: [
                    NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 18)!, //your font here
                    NSAttributedString.Key.foregroundColor : UIColor.white
                    ])
                alertController.setValue(attributedString, forKey: "attributedTitle")
                
                
                
                let saveAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { alert -> Void in
                    let firstTextField = alertController.textFields![0] as UITextField
                    if let text = firstTextField.text {
                        if text.count < 150 {
                            if let key = self.aid {
                        if let myUid = Auth.auth().currentUser?.uid {
                            if let url = self.urlToLoad {
                                
                                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                let ref = Database.database().reference().child("users").child(myUid).child("Reposts")
                                
                                let update: [String : Any] = ["timeSent" : timeStamp, "url" : url, "aid" : key, "typeSent" : "repost", "caption" : text]
                                let lastUpd = [key : update]
                                
                                ref.updateChildValues(lastUpd)
                                self.dismiss(animated: true, completion: nil)
                                if self.repostedAlready == false {
                                    self.splitRepostSendToFollowers()
                                    self.repostedAlready = true
                                }
                            }
                        }
                        }
                        }
                    }
                    
                })
                let cancelActor = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                saveAction.setValue(UIColor.blue, forKey: "titleTextColor")
                alertController.addAction(saveAction)
                alertController.addAction(cancelActor)
                if Auth.auth().currentUser?.isAnonymous == false {
                self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertMore6 = UIAlertController(title: "Error!", message: "Sorry you cannot share, repost, or add articles to feeds. You must create or sign into an account to do that.", preferredStyle: .alert)
                    let cancel4 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    
                    alertMore6.addAction(cancel4)
                    self.present(alertMore6, animated: true, completion: nil)
                }
            }
            let cancel2 = UIAlertAction(title: "Nope", style: .cancel){  (alert : UIAlertAction) -> Void in
                if let key = self.aid {
                     if Auth.auth().currentUser?.isAnonymous == false {
                    if let myUid = Auth.auth().currentUser?.uid {
                        if let url = self.urlToLoad {
                            
                            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                            let ref = Database.database().reference().child("users").child(myUid).child("Reposts")
                            
                            let update: [String : Any] = ["timeSent" : timeStamp, "url" : url, "aid" : key, "typeSent" : "repost"]
                            let lastUpd = [key : update]
                            
                            ref.updateChildValues(lastUpd)
                            self.dismiss(animated: true, completion: nil)
                            if self.repostedAlready == false {
                                self.splitRepostSendToFollowers()
                                self.repostedAlready = true
                            }
                        }
                        }
                    } else {
                        let alertMore = UIAlertController(title: "Error!", message: "Sorry you cannot share, repost, or add articles to feeds. You must create or sign into an account to do that.", preferredStyle: .alert)
                        let cancel2 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                        
                        alertMore.addAction(cancel2)
                        self.present(alertMore, animated: true, completion: nil)
                        
                    }
                    
                    
                }
            }
            let attributedString2 = NSAttributedString(string: "Add caption with this repost?", attributes: [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 18)!, //your font here
                NSAttributedString.Key.foregroundColor : UIColor.black
                ])
            alertMore.setValue(attributedString2, forKey: "attributedTitle")
            
            let cancel3 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            cancel3.setValue(UIColor.red, forKey: "titleTextColor")
            
           
           // alertMore.setValue(UIFont(name: "<#T##String#>", size: <#T##CGFloat#>), forKey: <#T##String#>)
            alertMore.addAction(cancel2)
            alertMore.addAction(actionCap)
            alertMore.addAction(cancel3)
            
            self.present(alertMore, animated: true, completion: nil)
            
             
          
        }
        
        let action3 = UIAlertAction(title: "Send to", style: .default) {  (alert : UIAlertAction) -> Void in
            
            let vc = AddToFeedSendToViewController()
            vc.url = self.urlToLoad
            vc.publisher = self.publisher
            vc.modalPresentationStyle = .fullScreen
            vc.key = self.aid
            vc.type = "send"
            if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isAnonymous == false  {
            self.present(vc, animated: true, completion: nil)
            } else {
                let alertMore = UIAlertController(title: "Error!", message: "Sorry you cannot share, repost, or add articles to feeds. You must create or sign into an account to do that.", preferredStyle: .alert)
                let cancel2 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                
                alertMore.addAction(cancel2)
                self.present(alertMore, animated: true, completion: nil)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertDev =  UIAlertAction(title: "Notify", style: .default){  (alert : UIAlertAction) -> Void in
            if self.textviewA.text == "Gavin" || self.textviewA.text == "Tom" {
                let ref = Database.database().reference()
                if let aid = self.aid {
                    let refi = ref.child("Feed").child(aid)
                    let updateRec = ["highlighted" : "highlighted"]
                    refi.updateChildValues(updateRec)
                }
            }
                   }
                   
        if Auth.auth().currentUser?.uid == "6uJeXmeIn8cEERhG93Bk07B47Y03" || Auth.auth().currentUser?.uid == "fjYmghE8jzY16TMR3PqpG6d4kF12" {
        alert.addAction(alertDev)
        }
        
        alert.addAction(cancel)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action1)
        
        
            self.present(alert, animated: true, completion: nil)
    }
    
    func splitRepostSendToFollowers () {
        if let uid = Auth.auth().currentUser?.uid  {
             if Auth.auth().currentUser?.isAnonymous == false {
        let dref = Database.database().reference().child("users").child(uid).child("followers")
        dref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let followers = snapshot.value as? [String : String] {
                for (_,one) in followers {
                    let radOne = Int.random(in: 2..<4)
                    if radOne == 3 {
                        if let url = self.urlToLoad {
                            if let key = self.aid {
                                if let myUid = Auth.auth().currentUser?.uid {
                                    if let myName = Auth.auth().currentUser?.displayName {
                                        if myUid != one {
                                        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                        let ref = Database.database().reference().child("users").child(one).child("Feed")
                                        
                                        let update: [String : Any] = ["sentBy" : myUid, "sentFrom" : myName, "timeSent" : timeStamp, "url" : url, "aid" : key, "typeSent" : "repost"]
                                        let lastUpd = [key : update]
                                        
                                        
                                        
                                        ref.updateChildValues(lastUpd)
                                        let refRecievedRepost = Database.database().reference().child("users").child(one)
                                        let updateRec = ["repostRecieved" : timeStamp]
                                        refRecievedRepost.updateChildValues(updateRec)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.titleOfAnimate = "Article Reposted!"
                self.animateRepost()
            } else {
                self.titleOfAnimate = "Article Reposted!"
                self.animateRepost()
            }
        })
        
            }
        }
        
    }
    
    
//    @objc func sortChats () {
//        let alert = UIAlertController()
//        alert.title = "Sort Comments"
//        let action1 = UIAlertAction(title: "Sort by new", style: .default) {  (alert : UIAlertAction) -> Void in
//            if self.onTop == true {
//            self.comments.removeAll()
//            self.tablerView.reloadData()
//            self.checkArr.removeAll()
//            self.loadAttempts = 1
//            self.sortByTime()
//            self.onTop = false
//            }
//        }
//        let action2 = UIAlertAction(title: "Sort by top", style: .default) {  (alert : UIAlertAction) -> Void in
//            if self.onTop == false {
//            self.comments.removeAll()
//            self.tablerView.reloadData()
//            self.checkArr.removeAll()
//            self.loadAttempts = 1
//            self.fetchCommentstop()
//            self.onTop = true
//            }
//        }
//
//
//
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//
//        alert.addAction(cancel)
//        alert.addAction(action2)
//        alert.addAction(action1)
//
//
//        self.present(alert, animated: true, completion: nil)
//    }
  
    @IBOutlet weak var tablerView: UITableView!
    
  
    var commentOpen = false
    let commentingView = UIView()
    @objc func openComment () {
        if Auth.auth().currentUser?.uid != nil  && Auth.auth().currentUser?.isAnonymous == false {
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        return numberOfChars < 561
    }
   
    @objc func openInfo () {
//        if let url = self.urlToLoad {
//            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
//            return
//        }
        self.openSafari()
       // self.performSegue(withIdentifier: "segueInfo", sender: self)
    }
    var changedShit = false
    var whatOn = "None"
    @objc func likeAction () {
        changedShit = true
        if whatOn == "None" {
        self.imageLiker.image = UIImage(named: "blueLike")
        self.imageViewLikesi.image =  UIImage(named: "blueLike")
        self.labelLikesCount.textColor = UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
        self.labelLikesCount.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
        self.whatOn = "Like"
        self.likesCount+=1
        self.labelLikesCount.text = "\(self.likesCount)"
            return
        }
        if whatOn == "Like" {
            
            self.imageLiker.image = #imageLiteral(resourceName: "up1")
            self.imageViewLikesi.image = #imageLiteral(resourceName: "up1")
            self.whatOn = "None"
            self.labelLikesCount.textColor = .gray
            self.labelLikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
            self.likesCount-=1
            self.labelLikesCount.text = "\(self.likesCount)"
            return
        }
        if whatOn == "Dislike" {
            self.imageLiker.image =  UIImage(named: "blueLike")
            self.imageViewLikesi.image =  UIImage(named: "blueLike")
            self.imageDislikers.image = #imageLiteral(resourceName: "down1")
            self.imageviewDislikes.image = #imageLiteral(resourceName: "down1")
            self.labelLikesCount.textColor = UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
            self.labelLikesCount.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
            self.labelDislikesCount.textColor = .gray
            self.labelDislikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
            self.dislikesCount-=1
            self.likesCount+=1
            self.labelDislikesCount.text = "\(dislikesCount)"
            self.labelLikesCount.text = "\(likesCount)"
            self.whatOn = "Like"
            return
        }
        
    }
    
    @objc func dislikeAction () {
        changedShit = true
        if whatOn == "None" {
            self.imageDislikers.image =  UIImage(named: "blueDis")
            self.imageviewDislikes.image =  UIImage(named: "blueDis")
            self.labelDislikesCount.textColor = UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
                //UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0)
            self.labelDislikesCount.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
            self.dislikesCount+=1
            self.labelDislikesCount.text = "\(dislikesCount)"
            self.whatOn = "Dislike"
            return
        }
        if whatOn == "Dislike" {
            
            self.imageDislikers.image = #imageLiteral(resourceName: "down1")
            self.imageviewDislikes.image = #imageLiteral(resourceName: "down1")
            self.labelDislikesCount.textColor = .gray
            self.labelDislikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
            self.dislikesCount-=1
            self.labelDislikesCount.text = "\(self.dislikesCount)"
            self.whatOn = "None"
            return
        }
        if whatOn == "Like" {
            self.imageDislikers.image =  UIImage(named: "blueDis")
            self.imageviewDislikes.image = UIImage(named: "blueDis")
            self.imageLiker.image = #imageLiteral(resourceName: "up1")
            self.imageViewLikesi.image = #imageLiteral(resourceName: "up1")
            self.labelDislikesCount.textColor = UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
            self.labelDislikesCount.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
            self.labelLikesCount.textColor = .gray
            self.labelLikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
            self.likesCount-=1
            self.dislikesCount+=1
            self.labelLikesCount.text = "\(likesCount)"
            self.labelDislikesCount.text = "\(dislikesCount)"
            self.whatOn = "Dislike"
            return
        }
    }
    
    @objc func pushedBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
   

  
    var img :UIImage?
    
    @objc func clickedGesture (sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "replyVc") as! SelectedCommentViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        if self.aid != nil {
            vc.commentId = comments[sender.tag - 3].key!
            vc.replyCount = comments[sender.tag-3].replyCount!
            vc.commentLike = comments[sender.tag-3].likes
            vc.commentDislike = comments[sender.tag-3].dislikes
            vc.commentTime = comments[sender.tag-3].time
            vc.commenter = comments[sender.tag-3].message
            vc.commentUn = comments[sender.tag-3].senderUn
            vc.publisher = self.publisher
            vc.urlToLoad = self.urlToLoad
            if let likedOrDis = self.comments[sender.tag-3].youLikeDis {
             vc.selectedLikeOrDislike = likedOrDis
            }
        vc.aid = self.aid
            
        }
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @objc func doChatOpenFromChat () {
        self.openSafari()
    }
    
    @objc func clickedCommentUp(sender: UIButton) {
        print(sender.tag)
        if clickedArray.contains( where: { $0 == sender.tag-3} ){
            print("ik")
            clickedArray = clickedArray.filter { $0 != (sender.tag-3) }
            if let aid = self.aid {
                if let uid = Auth.auth().currentUser?.uid {
                    let id = comments[sender.tag - 3].key!
                    let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(id).child("likes").child(uid)
                    ref.removeValue()
                     self.comments[sender.tag - 3].youLikeDis = nil
                    if let likes = self.comments[sender.tag-3].likes {
                        self.comments[sender.tag-3].likes = likes - 1
                    }
                }
            }
         
            
        } else {
        clickedArray.append(sender.tag-3)
            let id = comments[sender.tag - 3].key!
            if inQueueArray.contains(id) {
                
            } else {
                let likesi = comments[sender.tag - 3].likes!
                
                let userKey = comments[sender.tag-3].userKey!
                self.comments[sender.tag - 3].youLikeDis = "Like"
                if let likes = self.comments[sender.tag-3].likes {
                               self.comments[sender.tag-3].likes = likes + 1
                               }
                   let sender = comments[sender.tag-3].sender!
                
                queue(id: id, type: "Like", key: id, likes: likesi, senderId: sender, userKey: userKey)
              
                
                
             
            }
        }
        disClickedArray = disClickedArray.filter { $0 != (sender.tag-3) }
    }
    
    var disClickedArray = [Int]()
    @objc func clickedCommendDown(sender: UIButton) {
        if disClickedArray.contains( where: { $0 == sender.tag-3} ){
            print("ik")
            disClickedArray = disClickedArray.filter { $0 != (sender.tag-3) }
            if let aid = self.aid {
                if let uid = Auth.auth().currentUser?.uid {
            let id = comments[sender.tag - 3].key!
            let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(id).child("dislikes").child(uid)
                    ref.removeValue()
                    self.comments[sender.tag - 3].youLikeDis = nil
                    if let likes = self.comments[sender.tag-3].dislikes {
                                   self.comments[sender.tag-3].dislikes = likes - 1
                                   }
            }
            }
           
        } else {
            disClickedArray.append(sender.tag-3)
            let id = comments[sender.tag - 3].key!
            if inQueueArray.contains(id) {
                
            } else {
                let likes = 0
                 let userKey = comments[sender.tag-3].userKey!
                self.comments[sender.tag - 3].youLikeDis = "Dislike"
                if let likes = self.comments[sender.tag-3].dislikes {
                   self.comments[sender.tag-3].dislikes = likes + 1
                          }
                           
                let sender = comments[sender.tag-3].sender!
               
            queue(id: id, type: "Dislike", key: id, likes: likes, senderId: sender, userKey: userKey)
             
            }
        }
       clickedArray = clickedArray.filter { $0 != (sender.tag-3) }
    }
    
    
    //cool little sequenced queded function try, might fail whatever
    var inQueueArray = [""]
    func queue (id: String, type: String, key: String, likes: Int, senderId: String, userKey: String) {
        inQueueArray.append(id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            if let uid = Auth.auth().currentUser?.uid {
                
                if let aid = self.aid {
                    if type == "Like" {
                    let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(key).child("likes")
                    let refDis = Database.database().reference().child("artItems").child(aid).child("comments").child(key).child("dislikes").child(uid)
                        let feeder: [String : Any] = [uid : "like"]
                        ref.updateChildValues(feeder)
                        refDis.removeValue()
                        if senderId != Auth.auth().currentUser?.uid {
                        self.sendNotif(theirUid: senderId, userkey: userKey, comId: key, type: "like")
                        }
                       self.inQueueArray = self.inQueueArray.filter { $0 != (id) }
                    } else {
                         let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(key).child("dislikes")
                          let refLik = Database.database().reference().child("artItems").child(aid).child("comments").child(key).child("likes").child(uid)
                        let feeder: [String : Any] = [uid : "dislike"]
                        ref.updateChildValues(feeder)
                        refLik.removeValue()
                        self.inQueueArray = self.inQueueArray.filter { $0 != (id) }
                        
                    }
                }
            }
            if likes > 18 {
                
                //give star :D
                if type == "Like" {
                      if let uid = Auth.auth().currentUser?.uid  {
                let update = [key : uid]
                let refThem = Database.database().reference().child("users").child(senderId).child("stars")
                refThem.updateChildValues(update)
                
                    
                    }
                }
            }
            
        })
    }
  
    
    var labelAvg = UILabel()
    let sublay = CALayer()
    let thumb = CALayer.init()
    let shapeLayer = CAShapeLayer()
     let tgl = CAGradientLayer()
    func setSlider(slider:UISlider) {
        
       print("set slider cllled")
        let frame = slider.bounds
        tgl.frame = frame
        
        tgl.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.red.cgColor]
        
        tgl.borderWidth = 1.0
        tgl.borderColor = UIColor.gray.cgColor
        tgl.cornerRadius = 4.0
        tgl.masksToBounds = true
        tgl.endPoint = CGPoint(x: 1.0, y: 1.0)
        tgl.startPoint = CGPoint(x: 0.0, y:  1.0)
        
        
        sublay.frame = CGRect(x: slider.thumbCenterX - 5, y: 0, width: 10, height: uislideer.frame.height)
        sublay.backgroundColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
        tgl.addSublayer(sublay)
        
        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, false, 0.0)
        tgl.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
        slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
        
        
      //  slider.thumbTintColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0)
        
        
        let layerFrame = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        thumb.frame = layerFrame

        let frame2 = CGRect(x: 1, y: 1, width: 28, height: 28)
        shapeLayer.path = CGPath(rect: frame2, transform: nil)
        shapeLayer.fillColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
    
        shapeLayer.cornerRadius = 15.0
        //shapeLayer.masksToBounds = true
        thumb.addSublayer(shapeLayer)

        thumb.borderColor = UIColor.black.cgColor
        thumb.borderWidth = 1.0
        thumb.cornerRadius = 15.0
        thumb.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
        
        thumb.render(in: UIGraphicsGetCurrentContext()!)
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        


        slider.setThumbImage(thumbImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .highlighted)
    
        
    }
   
    
    
    let viewChats = UIView()
    @objc func openChats () {
//        guard alreadyOut == false else {
//            return
//        }
//       viewChats.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
//        self.view.addSubview(viewChats)
//        viewChats.backgroundColor = UIColor(red: 0.9608, green: 0.9569, blue: 0.9882, alpha: 1.0)
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
//            self.viewChats.frame = CGRect(x: 0, y: self.view.frame.height / 3.1, width: self.view.frame.width, height: self.view.frame.height - self.view.frame.height / 3.1)
//            }, completion: nil)
//        setUpViewchats()
        let indexpath = IndexPath(row: 0, section: 2)
        tablerView.scrollToRow(at: indexpath, at: .top, animated: true)
    }
   
    
//   @objc func exitChats () {
//    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
//        self.viewChats.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
//    }, completion: { finished in
//        self.viewChats.removeFromSuperview()
//
//        self.buttonExitChat.removeFromSuperview()
//        self.buttonMiddleToggle.removeFromSuperview()
//        self.divideView.removeFromSuperview()
//        self.buttonExpand.removeFromSuperview()
//    })
//    alreadyOut = false
//
//    }
//
    @objc func pressedToggle (sender: UIButton)  {
      print("pressed")
    }
//    var sizeFull = false
//    @objc func expand() {
//        if sizeFull == false {
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
//            self.viewChats.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
//            if UIDevice().userInterfaceIdiom == .phone {
//                switch UIScreen.main.nativeBounds.height {
//
//                case 2436:
//                    print("iPhone X, XS")
//
//                     self.viewChats.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 20)
//                case 2688:
//                    print("iPhone XS Max")
//                    self.viewChats.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 20)
//                case 1792:
//                    print("iPhone XR")
//                     self.viewChats.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 20)
//                default:
//                    print("Unknown")
//                }
//            }
//            self.tablerView.frame = CGRect(x: 0, y: 50, width: self.viewChats.frame.width, height: self.viewChats.frame.height - 50)
//        }, completion: nil)
//
//        sizeFull = true
//        buttonExpand.setImage(UIImage(named: "collapser"), for: .normal)
//        } else {
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
//                self.viewChats.frame = CGRect(x: 0, y: self.view.frame.height / 3.1, width: self.view.frame.width, height: self.view.frame.height - self.view.frame.height / 3.1)
//                self.tablerView.frame = CGRect(x: 0, y: 50, width: self.viewChats.frame.width, height: self.viewChats.frame.height - 50)
//            }, completion: nil)
//            sizeFull = false
//            buttonExpand.setImage(UIImage(named: "expanderi"), for: .normal)
//        }
//    }
    var changedBiasForRefresh = false
    var coloredOrange = false
    @objc func movedSlider () {
        print("slider moved")
         changedBias = true
        changedBiasForRefresh = true
        if coloredOrange == false {
           
           
        shapeLayer.fillColor =  UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0).cgColor


        self.labelBiasCount.textColor = UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0)
            self.labelBiasCount.font = UIFont(name: "HelveticaNeue-Medium", size: 12)

        UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)

        thumb.render(in: UIGraphicsGetCurrentContext()!)
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        uislideer.setThumbImage(thumbImage, for: .normal)
        uislideer.setThumbImage(thumbImage, for: .highlighted)
            coloredOrange = true
             self.labelBiasCount.text = "\(self.biasVotes+1) votes"
        }
    }
    
    var avgbias = 0;
    var keyAll = ""
    func grabBias () {
        let ref = Database.database().reference()
        if let aid = self.aid {
            
        ref.child("Feed").child(aid).child("bias").observeSingleEvent(of: .value, with: {(snapshot) in
            if let val = snapshot.value as? String {
                 let valInt:Float = Float(val)!
               
                    self.uislideer.setValue(valInt, animated: true)
                print("\(self.uislideer.value) slider val grabbi \(valInt)")
                    if valInt <= 1.7 && valInt >= -1.7 {
                    self.labelAvg.frame = CGRect(x: self.uislideer.thumbCenterX-18, y: self.shawdowView2.frame.height - 42, width: 40, height: 15)
                        print("setup avglbl")
                    } else {
                    self.labelAvg.isHidden = true
                    }
                
                
               
                    let inty = roundf(valInt)
                    let newInty = Int(inty)
                self.avgbias = newInty
                
                
                
                let slider = self.uislideer
                self.sublay.frame = CGRect(x: slider.thumbCenterX - 16, y: 0, width: 10, height: self.uislideer.frame.height)
                self.sublay.backgroundColor = UIColor(red: 0.8431, green: 0.8784, blue: 0.9569, alpha: 1.0).cgColor
                self.tgl.addSublayer(self.sublay)
                
                UIGraphicsBeginImageContextWithOptions(self.tgl.frame.size, false, 0.0)
                self.tgl.render(in: UIGraphicsGetCurrentContext()!)
                let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                
                slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
                slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
                
                
                
                
            }
            self.grabYourBias()
           
        })
        
       
            
        }
    }
    var totalViews = 0;
    func viewUpdate ()  {
        if let aid = self.aid {
        let refer = Database.database().reference().child("Feed").child(aid).child("views")
        refer.observeSingleEvent(of: .value, with: {(snapi) in
            if let value = snapi.value as? String {
                if let inty = Int(value) {
                    let oneMore = inty + 1
                    self.totalViews = oneMore
                    let refFinal = Database.database().reference().child("Feed").child(aid)
                    let final: [String : String] = ["views" : String(oneMore)]
                    refFinal.updateChildValues(final)
                    print("adding one!")
                    return
                }
            }
        })

        }
    }
    
    
    
    
    func grabYourBias () {
        if let aid = self.aid {
            if let personalBias = self.personalBias {
               uislideer.setValue(personalBias, animated: true)
                shapeLayer.fillColor =  UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0).cgColor
                
                
                self.labelBiasCount.textColor = UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0)
                self.labelBiasCount.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
                
                UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
                
                thumb.render(in: UIGraphicsGetCurrentContext()!)
                let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                uislideer.setThumbImage(thumbImage, for: .normal)
                uislideer.setThumbImage(thumbImage, for: .highlighted)
                
                self.biasAllow = true
                self.uislideer.isUserInteractionEnabled = true
                 self.viewl.removeGestureRecognizer(gestureCantRateBias)
                self.coloredOrange = true
                 self.changedBiasForRefresh = true
                print(personalBias)
            } else {
            if let uid = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference().child("artItems").child(aid).child("biasVotes").child(uid)
            dbRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? NSNumber {
                    self.uislideer.value = value.floatValue
                    self.shapeLayer.fillColor =  UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0).cgColor
                    
                    
                    self.labelBiasCount.textColor = UIColor(red: 0.9569, green: 0.5569, blue: 0, alpha: 1.0)
                    self.labelBiasCount.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
                    
                    UIGraphicsBeginImageContextWithOptions(self.thumb.frame.size, false, 0.0)
                    
                    self.thumb.render(in: UIGraphicsGetCurrentContext()!)
                    let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    self.biasAllow = true
                    self.uislideer.isUserInteractionEnabled = true
                     self.viewl.removeGestureRecognizer(self.gestureCantRateBias)
                    self.uislideer.setThumbImage(thumbImage, for: .normal)
                    self.uislideer.setThumbImage(thumbImage, for: .highlighted)
                    self.coloredOrange = true
                     self.changedBiasForRefresh = true
                } else {
                    self.coloredOrange = false
                }
                
            })
            }
            }
            self.doneRef = false
            
            self.refreshBiasVotes.endRefreshing()
        }
       
    }
    
    var biasVotes = 0
    func grabBiasCount () {
      
        if let aid = self.aid {
        let dbRef = Database.database().reference().child("artItems").child(aid).child("biasVotes")
        dbRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapsho = snapshot.value as? [String:AnyObject] {
                self.labelBiasCount.text = "\(snapsho.count) votes"
                self.biasVotes = snapsho.count
            } else {
                self.labelBiasCount.text = "0 votes"
                
            }
        })
        }
    }
    var likesCount = 0
    var dislikesCount = 0
    
    func grabLikeDislike () {
        if let aid = self.aid {
        let upDateRef = Database.database().reference().child("Feed").child(aid)
        let ref = Database.database().reference().child("artItems").child(aid).child("likeArray")
        let refDis = Database.database().reference().child("artItems").child(aid).child("dislikeArray")
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let likes = snapshot.value as? [String : AnyObject] {
                    refDis.observeSingleEvent(of: .value, with: {(snap) in
                        if let dislikes = snap.value as? [String : AnyObject] {
                            let total:Float = Float(dislikes.count + likes.count)
                            let likesi:Float = Float(likes.count)
                           //CGRect(x: shawdowView1.frame.width - 150, y: 0, width: 140, height: 8)
                            let ratio:Float = Float(likesi / total)
                            self.centerLabel.text = "\(Int(ratio * 100))% Liked"
                            
                            let sumser = Float(self.view.frame.width - 30)
                            let xset = ratio * sumser
                            let newSize = CGFloat(sumser - xset)
                            self.topViewDislikes.frame = CGRect(x: self.shawdowView1.frame.width - newSize - 15, y: 0, width: newSize, height: 8)
                            self.labelDislikesCount.text = "\(dislikes.count)"
                            self.dislikesCount = self.dislikesCount + dislikes.count
                            self.topview.backgroundColor = UIColor(red: 0.3647, green: 0.7294, blue: 0, alpha: 1.0)
                            let finalRat:Float = Float(ratio * 100)
                            let feedo: [String : Any] = ["ratio" : "\(finalRat)"]
                            upDateRef.updateChildValues(feedo)
                        } else {
                            self.topview.backgroundColor = UIColor(red: 0.3647, green: 0.7294, blue: 0, alpha: 1.0)
                            self.centerLabel.text = "100% Liked"
                            self.labelDislikesCount.text = "0"
                            let ratio = Float(100)
                            let feedo: [String : Any] = ["ratio" : "\(ratio)"]
                            upDateRef.updateChildValues(feedo)
                        }
                        self.labelLikesCount.text = "\(likes.count)"
                        self.likesCount = likes.count + self.likesCount
                    })
                } else {
                    self.labelLikesCount.text = "0"
                    
                    refDis.observeSingleEvent(of: .value, with: {(snapi) in
                        if let dislikes = snapi.value as? [String : AnyObject] {
                            self.labelDislikesCount.text = "\(dislikes.count)"
                            self.dislikesCount = self.dislikesCount + dislikes.count
                            self.topViewDislikes.frame = CGRect(x: 0, y: 0, width: self.topview.frame.width, height: 8)
                             self.centerLabel.text = "0% Liked"
                        } else {
                             self.topview.backgroundColor = UIColor(red: 0.3647, green: 0.7294, blue: 0, alpha: 1.0)
                          
                            self.labelDislikesCount.text = "0"
                            self.centerLabel.text = "100% Liked"
                           
                            
                        }
                    })
                  
                }
                
            })
        
            
        }
    }
    
    
    func grabYourLike () {
        if let personalLike = self.personLikeDis {
            if personalLike == "Like" {
                self.labelLikesCount.textColor = UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
                self.labelLikesCount.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
                self.imageViewLikesi.image = UIImage(named: "blueLike")
                self.imageviewDislikes.image = #imageLiteral(resourceName: "down1")
                self.labelDislikesCount.textColor = .lightGray
                self.labelDislikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
                self.imageLiker.image = UIImage(named: "blueLike")
                self.whatOn = "Like"
            }
            if personalLike == "Dislike" {
                self.labelDislikesCount.textColor = UIColor(red: 1, green: 0.7608, blue: 0.1882, alpha: 1.0)
                self.labelDislikesCount.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
                self.imageviewDislikes.image = UIImage(named: "blueDis")
                self.imageViewLikesi.image = #imageLiteral(resourceName: "up1")
                self.labelLikesCount.textColor = .lightGray
                self.imageDislikers.image = UIImage(named: "blueDis")
                self.labelLikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
                self.whatOn = "Dislike"
            }
            if personalLike == "None" {
                self.labelDislikesCount.textColor = .lightGray
                self.labelDislikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
                self.imageviewDislikes.image = #imageLiteral(resourceName: "down1")
                self.imageViewLikesi.image = #imageLiteral(resourceName: "up1")
                self.labelLikesCount.textColor = .lightGray
                self.labelLikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
                self.whatOn = "None"
            }
        } else {
            self.labelDislikesCount.textColor = .lightGray
            self.labelDislikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
            self.imageviewDislikes.image = #imageLiteral(resourceName: "down1")
            self.imageViewLikesi.image = #imageLiteral(resourceName: "up1")
            self.labelLikesCount.textColor = .lightGray
            self.labelLikesCount.font = UIFont(name: "HelveticaNeue", size: 11)
        }
    }
    
    var changedBias = false
  

    
    //comenting database stuffffffffff
    var oncep = false
    @objc func postComment() {
        if let message = self.textviewA.text {
            if message.count > 2 {
                let string1 = message.lowercased()
                if  string1.contains("penis") || string1.contains("vagina")  || string1.contains(" fag") || string1.contains("anal")  || string1.contains("cunt") ||  string1.contains("porn") || string1.contains("nigger") || string1.contains("beaner") || string1.contains(" coon ") || string1.contains("spic") || string1.contains("wetback") || string1.contains("chink") || string1.contains("gook") ||  string1.contains("twat") || string1.contains(" darkie ") || string1.contains("god hates") || string1.contains("    ") ||  string1.contains("nigga") || string1.contains("kike")
                    
                {
                    let alertMore = UIAlertController(title: "Error!", message: "This has a word or character that violates our comments policy. Please remove any vulgar words or characters, then post the comment (:", preferredStyle: .alert)
                    let cancel2 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    
                    alertMore.addAction(cancel2)
                    self.present(alertMore, animated: true, completion: nil)
                    return
                } else {
        let time = Int(NSDate().timeIntervalSince1970)
                    var myUserKey = " "
                    if let myKey = UserDefaults.standard.value(forKey: "userKey") as? String {
                        myUserKey = myKey
                    }
        if self.oncep == false {
            self.oncep = true
            if let aid = self.aid {
        if let uid = Auth.auth().currentUser?.uid {
             if Auth.auth().currentUser?.isAnonymous == false {
            if let myName = Auth.auth().currentUser?.displayName {
                let ref = Database.database().reference()
            
                 if let mySavedUn = UserDefaults.standard.value(forKey: "username") as? String {
                    
                    
                    
                let key = ref.child("artItems").child(aid).child("comments").childByAutoId().key
                    let feedLi = ["message" : message, "userKey" : myUserKey, "sender" : uid, "senderUn" : mySavedUn, "timeStamp" : time, "senderName" : myName, "key" : key!, "likeCount" : 0, "replyCount" : 0, "likes" : ["none" : "none"], "dislikes" : ["none" : "none"]] as [String : Any]
                let mySetup = [key : feedLi]
            
                ref.child("artItems").child(aid).child("comments").updateChildValues(mySetup)
                    self.oncep = false
            
               self.textviewA.text = ""
                self.closeComment()
                    self.titleOfAnimate = "Posted Comment!"
                    self.animateRepost()
                    self.updateFeedCom()
               // sendNotification()
                }
            }
                }
                }
            }
            }
                }
            }
        }
        }
    
    func updateFeedCom () {
       
        if let aid = self.aid {
            let ref = Database.database().reference().child("Feed").child(aid)
            let update = ["comCount" : "1"]
            ref.updateChildValues(update)
        }
    }
    
    var waitForInitial = false
   var onTop = true
var working = false
    var checkArr = [String]()
    var loadAttempts = 1
    func fetchCommentstop () {
        if self.waitForInitial == true {
        var reloadBcAdd = false
        if self.working == false {
            self.working = true
        let times = 10 * loadAttempts
        if let aid = self.aid {
            if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("artItems").child(aid).child("comments")
                ref.queryLimited(toLast: UInt(times)).queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: {(snapshot) in
                if let messages = snapshot.value as? [String : AnyObject] {
                    for (_,one) in messages {
                        if let message = one["message"] as? String, let sender = one["sender"] as? String, let time = one["timeStamp"] as? Int, let key = one["key"] as? String, let likes = one["likes"] as? [String : AnyObject], let dislikes = one["dislikes"] as? [String : AnyObject], let senderUn = one["senderUn"] as? String, let replyCount = one["replyCount"] as? Int {
                            
                                let newComment = Comment()
                            newComment.youLikeDis = "None"
                            if likes[uid] != nil {
                            newComment.youLikeDis = "Liked"
                           
                            }
                            if dislikes[uid] != nil {
                                newComment.youLikeDis = "Disliked"
                            }
                            if let senderName = one["senderName"] as? String {
                                newComment.senderName = senderName
                            } else {
                                newComment.senderName = "Name not found"
                            }
                             if let theirKey = one["userKey"] as? String {
                                newComment.userKey = theirKey
                             } else {
                                newComment.userKey = " "
                            }
                            
                            newComment.replyCount = replyCount
                          
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
                                reloadBcAdd = true
                            }
                            //update it here, basically im lazy or laxy? either way it works :P
                            let update = ["likeCount" : likes.count-1]
                            ref.child(key).updateChildValues(update)
                            
                            
                        }
                    }
                    if reloadBcAdd == true {

                        self.tablerView.reloadData()
                    self.loadAttempts += 1
                    self.working = false
                    } else {
                        self.working = false
                    }
                    
                } else {
                    self.working = false
                }
              
                
            })
            }
        }
        }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if comments.count > 0 {
                if indexPath.section > 2 {
        if let uid = Auth.auth().currentUser?.uid {
            if Auth.auth().currentUser?.isAnonymous == false {
            if self.comments[indexPath.section-3].sender == uid {
                 return true
            }
            }
        }
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if comments.count > 0 {
            if indexPath.section > 0 {
                if let uid = Auth.auth().currentUser?.uid {
                    print(uid)
                    if let key = self.comments[indexPath.section-3].key {
                        if let aid  = self.aid {
                       let ref = Database.database().reference().child("artItems").child(aid).child("comments").child(key)
                            ref.removeValue()
                        self.comments.remove(at: indexPath.section-3)
                        self.tablerView.reloadData()
                    }
                    }
                }
            }
        }
    }
    
// not being used now
//    func sortByTime () {
//        if self.working == false {
//            self.working = true
//            let times = 7 * loadAttempts
//            if let aid = self.aid {
//                if let uid = Auth.auth().currentUser?.uid  {
//                    let ref = Database.database().reference().child("artItems").child(aid).child("comments")
//                    ref.queryLimited(toLast: UInt(times)).queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: {(snapshot) in
//                        if let messages = snapshot.value as? [String : AnyObject] {
//                            for (_,one) in messages {
//                                if let message = one["message"] as? String, let sender = one["sender"] as? String, let time = one["timeStamp"] as? Int, let key = one["key"] as? String, let likes = one["likes"] as? [String : AnyObject], let dislikes = one["dislikes"] as? [String : AnyObject], let senderUn = one["senderUn"] as? String, let replyCount = one["replyCount"] as? Int {
//
//                                    let newComment = Comment()
//                                    newComment.youLikeDis = "None"
//                                    if likes[uid] != nil {
//                                        newComment.youLikeDis = "Liked"
//
//                                    }
//                                    if dislikes[uid] != nil {
//                                        newComment.youLikeDis = "Disliked"
//                                    }
//                                    newComment.replyCount = replyCount
//                                    if let theirKey = one["userKey"] as? String {
//                                        newComment.userKey = theirKey
//                                    } else {
//                                        newComment.userKey = " "
//                                    }
//                                    newComment.message = message
//                                    newComment.likes = likes.count-1
//                                    newComment.dislikes = dislikes.count - 1
//                                    newComment.sender = sender
//                                    newComment.key = key
//                                    newComment.time = time
//                                    newComment.senderUn = senderUn
//                                    if self.checkArr.contains(key) {
//
//                                    } else {
//                                        self.comments.append(newComment)
//                                        self.checkArr.append(key)
//                                    }
//                                    //update it here, basically im lazy or laxy? either way it works :P
//                                    let update = ["likeCount" : likes.count-1]
//                                    ref.child(key).updateChildValues(update)
//
//
//                                }
//                            }
//                           // self.tablerView.reloadData()
//                            self.loadAttempts += 1
//                            self.working = false
//                            self.buttonMiddleToggle.setTitle("Comments \n\(self.comments.count)", for: .normal)
//                        } else {
//                            self.buttonMiddleToggle.setTitle("No Comments Yet", for: .normal)
//                            print("no comments")
//                            self.working = false
//                        }
//                        self.onceRef = false
//                         self.refreshControl.endRefreshing()
//                    })
//                }
//            }
//        }
//    }
    var titleOfAnimate = "Article Reposted!"
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
    
    var oneCheckActive = false
    func addActive () {
        if oneCheckActive == false {
            self.oneCheckActive = true
        if let aid = self.aid {
            if let id = Auth.auth().currentUser?.uid  {
                 let time = Int(NSDate().timeIntervalSince1970)
            let ref = Database.database().reference().child("artItems").child(aid).child("activeArray")
                let update = [id : "\(time)"]
                ref.updateChildValues(update)
                
        }
        }
        self.updateActive()
        }
    }
    
    var updatedActive = false
    func updateActive () {
        if self.activeUpdatedAlready == nil  {
            if let aid = self.aid {
                let ref = Database.database().reference().child("artItems").child(aid).child("activeArray")
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let values = snapshot.value as? [String : AnyObject] {
                       
                        for (zero,one) in values {
                         
                            let nowtime = Int(NSDate().timeIntervalSince1970)
                            if let theTime = one as? String {
                                if let intTim = Int(theTime) {
                                    let newTime = Int(nowtime - intTim)
                                    if newTime > 1200 {
                                       
                                        ref.child(zero).removeValue()
                                    }
                                    
                                }
                                
                            }
                          
                        }
                        
                        let update = ["active" : "\(values.count)"]
                        let ref2 = Database.database().reference().child("Feed").child(aid)
                        ref2.updateChildValues(update)
                        self.updatedActive = true
                        
                    } else {
                        let update = ["active" : "1"]
                        let ref2 = Database.database().reference().child("Feed").child(aid)
                        ref2.updateChildValues(update)
                        self.updatedActive = true
                    }
                    
                    
                })
            }

        } else {
           print("done already")
        }
    }
    
    
    @IBOutlet weak var imageLiker: UIImageView!
    
    @IBOutlet weak var imageDislikers: UIImageView!
   
    
    
    @IBOutlet weak var labelType: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ArticleInfoViewController {
            if let aid = self.aid {
                if let titler = self.titler {
                    dest.titler = titler
                    dest.publisher = self.publisher
                    dest.datePublished = self.timer
                    dest.likes = self.likesCount
                    dest.dislikes = self.dislikesCount
                    dest.views = self.totalViews
                    dest.aid = aid
                    dest.mainUlr = self.urlToLoad!
                }
            }
        }
    }
    
    let imageViewTut = UIImageView()
    let totalView = UIView()
    let nextButton = UIButton()
    @objc func takeTutorial (sender:UIButton) {
        
        totalView.backgroundColor = .clear
        
        
        print("called tut")
        print(sender.tag)
        nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        nextButton.backgroundColor = UIColor(red: 0, green: 0.5294, blue: 1, alpha: 1.0)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 15.0
        nextButton.titleLabel?.textColor = .white
       self.biasAllow = true
        
        self.uislideer.isUserInteractionEnabled = true
        self.viewl.removeGestureRecognizer(gestureCantRateBias)
        nextButton.addTarget(self, action: #selector(self.takeTutorial(sender:)), for: .touchUpInside)
        
        if sender.tag == 0 {
           
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                   totalView.frame = CGRect(x: 5, y: 180, width: self.view.frame.width - 10, height: 250)
                case 1334:
                    print("iPhone 6/6S/7/8")
                    totalView.frame = CGRect(x: 5, y: 180, width: self.view.frame.width - 10, height: 250)
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                     totalView.frame = CGRect(x: 5, y: 180, width: self.view.frame.width - 10, height: 250)
                case 2436:
                    print("iPhone X, XS")
                    totalView.frame = CGRect(x: 5, y: 210, width: self.view.frame.width - 10, height: 250)
                case 2688:
                    print("iPhone XS Max")
                    totalView.frame = CGRect(x: 5, y: 210, width: self.view.frame.width - 10, height: 250)
                case 1792:
                    print("iPhone XR")
                    totalView.frame = CGRect(x: 5, y: 210, width: self.view.frame.width - 10, height: 250)
                default:
                    print("Unknown")
                }
            } 
            nextButton.setTitle("Next", for: .normal)
            nextButton.frame = CGRect(x: 15, y: totalView.frame.height - 50, width: self.totalView.frame.width - 30, height: 40)
            imageViewTut.frame = CGRect(x: 0, y: 5, width: totalView.frame.width , height: 200)
            imageViewTut.contentMode = .scaleAspectFill
            
            nextButton.tag = 1
            self.totalView.addSubview(imageViewTut)
            self.totalView.addSubview(nextButton)
            self.view.addSubview(totalView)
            imageViewTut.image = #imageLiteral(resourceName: "zTut1")
            return
        }
        if sender.tag == 2 {
           // totalView.frame = CGRect(x: 40, y: self.view.frame.height - 305, width: self.view.frame.width, height: 250)
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    totalView.frame = CGRect(x: 40, y: self.view.frame.height - 310, width: self.view.frame.width, height: 250)
                case 1334:
                    print("iPhone 6/6S/7/8")
                    totalView.frame = CGRect(x: 40, y: self.view.frame.height - 310, width: self.view.frame.width, height: 250)
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    totalView.frame = CGRect(x: 40, y: self.view.frame.height - 310, width: self.view.frame.width, height: 250)
                case 2436:
                    print("iPhone X, XS")
                    totalView.frame = CGRect(x: 40, y: self.view.frame.height - 355, width: self.view.frame.width, height: 250)
                case 2688:
                    print("iPhone XS Max")
                    totalView.frame = CGRect(x: 40, y: self.view.frame.height - 355, width: self.view.frame.width, height: 250)
                case 1792:
                    print("iPhone XR")
                    totalView.frame = CGRect(x: 40, y: self.view.frame.height - 355, width: self.view.frame.width, height: 250)
                default:
                    print("Unknown")
                }
            }
            nextButton.frame = CGRect(x: 15, y: 2, width: self.totalView.frame.width - 65, height: 40)
            imageViewTut.frame = CGRect(x: 0, y: 50, width: totalView.frame.width , height: 200)
            nextButton.tag = 3
            imageViewTut.image = #imageLiteral(resourceName: "zTut4")
            nextButton.setTitle("Next", for: .normal)
        return
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
                    totalView.frame = CGRect(x: 5, y: 200, width: self.view.frame.width - 10, height: 250)
                case 2436:
                    print("iPhone X, XS")
                    totalView.frame = CGRect(x: 5, y: 240, width: self.view.frame.width - 10, height: 250)
                case 2688:
                    print("iPhone XS Max")
                    totalView.frame = CGRect(x: 5, y: 240, width: self.view.frame.width - 10, height: 250)
                case 1792:
                    print("iPhone XR")
                    totalView.frame = CGRect(x: 5, y: 240, width: self.view.frame.width - 10, height: 250)
                default:
                    print("Unknown")
                }
            }
            nextButton.tag = 2
            imageViewTut.image = #imageLiteral(resourceName: "zTut3")
            nextButton.setTitle("Next", for: .normal)
            return
        }
        if sender.tag == 3 {
         //   totalView.frame = CGRect(x: 5, y: self.view.frame.height - 305, width: self.view.frame.width - 10, height: 250)
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    totalView.frame = CGRect(x: 5, y: self.view.frame.height - 305, width: self.view.frame.width - 10, height: 250)
                case 1334:
                    print("iPhone 6/6S/7/8")
                    totalView.frame = CGRect(x: 5, y: self.view.frame.height - 305, width: self.view.frame.width - 10, height: 250)
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    totalView.frame = CGRect(x: 5, y: self.view.frame.height - 305, width: self.view.frame.width - 10, height: 250)
                case 2436:
                    print("iPhone X, XS")
                    totalView.frame = CGRect(x: 5, y: self.view.frame.height - 345, width: self.view.frame.width - 10, height: 250)
                case 2688:
                    print("iPhone XS Max")
                    totalView.frame = CGRect(x: 5, y: self.view.frame.height - 345, width: self.view.frame.width - 10, height: 250)
                case 1792:
                    print("iPhone XR")
                    totalView.frame = CGRect(x: 5, y: self.view.frame.height - 345, width: self.view.frame.width - 10, height: 250)
                default:
                    print("Unknown")
                }
            }
            nextButton.frame = CGRect(x: 15, y: 2, width: self.totalView.frame.width - 30, height: 40)
            imageViewTut.frame = CGRect(x: 0, y: 50, width: totalView.frame.width , height: 200)
            nextButton.tag = 4
            imageViewTut.image = #imageLiteral(resourceName: "zTut5")
            nextButton.setTitle("Next", for: .normal)
            return
        }
        if sender.tag == 4 {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    totalView.frame = CGRect(x: 5, y: 270, width: self.view.frame.width - 10, height: 250)
                case 1334:
                    print("iPhone 6/6S/7/8")
                    totalView.frame = CGRect(x: 5, y: 270, width: self.view.frame.width - 10, height: 250)
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    totalView.frame = CGRect(x: 5, y: 270, width: self.view.frame.width - 10, height: 250)
                case 2436:
                    print("iPhone X, XS")
                    totalView.frame = CGRect(x: 5, y: 300, width: self.view.frame.width - 10, height: 250)
                case 2688:
                    print("iPhone XS Max")
                    totalView.frame = CGRect(x: 5, y: 300, width: self.view.frame.width - 10, height: 250)
                case 1792:
                    print("iPhone XR")
                    totalView.frame = CGRect(x: 5, y: 300, width: self.view.frame.width - 10, height: 250)
                default:
                    print("Unknown")
                }
            }
            nextButton.frame = CGRect(x: 15, y: totalView.frame.height - 50, width: self.totalView.frame.width - 30, height: 40)
            imageViewTut.frame = CGRect(x: 0, y: 5, width: totalView.frame.width , height: 200)
            nextButton.tag = 5
            imageViewTut.image = #imageLiteral(resourceName: "zTut6")
            nextButton.setTitle("All Done!", for: .normal)
            return
        }
        if sender.tag == 5 {
            self.totalView.removeFromSuperview()
            
           let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "showTutorial")
            return
        }
        
        
    }
    var updatedAlready = [String]()
    func sendNotif (theirUid: String, userkey: String, comId: String, type: String) {
        if updatedAlready.contains(theirUid) || theirUid == Auth.auth().currentUser?.uid && self.aid == nil || self.publisher == nil {
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
                                let setip = ["notification" : "Someone liked your comment!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "publisher" : self.publisher!, "key" : key!,"unseen" : "unseen", "aid" : self.aid!, "url" : self.urlToLoad!] as [String : Any]
                            
                            let final = [key : setip]
                            ref1.child("users").child(theirUid).child("inbox").updateChildValues(final)
                        }
                        }
                        
                            return
                        
                    } else {
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
                            let setip = ["notification" : "Someone liked your comment!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "key" : key!, "aid" : self.aid!, "publisher" : self.publisher!, "url" : self.urlToLoad!, "unseen" : "unseen"] as [String : Any]
                            
                            let final = [key : setip]
                            ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                        }
                    }
                        return
                    
                }
                
            })
            
            
            } else {
              
                
                        let refUse = Database.database().reference()
                        let key = refUse.child("users").child(theirUid).child("inbox").childByAutoId().key
                        let time = Int(NSDate().timeIntervalSince1970)
                        let ref3 = Database.database().reference()
                        if let myId = Auth.auth().currentUser?.uid  {
                            if self.aid != nil && self.urlToLoad != nil {
                                let setip = ["notification" : "Someone liked your comment!", "receivedFrom" : myId, "timeSent" : time, "sentFrom" : "Politic", "key" : key!, "aid" : self.aid!, "publisher" : self.publisher!, "url" : self.urlToLoad!, "unseen" : "unseen"] as [String : Any]
                                
                                let final = [key : setip]
                                ref3.child("users").child(theirUid).child("inbox").updateChildValues(final)
                            }
                        }
                
                
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
        if name.contains("Independent") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2FindepLogo.png?alt=media&token=2ddcb2be-d481-4f2c-91cf-050eb9d73af1"
        }
        let none = "none"
        return none
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}
extension UIImage {
    func roundedImageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

extension UISlider {
    var thumbCenterX: CGFloat {
        let trackRect = self.trackRect(forBounds: frame)
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return thumbRect.midX
    }
}


//007AFF
