//
//  ArticleInfoViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/3/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class ArticleInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tablerView = UITableView()
    
    var aid: String?
    var publisher: String?
    var titler: String?
    var mainUlr: String?
    var datePublished: String?
    var likes: Int?
    var dislikes: Int?
    var comments: Int?
    var views: Int?
    let labelTop = UILabel()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    let buttonOpen = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        layoutViews()
        self.navigationItem.title = "Article Info"
        tablerView.register(InfoArticleTableViewCell.self, forCellReuseIdentifier: "cellInfo")
        tablerView.delegate = self
        tablerView.dataSource = self
        tablerView.allowsSelection = false
        tablerView.estimatedRowHeight = 40
        tablerView.rowHeight = UITableView.automaticDimension
        tablerView.separatorStyle = .none
        if let titler = self.titler {
            self.info.append("Title: \(titler)")
             self.labelTop.removeFromSuperview()
        } else {
            self.labelTop.frame = CGRect(x: 25, y: self.view.frame.height / 4, width: self.view.frame.width - 50, height: 70)
            self.labelTop.font = UIFont(name: "Avenir-Medium", size: 22)
            self.labelTop.numberOfLines = 2
            self.labelTop.text = "Sorry this is not loading right now :/"
            self.labelTop.textAlignment = .center
            self.labelTop.textColor = UIColor.darkGray
            self.view.addSubview(self.labelTop)
        }
        if let pub = self.publisher {
            self.info.append("Publisher: \(pub)")
            self.labelTop.removeFromSuperview()
        }
        if let date = self.datePublished {
            self.info.append("Published: \(date)")
        }
        if let likes = self.likes {
            self.info.append("Likes: \(likes)")
        }
        if let dislikes = self.dislikes {
            self.info.append("Dislikes: \(dislikes)")
        }
        if let views = self.views {
            self.info.append("Views: \(views)")
        }
        if let aid = self.aid {
            self.grabCommCount(aid: aid)
        }
        
        buttonOpen.frame = CGRect(x: 40, y: self.view.frame.height - 180, width: self.view.frame.width - 80, height: 45)
               buttonOpen.setBackgroundImage(UIImage(named: "empty"), for: .normal)
               buttonOpen.titleLabel?.textColor = .white
               buttonOpen.setTitle("Open Article", for: .normal)
              
        buttonOpen.clipsToBounds = true
        buttonOpen.layer.cornerRadius = 12.0
                   buttonOpen.addTarget(self, action: #selector(self.openUrl), for: .touchUpInside)
                   self.view.addSubview(buttonOpen)
               
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: {
            self.buttonOpen.removeFromSuperview()
        })
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"moreMenu"), style: .plain, target: self, action: nil)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return info.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    var info = [String]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! InfoArticleTableViewCell
        if info.count != 0 {
        cell.textLabel?.text = info[indexPath.section]
        cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutViews () {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .grouped)
        view.addSubview(tablerView)
        
    }

    func grabCommCount (aid: String) {
        let ref = Database.database().reference().child("artItems").child(aid).child("comments")
        ref.observeSingleEvent(of: .value, with: {(snap) in
            if let values = snap.value as? [String : AnyObject] {
                self.info.append("Comments: \(values.count)")
            } else {
                 self.info.append("Comments: 0")
            }
            self.tablerView.reloadData()
        })
    }
    
    @objc func openUrl() {
        if let url = self.mainUlr {
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
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
