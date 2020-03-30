//
//  SearchingViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 10/30/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase


class SearchingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, changedValues {

    let searchController = UISearchController(searchResultsController: nil)
    
    //var myId = "o"
     var allowCancel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.grabSuggestedUser()
        tablerView.delegate = self
        tablerView.dataSource = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.barTintColor = .darkText
        tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        definesPresentationContext = true
        tablerView.tableHeaderView = searchController.searchBar
       searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Users and articles"
        searchController.searchBar.autocapitalizationType = .words
        
        
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                  self.allowCancel = true
              })
       
        // Do any additional setup after loading the view.
    }
    var filteredStuff = [searchObject]()
    var stuff = [searchObject]()
    
   
   
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
 
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    var stillOn = false
    override func viewWillAppear(_ animated: Bool) {
        if stillOn == false {
        self.searchController.isActive = true
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    var arts = [Article]()
    var artsf = [Article]()
    var useris = [Useri]()
    var userisf = [Useri]()
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if UIDevice().userInterfaceIdiom == .pad {
               return 80
            }
            return 60
        }
        if indexPath.section == 1 {
            return 170
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text == "" {
           arts = artsf
            useris = userisf
            if section == 0 {
                return useris.count
            }
            if section == 1 {
                return arts.count
            }
        }
        if searchController.searchBar.text != "" {
            if section == 0 {
             
                return useris.count
            }
           
            if section == 1 {
              
                return arts.count
             
            }
            
        }
        if filteredStuff.count > 30 {
            return 30
        }
        return filteredStuff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = UIImage(named: "profile")
        let image2 = UIImage(named: "news")
        if indexPath.section == 0 {
            let cell1 = tablerView.dequeueReusableCell(withIdentifier: "searching1", for: indexPath) as! searchingCell1
            if useris.count > 0 {
                cell1.selectionStyle = .none 
            cell1.namerLabel.text = useris[indexPath.row].namer
            cell1.usernameLabel.text = useris[indexPath.row].username
            if let urli = useris[indexPath.row].profilePhotoUrl {
                if urli != "none" {
                    let url = URL(string: urli)
                    cell1.profileImage.kf.setImage(with: url, placeholder: image)
                } else {
                    cell1.profileImage.image = UIImage(named: "profile")
                }
            } else {
                cell1.profileImage.image = UIImage(named: "profile")
            }
            }
            return cell1
            
        }
        if indexPath.section == 1 {
            let cell2 = tablerView.dequeueReusableCell(withIdentifier: "searching2", for: indexPath) as! searchingCell2
            cell2.titleLabel.text = arts[indexPath.row].titler
            cell2.timeLabel.text = arts[indexPath.row].time
            cell2.labelPubli.text = arts[indexPath.row].publisher
            cell2.buttonExternalLink.tag = indexPath.row
            cell2.buttonExternalLink.addTarget(self, action: #selector(self.clickedOnExternalLink(sender:)), for: .touchUpInside)
            if let urli = arts[indexPath.row].imageUrl {
                if urli != "none" {
                    let url = URL(string: urli)
                    cell2.imagerView.kf.setImage(with: url, placeholder: image2)
                } else {
                    cell2.imagerView.image = UIImage(named: "news")
                }
            } else {
                cell2.imagerView.image = UIImage(named: "news")
            }
            
            if let bias = arts[indexPath.row].bias {
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
        
        let cell = tablerView.dequeueReusableCell(withIdentifier: "searching1", for: indexPath) as! searchingCell1
        return cell
    }
    var viewJustLoad = false
    var inSearch = false
    var refresher: Bool?
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("editing")
        tablerView.refreshControl = nil
        refresher = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inSearch = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if (!tablerView.isDragging && !tablerView.isDecelerating) {
            if searchController.searchBar.text == "" {
                arts = artsf
                useris = userisf
               
                if refresher == true || viewJustLoad == false {
                    tablerView.reloadData()
                    viewJustLoad = true
                } else {
                    print("dont reload")
                }
                
            }
            else {
                viewJustLoad = true
                let texter = searchController.searchBar.text!
                if texter.count > 1 {
                    refresher = true
                    if inSearch != true {
                  pullUsersByName(input: texter)
                    pullArtsByName(input: texter)
                    }
                    print("running")
                }
                
            }
        }
        
    }
    
    let refreshControl = UIRefreshControl()
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if self.allowCancel == true {
        self.dismiss(animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        let labeler = UILabel()
        if section == 0 {
            labeler.text = "Users"
        }
        
        if section == 1 {
            labeler.text = "Articles"
        }
        labeler.frame = CGRect(x: 10, y: 2, width: 140, height: 26)
        labeler.textAlignment = .left
        labeler.textColor = .white
        labeler.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        viewer.addSubview(labeler)
        return viewer
    }
    
    @IBOutlet weak var tablerView: UITableView!
    
    
    func grabSuggestedUsers () {
        
    }
    
    func grabSuggestedArticles () {
        
    }
    
    
    func pullUsersByName (input: String) {
print("CALLED HERE NAME")
     let uid = Auth.auth().currentUser?.uid
            
            useris.removeAll()
            let ref = Database.database().reference().child("users")
            ref.queryLimited(toLast: 6).queryOrdered(byChild: "name").queryStarting(atValue: input).queryEnding(atValue: "\(input)\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                if let userer = snapshot.value as? [String : AnyObject] {
                    print("\(userer.count) name print count")
                    for (_, each) in userer {
                        if let usernamer = each["username"] as? String, let namerl = each["name"] as? String, let uiderl = each["uid"] as? String{
                            let newr = Useri()
                            newr.username = usernamer
                            newr.namer = namerl
                            newr.uider = uiderl
                            if let urler = each["profileUrl"] as? String {
                                newr.profilePhotoUrl = urler
                            } else {
                                newr.profilePhotoUrl = "none"
                            }
                            if let theirKey = each["userKey"] as? String {
                                newr.userKey = theirKey
                            }
                          
                            print("onne")
                            if self.useris.contains( where: { $0.uider == newr.uider } ) || newr.uider == uid {
                                print("no")
                            } else {
                                if self.useris.count < 5 {
                                   
                                            self.useris.append(newr)
                                    
                                }

                            }

                        }
                    }
                   // self.activityIndc.stopAnimating()
                    
                    self.tablerView.reloadData()

                } else {
                    let inputer = input.lowercased()
                    self.pullUsersByUsername(input: inputer)
                }
            }, withCancel: nil)
        

    }

    func pullUsersByUsername (input: String) {
        let uid = Auth.auth().currentUser?.uid
        
            useris.removeAll()
            let ref = Database.database().reference()
            ref.child("users").queryOrdered(byChild: "username").queryStarting(atValue: input).queryEnding(atValue: "\(input)\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                if let userer = snapshot.value as? [String : AnyObject] {
                  print("\(userer.count) username print count")
                    for (_, each) in userer {
                        if let usernamer = each["username"] as? String, let namerl = each["name"] as? String, let uiderl = each["uid"] as? String {
                            let newr = Useri()
                            newr.username = usernamer
                            newr.namer = namerl
                            newr.uider = uiderl
                            if let urler = each["profileUrl"] as? String {
                                newr.profilePhotoUrl = urler
                            } else {
                                newr.profilePhotoUrl = "none"
                            }
                            if let theirKey = each["userKey"] as? String {
                                newr.userKey = theirKey
                            }
                           
                            print("onne")
                            if self.useris.contains( where: { $0.uider == newr.uider } ) || newr.uider == uid {
                                print("no")
                            } else {
                                if self.useris.count < 5 {
                        
                                    
                                self.useris.append(newr)
                                    
                                    
                                
                                }

                            }

                        }
                        //self.activityIndc.stopAnimating()
                    }
                    

                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.tablerView.reloadData()
                })
            }, withCancel: nil)
        
    }


    
    func pullArtsByName (input: String) {
        
        
            arts.removeAll()
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
            let ref = Database.database().reference().child("Feed")
            ref.queryLimited(toLast: 6).queryOrdered(byChild: "title").queryStarting(atValue: input).queryEnding(atValue: "\(input)\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                if let titlr = snapshot.value as? [String : AnyObject] {
                    print("\(titlr.count) article print count")
                    for (_, each) in titlr{
                        if let titler = each["title"] as? String, let url = each["url"] as? String, let namert = each["publisher"] as? String, let publishedAt = each["publishedAt"] as? String, let aid = each["aid"] as? String {
                            let newArt = Article()
                            let stringl = namert
                            let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                            let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                            newArt.publisher = last.capitalized
                            
                          
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                            let newpdate = dateFormatter.date(from: publishedAt)
                            if let localiDate = newpdate {
                                let timey = Date().offset(from: localiDate)
                                print("hired \(timey) by name")
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
                            if likeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Like"
                                print("GOT A LIKE")
                            }
                            
                            if dislikeArraySave.contains(aid) {
                                newArt.personalLikeDis = "Dislike"
                            }
                            
                            
                            newArt.aid = aid
                            
                            if let urlImg = each["urlToImage"] as? String {
                                newArt.imageUrl = urlImg
                            } else {
                                newArt.imageUrl = "none"
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
                            
                            newArt.titler = titler
                            newArt.mainUrl = url
                                    if self.arts.contains( where: { $0.mainUrl == newArt.mainUrl } ) {
                                                            print("no")
                                    } else {
                                        if self.arts.count < 5 {
                                            
                                        self.arts.append(newArt)
                                            
                                            }
                            
                                        }
                            
                        }
                    }
                    // self.activityIndc.stopAnimating()
                    
                  
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.tablerView.reloadData()
                })
            }, withCancel: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vx: UserViewController? = UserViewController()
            let aObjNavi = UINavigationController(rootViewController: vx!)
            DispatchQueue.main.async {
                if self.useris.count > 0 {
                    aObjNavi.modalPresentationStyle = .fullScreen
                vx!.namer = self.useris[indexPath.row].namer
                let celler = self.tablerView.cellForRow(at: indexPath) as! searchingCell1
                vx!.profilePhoto = celler.profileImage.image
                vx!.theirUid = self.useris[indexPath.row].uider
                 vx!.userKey = self.useris[indexPath.row].userKey
                self.present(aObjNavi, animated: true, completion: nil)
                self.stillOn = true
                }
            }
        }
        if indexPath.section == 1 {
             if self.arts.count > 0 {
            if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedArt") as? SelectedArticleViewController {
                if let cell = tablerView.cellForRow(at: indexPath) as? searchingCell2 {
                                                         if let imager = cell.imagerView.image {
                                                          destination.img = imager
                                                  }
                                              }
                destination.titler = self.arts[indexPath.row].titler
                destination.delegate = self
                destination.indexPathi = indexPath
                //destination.useID = self.myId
                if let containsMyPersonalLikeDis = self.arts[indexPath.row].personalLikeDis {
                    destination.personLikeDis = containsMyPersonalLikeDis
                }
                self.refresher = false
                self.inSearch = true 
                destination.cell = "1"
                destination.publisher = arts[indexPath.row].publisher
                destination.urlToLoad = arts[indexPath.row].mainUrl
                destination.aid = arts[indexPath.row].aid
                if let navigator = navigationController {
                    navigator.pushViewController(destination, animated: true)
                }
            }
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
        inSearch = true
    }
    
    func grabSuggestedUser () {
        let ref = Database.database().reference().child("bigUsers")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let users = snapshot.value as? [String : String] {
                 let dispatcherGroup = DispatchGroup()
                for (_,eachi) in users {
                      dispatcherGroup.enter()
                    let ref2 = Database.database().reference().child("users").child(eachi)
                    ref2.observeSingleEvent(of: .value, with: {(snap) in
                     
                            
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
                                    if self.userisf.contains( where: { $0.uider == newr.uider } ) || newr.uider == Auth.auth().currentUser?.uid {
                                        print("no")
                                    } else {
                                        if self.userisf.count < 5 {
                                            
                                            
                                            self.userisf.append(newr)
                                            
                                        }
                                        
                                    }
                                
                            
                            }
                        dispatcherGroup.leave()
                    })
                }
                dispatcherGroup.notify(queue: DispatchQueue.main) {
                    print("CALLED GET SUGGESTED ARTS")
                    self.getSuggestedArts()
                    return
                }
            }
        })
    }
    
    
    func getSuggestedArts () {
      let radOne = Float.random(in: -2..<2)
        print("RADONE = \(radOne)")
        let defaults = UserDefaults.standard
        let likeArraySave = defaults.stringArray(forKey: "likedArray") ?? [String]()
        let dislikeArraySave = defaults.stringArray(forKey: "dislikeArray") ?? [String]()
        let ref = Database.database().reference().child("Feed")
        ref.queryLimited(toLast: 50).queryOrdered(byChild: "publishedAt").observeSingleEvent(of: .value, with: { (snapshot) in
            let rounder = roundf(radOne)
            if let titlr = snapshot.value as? [String : AnyObject] {
                print("\(titlr.count) article print count")
                for (_, each) in titlr{
                    if let biasit =  each["bias"] as? String {
                        if let intitver = Float(biasit) {
                        if roundf(intitver) == rounder {
                    if let titler = each["title"] as? String, let url = each["url"] as? String, let namert = each["publisher"] as? String, let publishedAt = each["publishedAt"] as? String, let aid = each["aid"] as? String  {
                        let newArt = Article()
                        let stringl = namert
                        let newString = stringl.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
                        let last = newString.replacingOccurrences(of: ".com", with: "", options: .literal, range: nil)
                        newArt.publisher = last.capitalized
                        
                        
                        
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
                        
                        
                        if likeArraySave.contains(aid) {
                            newArt.personalLikeDis = "Like"
                            print("GOT A LIKE")
                        }
                        
                        if dislikeArraySave.contains(aid) {
                            newArt.personalLikeDis = "Dislike"
                        }
                        
                        newArt.aid = aid
                        
                        if let urlImg = each["urlToImage"] as? String {
                            newArt.imageUrl = urlImg
                        } else {
                            newArt.imageUrl = "none"
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
                        
                        newArt.titler = titler
                        newArt.mainUrl = url
                        if self.artsf.contains( where: { $0.mainUrl == newArt.mainUrl } ) {
                            print("no")
                        } else {
                            if self.artsf.count < 5 {
                                print("added one to artsf")
                                self.artsf.append(newArt)
                                
                            }
                            
                        }
                        }
                    }
                    }
                }
                }
                // self.activityIndc.stopAnimating()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.tablerView.reloadData()
                })
                
            }
        }, withCancel: nil)
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
        
        print(artsf.count)
      
            print("updating bias score")
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
                    
                //    let inty = roundf(biasScore)
                    
                  //  let newInty = Int(inty)
                //    self.artsf[index.row].bias = newInty
                    
                
                }
                else {
                    
                    let upRef = Database.database().reference().child("Feed").child(aid)
                    let feedo: [String : Any] = ["bias" : "\(biasScore)"]
                    upRef.updateChildValues(feedo)
                 //   let inty = roundf(biasScore)
                 //   let newInty = Int(inty)
                  //  self.artsf[index.row].bias = newInty
                    
                }
                
            })
            
        
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




class searchingCell1: UITableViewCell {
    var namerLabel = UILabel()
    var usernameLabel = UILabel()
    var profileImage = UIImageView()
    
    
    override func layoutSubviews() {
        profileImage.frame = CGRect(x: 15, y: 5, width: 50, height: 50)
        profileImage.layer.cornerRadius = 25
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        namerLabel.frame = CGRect(x: 70, y: 8, width: contentView.frame.width - 78, height: 25)
        namerLabel.font = UIFont(name: "HelveticaNeue-Heavy", size: 17)
        namerLabel.textAlignment = .left
        namerLabel.textColor = .white
        
        usernameLabel.frame = CGRect(x: 70, y: 30, width: contentView.frame.width - 78, height: 25)
        usernameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        usernameLabel.textAlignment = .left
        usernameLabel.textColor = .lightGray
        
        contentView.addSubview(profileImage)
        contentView.addSubview(namerLabel)
        contentView.addSubview(usernameLabel)
        
    }
    
    
}

class searchingCell2: UITableViewCell {
    
    var titleLabel = UILabel()
    var imagerView = UIImageView()
    var timeLabel = UILabel()
    var labelPubli = UILabel()
     let shapeLayer = CAShapeLayer()
    var externalImage = UIImageView()
    var buttonExternalLink = UIButton()
    
    override func layoutSubviews() {
        
        imagerView.contentMode = .scaleAspectFill
        
        imagerView.clipsToBounds = true
        imagerView.layer.cornerRadius = 8
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
        titleLabel.textColor = .white
        timeLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .left
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imagerView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(labelPubli)
        imagerView.addSubview(externalImage)
        externalImage.addSubview(buttonExternalLink)
        
        externalImage.layer.cornerRadius = 20.0
               externalImage.layer.shadowColor = UIColor.black.cgColor
               externalImage.layer.shadowOffset = CGSize(width: 0, height: 2)
                externalImage.layer.shadowOpacity = 1
               imagerView.isUserInteractionEnabled = true
        
        externalImage.frame = CGRect(x: 5, y: 5, width: 23, height: 23)
        externalImage.image = #imageLiteral(resourceName: "xternal")
        externalImage.contentMode = .scaleAspectFill
        externalImage.isUserInteractionEnabled = true
        buttonExternalLink.frame = CGRect(x: 0, y: 0, width: externalImage.frame.width, height: 22)
        buttonExternalLink.setTitle("", for: .normal)
        
        self.imagerView.frame = CGRect(x: 15, y: 43, width: 170, height: 100)
        //self.titleLabel.frame = CGRect(x: width - 182, y: 40, width: 176, height: 90)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5).isActive = true
        
        //timeLabel.frame = CGRect(x: width - 182, y: 126, width: 80, height: 20)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
        self.selectionStyle = .none
        labelPubli.textColor = .lightGray
        labelPubli.numberOfLines = 1
        labelPubli.setLineHeight(lineHeight: 5)
        labelPubli.font = UIFont(name: "Courier", size: 14)
        labelPubli.frame = CGRect(x: 15, y: 8, width: 300, height: 30)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                titleLabel.numberOfLines = 3
                self.imagerView.frame = CGRect(x: 15, y: 43, width: 140, height: 100)
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
                timeLabel.leadingAnchor.constraint(equalTo: imagerView.trailingAnchor, constant: 12).isActive = true
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
                timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28).isActive = true
                
            default:
                print("Unknown")
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 26)
            //titleLabel.numberOfLines = 4
        }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: imagerView.frame.width - 25, y: -15))
        path.addLine(to: CGPoint(x: imagerView.frame.width+20, y: imagerView.frame.height+15))
         shapeLayer.lineWidth = 40.0
        shapeLayer.path = path.cgPath
        imagerView.layer.addSublayer(shapeLayer)
    }
    // publisher
}


