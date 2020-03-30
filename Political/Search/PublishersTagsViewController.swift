//
//  PublishersTagsViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 4/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class PublishersTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var tag: String?
    var pub: String?
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        layoutViews()
        tablerView.register(PublishersAndTagsTableViewCell.self, forCellReuseIdentifier: "cellPubTag")
        tablerView.delegate = self
        tablerView.dataSource = self
        tablerView.estimatedSectionHeaderHeight = 5
        tablerView.estimatedSectionFooterHeight = 5
        tablerView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        //tablerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.frame.height)
       
      
            if #available(iOS 11.0, *) {
                self.tablerView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
            } else {
               self.automaticallyAdjustsScrollViewInsets = false;
            }
      
        
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
        
        
        if let tag = self.tag {
            print(tag)
        self.navigationItem.title = "Tags"
        }
        if let pub = self.pub {
            print(pub)
            self.navigationItem.title = "Publishers"
        }
        // Do any additional setup after loading the view.
    }
    let arrayOfPubs = ["The New York Times", "CNN", "CBS News", "MSNBC", "NBC News", "Fox News", "Time", "The Washington Post", "USA Today", "Politico", "USNews", "ABC News", "Reuters", "Newsweek", "Bloomberg", "Breitbart News", "New York Magazine","Fortune", "Reuters", "The Hill", "Independent", "National Review", "The American Conservative", "Vice News", "The Verge", "National Review"]
    
    //tages not used in v1.0 - v.01
    let arrayOfTages = ["Trump", "Opinion:","2020", "Democrats", "Republicans", "Economy", "Climate Change", "Racism", "Debt", "Discrimination", "College", "Bias", "Taxes", "Wealthy", "Poverty", "China" ,"Mexico", "EU", "States", "Courts", "Supreme Court", "Recession", "Barack Obama", "AOC", "Clinton", "Bernie Sanders", "Candidate", "GOP", "DNC", "Environment"]
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let pub = self.pub {
            print(pub)
            return arrayOfPubs.count
        }
        
        return arrayOfTages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "cellPubTag", for: indexPath) as! PublishersAndTagsTableViewCell
        if let tag = self.tag {
            print(tag)
        cell.textLabel?.text = arrayOfTages[indexPath.section]
        }
        if let pub = self.pub {
            print(pub)
             cell.textLabel?.text = arrayOfPubs[indexPath.section]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueClickedPubTag", sender: self)
      //  self.tablerView.deselectRow(at: indexPath, animated: true)
    }
    
    
    var tablerView = UITableView()
    
    
    func layoutViews () {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .grouped)
        view.addSubview(tablerView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.navigationBar.isTranslucent = false
        
         self.navigationController?.navigationBar.isHidden = false
    }
    
   
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.navigationBar.isHidden = true
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let dest = segue.destination as? SelectedSearchViewController {
            print("help")
            if let indexPath = tablerView.indexPathForSelectedRow {
                print("past")
                if let tager = self.tag {
                    print(tager)
                    
                    dest.tagName = self.arrayOfTages[indexPath.section]
                }
                if let publ = self.pub {
                    print(publ)
                    dest.publisher = self.arrayOfPubs[indexPath.section]
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

}
