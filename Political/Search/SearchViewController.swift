//
//  SearchViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 10/5/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, changedValues {

    var suggestedTitle = " "
     let radOne = Int.random(in: 0..<6)
    var trendArts = [Article]()
   // var myId: String?
    let refreshControl = UIRefreshControl()
    
    let acivit = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        tablerView.delegate = self
        tablerView.dataSource = self
        tablerView.register(nonethingCell.self, forCellReuseIdentifier: "nonethingCell")
      acivit.color = .white
        acivit.frame = CGRect(x: tablerView.center.x - 50, y: tablerView.frame.height / 1.7, width: 100, height: 100)
        tablerView.addSubview(acivit)
        acivit.startAnimating()
        
        searchBar.placeholder = "Users and articles"
        searchBar.layer.borderWidth = 1
        searchBar.tintColor = .white
        searchBar.barTintColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
         refreshControl.tintColor = UIColor(red: 0.8196, green: 0, blue: 0.3804, alpha: 1.0)
       self.grabTending()
        
        tablerView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 67)
        
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
        tablerView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        
       
        
      //  loadTags()
        
        if radOne > 2 {
            self.suggestedUsersGrab()
        }
        print(radOne)
        loadPubs()
        // Do any additional setup after loading the view.
    }
    var inRefresh = false
    var oneCallRef = false
    @objc func refresh(sender:AnyObject) {
        inRefresh = true
        if self.cantRefUntilDone == false {
        if self.oneCallRef == false {
            self.oneCallRef = true
        self.grabTending()
        }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          self.navigationController?.navigationBar.isHidden = false 
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    let searchBar = UISearchBar()
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if section == 0 {
        return 55
        }
        if section == 1 {
            return 38
        }
        if section == 2 {
            return 44
        }
        return 1
    }
    let buttonClickySearch = UIButton()
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
       buttonClickySearch.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
            buttonClickySearch.addTarget(self, action: #selector(self.moveToSearch), for: .touchUpInside)
        self.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
            view.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        view.addSubview(searchBar)
       view.addSubview(buttonClickySearch)
        return view
        }
        if section == 1 {
            let viewi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 34))
          //  viewi.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
            let labelStuff = UILabel(frame: CGRect(x: 34, y: 5, width: self.view.frame.width - 100, height: 26))
            labelStuff.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            labelStuff.textColor = .white
                //UIColor(red: 0.2157, green: 0, blue: 1, alpha: 1.0)
            labelStuff.contentMode = .left
            labelStuff.text = "Trending Articles"
            let tedningImg = UIImageView()
            tedningImg.image = UIImage(named: "bolt")
            tedningImg.frame = CGRect(x: 5, y: 2, width: 30, height: 30)
            tedningImg.contentMode = .scaleAspectFill
            viewi.addSubview(tedningImg)
            viewi.addSubview(labelStuff)
            return viewi
        }
        if section == 2 {
          let viewi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
            let labelStuff = UILabel(frame: CGRect(x: 10, y: 10, width: self.view.frame.width - 100, height: 25))
            labelStuff.font = UIFont(name: "HelveticaNeue", size: 15)
            labelStuff.textColor = .darkGray
            labelStuff.contentMode = .left
            labelStuff.text = suggestedTitle
            viewi.addSubview(labelStuff)
            return viewi
        }
        let tinyView = UIView()
        return tinyView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if self.suggestedUsers.count == 0 {
            return 300
            } else {
                return 60
            }
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 215
            }
            return 230
        }
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                
            case 2436:
                // print("iPhone X, XS")
                return 192
            case 2688:
                // print("iPhone XS Max")
                return 200
            case 1792:
                // print("iPhone XR")
                return 200
            default:
                print("none")
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            return 210
        }
        return 175
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 2 {
            if self.suggestedUsers.count == 0 {
            return 1
            }
            return self.suggestedUsers.count
        }
        if trendArts.count == 0 {
            return 3
        }
        return trendArts.count
    }
    
    var suggestedUsers = [Useri]()
    func suggestedUsersGrab () {
        let ref = Database.database().reference().child("bigUsers")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let users = snapshot.value as? [String : String] {
                let dispatcherGroup = DispatchGroup()
                for (_,eachi) in users {
                    dispatcherGroup.enter()
                    let ref2 = Database.database().reference().child("users").child(eachi)
                    ref2.observeSingleEvent(of: .value, with: {(snap) in
                        if let userStuff = snap.value as? [String:AnyObject] {
                            
                           print(userStuff.count)
                            let valuei = snap.value as? [String : AnyObject]
                                if let usernamer = valuei?["username"] as? String, let namerl = valuei?["name"] as? String, let uiderl = valuei?["uid"] as? String {
                                    let newr = Useri()
                                    newr.username = usernamer
                                    newr.namer = namerl
                                    newr.uider = uiderl
                                    if let urler = valuei?["profileUrl"] as? String {
                                        newr.profilePhotoUrl = urler
                                    } else {
                                        newr.profilePhotoUrl = "none"
                                    }
                                    if let theirKey = valuei?["userKey"] as? String {
                                        newr.userKey = theirKey
                                    }
                                    if self.suggestedUsers.contains( where: { $0.uider == newr.uider } ) || newr.uider == Auth.auth().currentUser?.uid {
                                        print("no")
                                    } else {
                                        if self.suggestedUsers.count < 5 {
                                            print("APPENDED ONE!")
                                            
                                            self.suggestedUsers.append(newr)
                                            
                                        }
                                        
                                    }
                                }
                            
                            
                        }
                        dispatcherGroup.leave()
                    })
                }
                dispatcherGroup.notify(queue: DispatchQueue.main) {
                    if self.suggestedUsers.count != 0 {
                        
                 self.suggestedTitle = "Suggested Users"
                    }
                    
                    self.tablerView.reloadSections([2], with: .automatic)
                    if self.suggestedUsers.count == 0 {
                        
                    }
                }
            }
        })
    }
    
    func addCoolLogo () {
        
    }
    
    
    
//    var tags = [Tagi]()
//
//    func loadTags () {
//
//        let defaults = UserDefaults.standard
//        let myarray = defaults.stringArray(forKey: "savedTags") ?? [String]()
//        for each in myarray {
//            let newObj = Tagi()
//            newObj.following = true
//            newObj.title = each
//            tags.append(newObj)
//        }
//        if tags.count == 0 {
//            let newObj = Tagi()
//            newObj.following = false
//            newObj.title = "Economy"
//            tags.append(newObj)
//            let newObj1 = Tagi()
//            newObj1.following = false
//            newObj1.title = "Supreme Court"
//            tags.append(newObj1)
//            let newObj2 = Tagi()
//            newObj2.following = false
//            newObj2.title = "2020"
//            tags.append(newObj2)
//        }
//       self.tablerView.reloadData()
//    }
    
    var publis = [Publisher]()
    
    func loadPubs () {
        let defaults = UserDefaults.standard
        let myarray2 = defaults.stringArray(forKey: "savedPubs") ?? [String]()
        
        for each in myarray2 {
            let newPub = Publisher()
            newPub.name = each
            newPub.idx = each
            newPub.isFollowing = true
            self.publis.append(newPub)
        }
        
        if publis.count == 0 {
            let newPub = Publisher()
            newPub.name = "Fox News"
            newPub.idx = "fox"
            newPub.isFollowing = false
            self.publis.append(newPub)
            let newPub1 = Publisher()
            newPub1.name = "The New York Times"
            newPub1.idx = "nyt"
            newPub1.isFollowing = false
            self.publis.append(newPub1)
            let newPub2 = Publisher()
            newPub2.name = "CNN"
            newPub2.idx = "cnn"
            newPub2.isFollowing = false
            self.publis.append(newPub2)
        }
        self.tablerView.reloadSections([0], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
          let image = UIImage(named: "news")
        if indexPath.section == 0 {
          
            let cell1 = tablerView.dequeueReusableCell(withIdentifier: "cellSearch1", for: indexPath) as! FirstSearchTableViewCell
            cell1.productVC = self
            cell1.whatSection = 1
            cell1.buttonMoveon.tag = 1
            cell1.publis = publis
            if indexPath.row == 1 {
                cell1.labelAbove.text = "Tags"
            cell1.buttonMoveon.setTitle("+ Over 100 other tags >", for: .normal)
                cell1.whatSection = 2
                cell1.buttonMoveon.tag = 2
              //  cell1.tags = tags
            }
            cell1.buttonMoveon.addTarget(self, action: #selector(self.MoveToPubsOrTags(sender:)), for: .touchUpInside)
            return cell1
            
            
        }
        if indexPath.section == 1 {
            if trendArts.count == 0 {
                let cellNothing = tablerView.dequeueReusableCell(withIdentifier: "nonethingCell", for: indexPath) as! nonethingCell
                cellNothing.contentView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
                 cellNothing.selectionStyle = .none
                return cellNothing
            }
            let rowNumber = indexPath.row
            let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSearch2", for: indexPath) as! SecondSearchTableViewCell
            
            cell.buttonExternalLink.tag = rowNumber
            cell.buttonExternalLink.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
            if let urli = trendArts[rowNumber].imageUrl {
                if urli != "none" {
                    let url = URL(string: urli)
                    cell.imagerView.kf.setImage(with: url, placeholder: image)
                } else {
                    cell.imagerView.image = UIImage(named: "news")
                }
            } else {
                cell.imagerView.image = UIImage(named: "news")
            }
            cell.titleLabel.text = trendArts[rowNumber].titler
            // cell.countActiveLabel.text = "37"
            cell.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
            
            cell.publisherImage.image = nil
            
         
            
            if let urlOfPub = trendArts[rowNumber].publisherUrl {
                if urlOfPub == "none" {
                    cell.labelPubli.text = "\n\(trendArts[rowNumber].publisher!)"
                } else {
                    cell.labelPubli.text = ""
                    let url = URL(string: urlOfPub)
                    cell.publisherImage.kf.setImage(with: url)
                }
            }
            
            cell.timeLabel.text = trendArts[rowNumber].time
            cell.viewLabel.text = "\(trendArts[rowNumber].views!) views"
            cell.countActiveLabel.text = "\(trendArts[rowNumber].active!)"
            
            if let urLikeDislike = trendArts[rowNumber].personalLikeDis {
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
            
            if let ratio = trendArts[rowNumber].ratio {
                cell.percentLabel.text = "\(ratio)%"
                if ratio >= 50 {
                    cell.percentLabel.textColor = UIColor(red: 0, green: 0.7686, blue: 0.3451, alpha: 1.0)
                } else {
                    cell.percentLabel.textColor = UIColor(red: 0.7373, green: 0.1961, blue: 0, alpha: 1.0)
                }
            }
            if let comCount = trendArts[rowNumber].comCount {
                               if comCount == 1 {
                                   cell.externalImage.image = #imageLiteral(resourceName: "feedChat")
                               } else {
                                   cell.externalImage.image = nil
                               }
                           } else {
                               cell.externalImage.image = nil
                           }
            
            if let bias = trendArts[rowNumber].bias {
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
            //            activity.removeFromSuperview()
            //            activity.stopAnimating()
            return cell
        
        }
        if indexPath.section == 2 {
            
            if self.suggestedUsers.count == 0 {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellSearch4", for: indexPath) as! suggestedMessage
                cell3.buttonShareApp.addTarget(self, action: #selector(self.sharePolitic), for: .touchUpInside)
              return cell3
            }
            let image = UIImage(named: "profile")
            let cell1 = tablerView.dequeueReusableCell(withIdentifier: "cellSearch3", for: indexPath) as! ThirdSearchTableViewCell
            if suggestedUsers.count > 0 {
                cell1.nameLabel.text = suggestedUsers[indexPath.row].namer
                cell1.followerCount.text = suggestedUsers[indexPath.row].username
                if let urli = suggestedUsers[indexPath.row].profilePhotoUrl {
                    if urli != "none" {
                        let url = URL(string: urli)
                        cell1.imagerView.kf.setImage(with: url, placeholder: image)
                    } else {
                        cell1.imagerView.image = UIImage(named: "profile")
                    }
                } else {
                    cell1.imagerView.image = UIImage(named: "profile")
                }
            }
            return cell1
         
        }
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellSearch1", for: indexPath) as! FirstSearchTableViewCell
        return cell
    }

    @objc func MoveToPubsOrTags (sender: UIButton) {
      
        if sender.tag == 1 {
        tagedOrNot = 1
        }
        if sender.tag == 2 {
           tagedOrNot = 2
        }
       self.performSegue(withIdentifier: "seguePubTag", sender: self)
    }
    
    var tagedOrNot: Int?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tablerView: UITableView!
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            if self.suggestedUsers.count != 0 {
                let vx: UserViewController? = UserViewController()
                let aObjNavi = UINavigationController(rootViewController: vx!)
                DispatchQueue.main.async {
                     aObjNavi.modalPresentationStyle = .fullScreen
                    vx!.namer = self.suggestedUsers[indexPath.row].namer
                    let celler = self.tablerView.cellForRow(at: indexPath) as! ThirdSearchTableViewCell
                    vx!.profilePhoto = celler.imagerView.image
                    vx!.theirUid = self.suggestedUsers[indexPath.row].uider
                    vx!.userKey = self.suggestedUsers[indexPath.row].userKey
                    self.present(aObjNavi, animated: true, completion: nil)
                }
            }
        }
        if indexPath.section == 1 {
            if trendArts.count != 0 {
            if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedArt") as? SelectedArticleViewController {
                if let cell2 = tablerView.cellForRow(at: indexPath) as? SecondSearchTableViewCell {
                           if let imager = cell2.imagerView.image {
                            destination.img = imager
                    }
                }
                
                destination.timer = trendArts[indexPath.row].time
                destination.delegate = self
                destination.indexPathi = indexPath
                
                if let personalLikeDis = trendArts[indexPath.row].personalLikeDis {
                    destination.personLikeDis = personalLikeDis
                }
                if let urlPub = trendArts[indexPath.row].publisherUrl {
                                            if urlPub != "none" {
                                                destination.publisherImageUrl = urlPub
                                            }
                                        }
                destination.titler = trendArts[indexPath.row].titler
                destination.cell = "1"
                destination.publisher = trendArts[indexPath.row].publisher
                destination.urlToLoad = trendArts[indexPath.row].mainUrl
                destination.aid = trendArts[indexPath.row].aid
                if let navigator = navigationController {
                    navigator.pushViewController(destination, animated: true)
                }
            }
            }
        }
       
        else if indexPath.section == 0 {
              DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueSelectedSearch", sender: self)
            }
        }
        
    }
    
    @objc func clickedOnExternalLink (sender: UIButton) {
        if self.trendArts.count > 0 {
        if let url = trendArts[sender.tag].mainUrl {
            if let mySavedDes = UserDefaults.standard.value(forKey: "dataLog") as? Int {
                       if mySavedDes >= 4 {
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
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    */

    var selectedIndx : Int?
    var tagOrPub: Int?
    
    var checlArray = [String]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("seguing")
       self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        if let dest = segue.destination as? SelectedSearchViewController {
            if let selectedIndex = selectedIndx {
                if let tagOrPubi = tagOrPub {
                    if tagOrPubi == 1 {
                dest.publisher = publis[selectedIndex].name
                print(selectedIndex)
                    }
                    if tagOrPubi == 2 {
                      //  dest.tagName = tags[selectedIndex].title
                    }
                }
            }
        }
         if let dest = segue.destination as? PublishersTagsViewController {
            if let tagOrPub = tagedOrNot {
                if tagOrPub == 1 {
                    dest.pub = "true"
                }
                if tagOrPub == 2 {
                    dest.tag = "true"
                }
            }
        }
        
    }
    
    var cantRefUntilDone = true
    func grabTending () {
        var reloadBecAdd = false
        
        var trendSort = [trendObj]()
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        let ref = Database.database().reference().child("Feed")
        ref.queryLimited(toLast: 50).queryOrdered(byChild: "publishedAt").observeSingleEvent(of: .value, with: {(snapshot) in
            if let values = snapshot.value as? [String : AnyObject] {
                  let dispatcherGroup = DispatchGroup()
                for (_,each) in values {
                    if let views = each["views"] as? String, let aid = each["aid"] as? String {
                     let objc = trendObj()
                    objc.views = Int(views)
                    objc.aid = aid
                    trendSort.append(objc)
                    }
                }
                
                 trendSort = trendSort.sorted(by: { $0.views > $1.views})
                var count = 0;
                let trendCount = trendSort.count
                var numberGoOff = 3
                if trendCount >= 3 {
                    //
                } else {
                    numberGoOff = trendCount
                }
                while count < numberGoOff {
                    dispatcherGroup.enter()
                    if let aid = trendSort[count].aid {
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
                                
                                // let current = self.articles.count + 1
                                
                                
                                // newArt.arraySpot = current
                               
                                
                                if let comCount = valuei?["comCount"] as? String {
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
                                    print("GOT A LIKE")
                                }
                                
                                if dislikeArraySave.contains(aid) {
                                    newArt.personalLikeDis = "Dislike"
                                }
                                newArt.mainUrl = url
                                
                                // newArt.publisher = "Nyt"
                                newArt.titler = titler
                                
                                if let views = valuei?["views"] as? String {
                                    newArt.views = Int(views)
                                } else {
                                    newArt.views = 0
                                }
                                
                                
                                
                                if self.checlArray.contains(url) {
                                    
                                } else if self.trendArts.count <= 3  {
                                    if self.inRefresh == true {
                                        if self.trendArts.count == 3 {
                                        self.trendArts.remove(at: self.trendArts.count-1)
                                        self.trendArts.insert(newArt, at: 0)
                                        self.checlArray.append(url)
                                        }
                                    } else {
                                     self.checlArray.append(url)
                                    self.trendArts.append(newArt)
                                    }
                                   reloadBecAdd = true
                                }
                                
                                
                            }
                            dispatcherGroup.leave()
                        })
                        
                    }
                    count+=1
                }
                  dispatcherGroup.notify(queue: DispatchQueue.main) {
                    if reloadBecAdd == true {
                        if self.inRefresh == true {
                            self.refreshControl.endRefreshing()
                            self.oneCallRef = false
                            self.inRefresh = false
                        }
                        self.cantRefUntilDone = false
                    self.tablerView.reloadSections([1], with: .automatic)
                    self.acivit.stopAnimating()
                    } else {
                        self.refreshControl.endRefreshing()
                        self.oneCallRef = false
                        self.inRefresh = false
                        self.cantRefUntilDone = false
                    }
                }
            } else {
                if self.inRefresh == true {
                    self.refreshControl.endRefreshing()
                    self.oneCallRef = false
                    self.inRefresh = false
                    self.cantRefUntilDone = false
                }
            }
            
        })
    }
 
    @objc func sharePolitic () {
      let activityVc = UIActivityViewController(activityItems: ["https://apps.apple.com/us/app/politic/id1438028803"], applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = self.view
        DispatchQueue.main.async {
            self.present(activityVc, animated: true, completion: nil)
        }
    }
    
    @objc func moveToSearch () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchingNVC")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
            
            if let celler = tablerView.cellForRow(at: index) as? SecondSearchTableViewCell {
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
        
        self.trendArts[index.row].personalLikeDis = type
        
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
        
        if trendArts.count > 0 {
            
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
                    self.trendArts[index.row].bias = newInty
                    
                }
                else {
                    
                    let upRef = Database.database().reference().child("Feed").child(aid)
                    let feedo: [String : Any] = ["bias" : "\(biasScore)"]
                    upRef.updateChildValues(feedo)
                    let inty = roundf(biasScore)
                    let newInty = Int(inty)
                    self.trendArts[index.row].bias = newInty
                    
                }
                
            })
            
        }
    }
    
    
}


class trendObj: NSObject {
    var aid: String!
    var views: Int!
}

// 250 hieght
class suggestedMessage: UITableViewCell {
    let buttonShareApp = UIButton()
    let labelExplain = UILabel()
    let labelMessage = UILabel()
    override func layoutSubviews() {
        labelMessage.text = "Thank You"
        labelExplain.text = "Simply put, words cannot explain the time and effort to make this app. And as you may see, you are part of this amazing project before the masses. Each person to use this app, means we are all one step closer to seeing this become THE app for politics. Simply sharing this app with just one person in your contacts, can make such a difference."
        buttonShareApp.frame = CGRect(x: 80, y: contentView.frame.height - 70, width: contentView.frame.width - 160, height: 50)
        buttonShareApp.setTitle("Share Politic", for: .normal)
        buttonShareApp.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 19)
        buttonShareApp.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
        buttonShareApp.clipsToBounds = true
        buttonShareApp.titleLabel?.textColor = .white
        buttonShareApp.layer.cornerRadius = 20.0
        
        labelMessage.frame = CGRect(x: contentView.frame.midX - 100, y: 20, width: 200, height: 30)
        labelMessage.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        labelMessage.textColor = .white
        labelMessage.textAlignment = .center
        
        labelExplain.frame = CGRect(x: 12, y: 60, width: contentView.frame.width - 24, height: 160)
        labelExplain.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        labelExplain.numberOfLines = 0
        labelExplain.textColor = .lightGray
        labelExplain.textAlignment = .center
        
        contentView.addSubview(buttonShareApp)
        contentView.addSubview(labelMessage)
        contentView.addSubview(labelExplain)
        
        
        
    }
    
    
    
}


class nonethingCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(red: 0.0588, green: 0.0588, blue: 0.0588, alpha: 1.0)
        // Initialization code
        self.selectionStyle = .none
    }
    override func layoutSubviews() {
        
    }
}
