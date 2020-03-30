//
//  SelectedSearchViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 3/26/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SelectedSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, changedValues {

    var tablerView = UITableView()
    
    var publisher: String?
    var tagName: String?
    var publisherName: String?
    var isFollowing = false
  //  var myId: String?
    
   let imageViewTut = UIImageView()
      let totalView = UIView()
      let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
       
       
        self.checkIfLess()
        layoutViews()
        tablerView.register(SearchedSelectedNewsTableViewCell.self, forCellReuseIdentifier: "aComp")
        tablerView.separatorStyle = .none
        tablerView.delegate = self
        tablerView.dataSource = self
       // self.tablerView.contentInset = UIEdgeInsets(top: 55,left: 0,bottom: 0,right: 0);
         tablerView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        if #available(iOS 11.0, *) {
            self.tablerView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        
         if let mySaved = UserDefaults.standard.value(forKey: "showPersonalize") as? String {
            print(mySaved)
             totalView.backgroundColor = .clear
            nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
                   nextButton.backgroundColor = UIColor(red: 0, green: 0.5294, blue: 1, alpha: 1.0)
                   nextButton.clipsToBounds = true
                   nextButton.layer.cornerRadius = 15.0
                   nextButton.titleLabel?.textColor = .white
            if UIDevice().userInterfaceIdiom == .phone {
                           switch UIScreen.main.nativeBounds.height {
                           case 1136:
                               print("iPhone 5 or 5S or 5C")
                              totalView.frame = CGRect(x: 35, y: 15, width: self.view.frame.width - 10, height: 250)
                           case 1334:
                               print("iPhone 6/6S/7/8")
                               totalView.frame = CGRect(x: 35, y: 15, width: self.view.frame.width - 10, height: 250)
                           case 1920, 2208:
                               print("iPhone 6+/6S+/7+/8+")
                                totalView.frame = CGRect(x: 35, y: 15, width: self.view.frame.width - 10, height: 250)
                           case 2436:
                               print("iPhone X, XS")
                               totalView.frame = CGRect(x: 45, y: 20, width: self.view.frame.width - 10, height: 250)
                           case 2688:
                               print("iPhone XS Max")
                               totalView.frame = CGRect(x: 45, y: 30, width: self.view.frame.width - 10, height: 250)
                           case 1792:
                               print("iPhone XR")
                               totalView.frame = CGRect(x: 45, y: 30, width: self.view.frame.width - 10, height: 250)
                           default:
                               print("Unknown")
                           }
                       }
            imageViewTut.image = #imageLiteral(resourceName: "personalized")
                       nextButton.setTitle("Got it", for: .normal)
                       nextButton.frame = CGRect(x: 15, y: totalView.frame.height - 50, width: self.totalView.frame.width - 70, height: 40)
                       imageViewTut.frame = CGRect(x: 0, y: 5, width: totalView.frame.width , height: 200)
                       imageViewTut.contentMode = .scaleAspectFill
            nextButton.addTarget(self, action: #selector(self.closed), for: .touchUpInside)
                       nextButton.tag = 1
                       self.totalView.addSubview(imageViewTut)
                       self.totalView.addSubview(nextButton)
                       self.view.addSubview(totalView)
                
            
        }
        //edgesForExtendedLayout = []
        
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
                tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-40)
                
            case 2688:
                print("iPhone XS Max")
                tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-40)
            case 1792:
                print("iPhone XR")
                tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-40)
            default:
                print("Unknown")
            }
        }
        
        
        tablerView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        if let publisher = publisher {
            loadArticlesWithPub(pub: publisher)
       self.navigationItem.title = publisher
            print("\(publisher) vdl")
            let defaults = UserDefaults.standard
            let myarray = defaults.stringArray(forKey: "savedPubs") ?? [String]()
            if myarray.contains(publisher) {
                self.isFollowing = true
            }
            let button1 = UIBarButtonItem(image: UIImage(named: "seeLessIconi"), style: .plain, target: self, action: #selector(self.seeLess)) // action:#selector(Class.MethodName) for swift 3
            self.navigationItem.rightBarButtonItem  = button1
          
        }
        else {
//            let defaults = UserDefaults.standard
//            let myarray = defaults.stringArray(forKey: "savedTags") ?? [String]()
//            if let tagName = self.tagName {
//            if myarray.contains(tagName) {
//                self.isFollowing = true
//            }
//            }
//            self.navigationItem.title = tagName
        }

      self.grabViewCount()
        self.addExternamLink()
     
        // Do any additional setup after loading the view.
    }
    
    @objc func closed () {
        self.totalView.removeFromSuperview()
        let prefs = UserDefaults.standard
                   prefs.removeObject(forKey: "showPersonalize")
    }
    
    
    @objc func clickedOnExternalLink (sender: UIButton) {
      if let url = arts[sender.tag].mainUrl {
          if let mySavedDes = UserDefaults.standard.value(forKey: "dataLog") as? Int {
                     if mySavedDes >= 3 {
                      let radOne = Int.random(in: 1..<8)
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

    
    func checkIfLess () {
        if let publisher = self.publisher {
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: "seeLessArray") ?? [String]()
        if myarray.contains(publisher) {
            self.alreadyLess = true
        }
        }
    }

    var alreadyLess = false
   @objc func seeLess () {
    if alreadyLess == false {
        let contol = UIAlertController(title: "See Less", message: "See less of this publishers articles in your feed. Please note that still some articles by this publisher might show up in your feed, just less of them.", preferredStyle: .actionSheet)
    let font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        contol.changeFont(view: contol.view, font: font!)
        let action1 = UIAlertAction(title: "See Less", style: .default, handler:{  (alert : UIAlertAction) -> Void in
            if let publisher = self.publisher {
                let defaults = UserDefaults.standard
                var myarray = defaults.stringArray(forKey: "seeLessArray") ?? [String]()
                myarray.append(publisher)
                defaults.set(myarray, forKey: "seeLessArray")
            }
            self.alreadyLess = true
    })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        contol.addAction(action1)
        contol.addAction(cancel)
    self.present(contol, animated: true, completion: nil)
    } else {
        let contol = UIAlertController(title: "See More", message: "See more articles by this publisher in your feed!", preferredStyle: .actionSheet)
        let font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        contol.changeFont(view: contol.view, font: font!)
        let action1 = UIAlertAction(title: "See More", style: .default, handler:{  (alert : UIAlertAction) -> Void in
            if let publisher = self.publisher {
                let defaults = UserDefaults.standard
                var myarray = defaults.stringArray(forKey: "seeLessArray") ?? [String]()
                if let index = myarray.firstIndex(of: publisher) {
                    myarray.remove(at: index)
                }
                defaults.set(myarray, forKey: "seeLessArray")
            }
            self.alreadyLess = false
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        contol.addAction(action1)
        contol.addAction(cancel)
        self.present(contol, animated: true, completion: nil)
    }
    }
    
    var theImg: UIImage?
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let tag = tagName {
//            print(tag)
//            return 5
//        }
        return arts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "aComp", for: indexPath) as! SearchedSelectedNewsTableViewCell
          let image2 = UIImage(named: "news")
        if arts.count > 0 {
            
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
            
            if let urlOfPub = arts[indexPath.row].publisherUrl {
                if urlOfPub == "none" {
                    cell.labelPubli.text = "\n\(arts[indexPath.row].publisher!)"
                } else {
                    cell.labelPubli.text = ""
                    let url = URL(string: urlOfPub)
                    cell.publisherImage.kf.setImage(with: url)
                }
            }
             cell.viewLabel.text = "\(arts[indexPath.row].views!) views"
            
            if let urLikeDislike = arts[indexPath.row].personalLikeDis {
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
            if let ratio = arts[indexPath.row].ratio {
                cell.percentLabel.text = "\(ratio)%"
                if ratio >= 50 {
                    cell.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
                } else {
                    cell.percentLabel.textColor = UIColor(red: 0.7373, green: 0.1961, blue: 0, alpha: 1.0)
                }
            }
            cell.externalButton.tag = indexPath.row
            cell.externalButton.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
            cell.titleLabel.text = arts[indexPath.row].titler
            cell.timeLabel.text = arts[indexPath.row].time
           // cell.countActiveLabel.text = "12"
            cell.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
           // cell.percentLabel.text = "66%"
            
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
   
        }
        return cell
    }
    
    @objc func subOrNot () {
        if isFollowing == false {
             if let publisher = publisher {
                let defaults = UserDefaults.standard
                var myarray = defaults.stringArray(forKey: "savedPubs") ?? [String]()
                myarray.append(publisher)
                defaults.set(myarray, forKey: "savedPubs")
                
            }
//            if let tag = tagName {
//                let defaults = UserDefaults.standard
//                var myarray = defaults.stringArray(forKey: "savedTags") ?? [String]()
//                myarray.append(tag)
//                defaults.set(myarray, forKey: "savedTags")
//            }
            subScribeButton.setTitle("Subscribed", for: .normal)
            subScribeButton.backgroundColor = .white
            subScribeButton.setTitleColor(UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0), for: .normal)
            if let publ = self.publisher {
                let newString = publ.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).lowercased()
            let ref = Database.database().reference().child("publishers").child(newString).child("subs")
                if let uid = Auth.auth().currentUser?.uid {
                    let upd = [uid : uid]
                    ref.updateChildValues(upd)
                }
            }
            isFollowing = true
            return
        }
        if isFollowing == true {
             if let publisher = publisher {
                let defaults = UserDefaults.standard
                var myarray = defaults.stringArray(forKey: "savedPubs") ?? [String]()
                if let index = myarray.firstIndex(of: publisher) {
                    myarray.remove(at: index)
                }
                defaults.set(myarray, forKey: "savedPubs")
            }
            if let publ = self.publisher {
                let newString = publ.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).lowercased()
                if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference().child("publishers").child(newString).child("subs").child(uid)
                ref.removeValue()
                
            }
            }
//            if let tag = tagName {
//                let defaults = UserDefaults.standard
//                var myarray = defaults.stringArray(forKey: "savedTags") ?? [String]()
//                if let index = myarray.firstIndex(of: tag) {
//                    myarray.remove(at: index)
//                }
//                defaults.set(myarray, forKey: "savedTags")
//            }
            subScribeButton.setTitle("Subscribe", for: .normal)
            subScribeButton.backgroundColor = UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0)
            subScribeButton.setTitleColor(.white, for: .normal)
            isFollowing = false
            return
        }
    }
    var labelSubs = UILabel()
     let subScribeButton = UIButton()
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let viewl = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
       
       
        viewl.backgroundColor = .darkText
        labelSubs = UILabel(frame: CGRect(x: 10, y: 20, width: 250, height: 20))
        labelSubs.textColor = .white
        labelSubs.text = "- Subscribers"
        labelSubs.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        labelSubs.textAlignment = .left
        
        
        subScribeButton.frame = CGRect(x: viewl.frame.width - 150, y: 10, width: 140, height: 40)
        subScribeButton.backgroundColor = UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0)
        subScribeButton.setTitleColor(.white, for: .normal)
        if self.isFollowing == false {
            subScribeButton.setTitle("Subscribe", for: .normal)
        } else {
            subScribeButton.setTitle("Subscribed", for: .normal)
            subScribeButton.backgroundColor = .white
            subScribeButton.setTitleColor(UIColor(red: 0, green: 0.5608, blue: 0.9373, alpha: 1.0), for: .normal)
        }
        subScribeButton.layer.cornerRadius = 12.0
        subScribeButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        subScribeButton.addTarget(self, action: #selector(subOrNot), for: .touchUpInside)
       
        
        if tagName != nil {
            subScribeButton.frame = CGRect(x: viewl.frame.width / 2 - 70, y: 10, width: 140, height: 40)
        } else {
        viewl.addSubview(labelSubs)
        }
        viewl.addSubview(subScribeButton)
        
        return viewl
    }
    
    var img: UIImage?
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return 60
    }
    func layoutViews () {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .grouped)
        view.addSubview(tablerView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = false
          self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        
      
       
    }
   
    override func viewWillDisappear(_ animated: Bool) {
      //  self.navigationController?.navigationBar.isHidden = true
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if name.contains("New York Times") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Fnyttt.png?alt=media&token=67db126a-8c05-47b9-8160-863f0e83d200"
        }
        if name.contains("Politico") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Fpoliticoedit.png?alt=media&token=2b64e726-1a90-44b4-9f64-77a91be49e3e"
        }
        if name.contains("euters") {
            return "https://firebasestorage.googleapis.com/v0/b/politic-14ebf.appspot.com/o/publisherImages%2Freutersrun.png?alt=media&token=291158af-0406-4219-a466-06f0f91085f0"
        }
        if name.contains("Washington Post") {
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
    
    var arts = [Article]()
    
//    func loadArticlesWithTag(tag: String) {
//        let ref = Database.database().reference().child("Feed")
//
//    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
            if scrollView == tablerView {
                if self.timesRan < 10 {
                    if self.working == false {
                        self.loadingMore = true
                        if let pub = self.publisher {
                       self.loadArticlesWithPub(pub: pub)
                        }
                    }
                }
            }
        }
    }
    
    
    var working = false
    var loadingMore = false
    var timesRan = 1;
    func loadArticlesWithPub(pub: String) {
        var addedSoReload = false
        let ref = Database.database().reference().child("Feed")
        var countRun = timesRan*5
        self.working = true
        if self.loadingMore == false {
            if self.publisher!.contains("New York Times") {
                countRun = 15
                timesRan = 3;
            }
        }
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        var maxremove = 0;
        ref.queryLimited(toLast: UInt(countRun)).queryOrdered(byChild: "publisher").queryEqual(toValue: pub).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let titlr = snapshot.value as? [String : AnyObject] {
              
                for (_, each) in titlr{
                    
                    if let titler = each["title"] as? String, let url = each["url"] as? String, let namert = each["publisher"] as? String, let publishedAt = each["publishedAt"] as? String, let aid = each["aid"] as? String {
                        if titler.contains("Your") && titler.contains("Briefing") && maxremove < 9  {
                            maxremove+=1
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
                            if let views = each["views"] as? String {
                                newArt.views = Int(views)
                            } else {
                                newArt.views = 0
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
                            
                            if likeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Like"
                                print("GOT A LIKE")
                            }
                            
                            if dislikeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Dislike"
                            }
                        
                        newArt.titler = titler
                        newArt.mainUrl = url
                        
                        
                        if self.arts.contains( where: { $0.mainUrl == newArt.mainUrl } ) {
                            print("no")
                        } else {
                            if self.arts.count < countRun  {
                                
                                self.arts.append(newArt)
                                
                                addedSoReload = true
                              
                            
                            }
                            
                        }
                        }
                    }
                }
                
                
                
                if addedSoReload == true {
                  
                        self.tablerView.reloadData()
                    
                    self.timesRan+=1
                    self.working = false
                }
                // self.activityIndc.stopAnimating()
               
                
            }
            if self.arts.count == 0 {
                print("yep zero")
                let viewy = UIView()
                viewy.backgroundColor = UIColor(red: 0.149, green: 0, blue: 0.749, alpha: 1.0)
                viewy.layer.cornerRadius = 20
                viewy.clipsToBounds = true
                viewy.frame = CGRect(x: 25, y: self.view.frame.height / 2 - 50, width: self.view.frame.width - 50, height: 60)
                let labli = UILabel(frame: CGRect(x: 10, y: 10, width: viewy.frame.width - 20, height: 40))
                labli.textColor = .white
                labli.textAlignment = .center
                labli.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
                labli.text = "No Articles Found! :/"
                viewy.addSubview(labli)
                self.view.addSubview(viewy)
            }
            
        })
    }
    
    var totalInt = 0;
    func grabViewCount () {
        if let pub = self.publisher {
        let newString = pub.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).lowercased()
            print(newString)
         let ref = Database.database().reference().child("publishers").child(newString).child("subs")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let vals = snapshot.value as? [String : AnyObject] {
                self.labelSubs.text = "\(vals.count) subscribers"
                  self.totalInt = vals.count
            } else {
                self.labelSubs.text = "0 subscribers"
              
            }
        })
        
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedArt") as? SelectedArticleViewController {
                if let cell = tablerView.cellForRow(at: indexPath) as? SearchedSelectedNewsTableViewCell {
                                          if let imager = cell.imagerView.image {
                                           destination.img = imager
                                   }
                               }
                
                destination.delegate = self
                destination.indexPathi = indexPath
             //   destination.useID = self.myId
                
                destination.cell = "1"
                destination.titler = arts[indexPath.row].titler
                destination.publisher = arts[indexPath.row].publisher
                destination.urlToLoad = arts[indexPath.row].mainUrl
                destination.aid = arts[indexPath.row].aid
                if let myPersonal = self.arts[indexPath.row].personalLikeDis {
                    destination.personLikeDis = myPersonal
                }
                destination.timer = arts[indexPath.row].time
                if let navigator = navigationController {
                    navigator.pushViewController(destination, animated: true)
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
        
        if cell == "1" {
            
            if let celler = tablerView.cellForRow(at: index) as? SearchedSelectedNewsTableViewCell {
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
    
   
    
    let viewHold = UIView()
    func addExternamLink () {
        viewHold.backgroundColor = .clear
        
        viewHold.frame = CGRect(x: 20, y: self.view.frame.height - 160, width: 65, height: 65)
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
                       viewHold.frame = CGRect(x: 20, y: self.view.frame.height - 190, width: 65, height: 65)
                       
                   case 2688:
                       print("iPhone XS Max")
                        viewHold.frame = CGRect(x: 20, y: self.view.frame.height - 190, width: 65, height: 65)
                   case 1792:
                       print("iPhone XR")
                       viewHold.frame = CGRect(x: 20, y: self.view.frame.height - 190, width: 65, height: 65)
                   default:
                       print("Unknown")
                   }
               }
        self.view.addSubview(viewHold)
        let imageViewLink = UIImageView()
        imageViewLink.contentMode = .scaleAspectFill
        imageViewLink.image = UIImage(named: "externam")
        imageViewLink.frame = CGRect(x: 0, y: 0, width: viewHold.frame.width, height: viewHold.frame.height)
        viewHold.clipsToBounds = true
        
        viewHold.addSubview(imageViewLink)
        let buttonAbove = UIButton()
        buttonAbove.frame = CGRect(x: 0, y: 0, width: imageViewLink.frame.width, height: imageViewLink.frame.height)
        buttonAbove.setTitle("", for: .normal)
        buttonAbove.addTarget(self, action: #selector(self.goSite), for: .touchUpInside)
        viewHold.addSubview(buttonAbove)
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            self.viewHold.removeFromSuperview()
        })
        
        
    }
    
    
    @objc func goSite () {
        if let name = self.publisher {
        if name.contains("Bloomberg") {
                   UIApplication.shared.open(URL(string:"https://www.bloomberg.com")!, options: [:], completionHandler: nil)
            return
               }
               if name.contains("Breitbart") {
                   UIApplication.shared.open(URL(string:"https://www.breitbart.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("CBS") {
                   UIApplication.shared.open(URL(string:"https://www.cbs.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("CNN") {
                 UIApplication.shared.open(URL(string:"https://www.cnn.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("NBC") {
                   UIApplication.shared.open(URL(string:"https://www.nbc.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("Newsweek") {
                  UIApplication.shared.open(URL(string:"https://www.newsweek.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("New York Magazine") {
                UIApplication.shared.open(URL(string:"https://www.nymag.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("New York Times") {
                  UIApplication.shared.open(URL(string:"https://www.nytimes.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("Politico") {
              UIApplication.shared.open(URL(string:"https://www.politico.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("euters") {
                 UIApplication.shared.open(URL(string:"https://www.reuters.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("Washington Post") {
                   UIApplication.shared.open(URL(string:"https://www.washingtonpost.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("Wall") && name.contains("Journal") {
                 UIApplication.shared.open(URL(string:"https://www.wsj.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("USA Today") {
                 UIApplication.shared.open(URL(string:"https://www.usatoday.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("The Hill") {
               UIApplication.shared.open(URL(string:"https://www.thehill.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("ABC News") {
                   UIApplication.shared.open(URL(string:"https://www.abcnews.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("Fox News") {
                 UIApplication.shared.open(URL(string:"https://www.foxnews.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("The Economist") {
                   UIApplication.shared.open(URL(string:"https://www.economist.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("Vice News") {
                UIApplication.shared.open(URL(string:"https://www.vice.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("MSNBC") {
                   UIApplication.shared.open(URL(string:"https://www.msnbc.com")!, options: [:], completionHandler: nil)
                return
               }
               if name.contains("Fortune") {
                 UIApplication.shared.open(URL(string:"https://www.fortune.com")!, options: [:], completionHandler: nil)
                return
               }
            if name.contains("The American") {
        UIApplication.shared.open(URL(string:"https://www.theamericanconservative.com")!, options: [:], completionHandler: nil)
                return
            }
            if name.contains("National Review") {
            
                UIApplication.shared.open(URL(string:"https://www.nationalreview.com")!, options: [:], completionHandler: nil)
                return
            }
            if name.contains("Independent") {
                
                 UIApplication.shared.open(URL(string:"https://www.independent.co.uk/us")!, options: [:], completionHandler: nil)
                return
            }
            if name.contains("Verge") {
                UIApplication.shared.open(URL(string:"https://www.theverge.com")!, options: [:], completionHandler: nil)
                return
            }
            if name.contains("USNews") {
                UIApplication.shared.open(URL(string:"https://www.usnews.com")!, options: [:], completionHandler: nil)
                return
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

}

extension UIAlertController {
   
    func changeFont(view: UIView, font:UIFont) {
        for item in view.subviews {
            if item.isKind(of: UICollectionView.self) {
                let col = item as! UICollectionView
                for  row in col.subviews{
                    changeFont(view: row, font: font)
                }
            }
            if item.isKind(of: UILabel.self) {
                let label = item as! UILabel
                label.font = font
                label.textColor = .darkText
            }else {
                changeFont(view: item, font: font)
            }
            
        }
    }
    
//    open override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let font = UIFont(name: "HelveticaNeue-Medium", size: 16)
//        changeFont(view: self.view, font: font! )
//    }
}
