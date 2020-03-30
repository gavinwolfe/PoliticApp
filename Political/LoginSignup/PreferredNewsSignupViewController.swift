//
//  PreferredNewsSignupViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class PreferredNewsSignupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        tablerView.dataSource = self
        tablerView.delegate = self
        self.navigationItem.title = "Preferences"
        nextButton.layer.cornerRadius = 6.0
        nextButton.clipsToBounds = true
        
        theNews()
        // Do any additional setup after loading the view.
    }
    
    func theNews () {
        
        for (i,each) in arrayOfPubs {
            let newVal = Publisher()
            newVal.name = i
            newVal.idx = each
            arrayPubs.append(newVal)
        }
        tablerView.reloadData()
    }
    
    
    var arrayPubs = [Publisher]()
    let arrayOfPubs = ["New York Times" : "nytx", "CNN": "cnnx", "NBC" : "nbcx", "FOX News" : "foxx", "Time" : "timex", "Washington Post" : "wpx", "USA Today" : "usatodayx", "Politico" : "politicox", "NPR" : "nprx", "MSN" : "msnx", "USNews" : "usnewsx", "ABC News" : "abcx", "Reuters" : "reutersx", "Newsweek" : "newsweekx"]

    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayPubs.count
    }
    
    var selected = [String]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "preferredCell", for: indexPath) as! PrefferedTableViewCell
       
        cell.textLabel?.text = arrayPubs[indexPath.section].name
        if selected.contains(arrayPubs[indexPath.section].idx) {
           cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            return nil
        }
        let viewer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 110))
        viewer.backgroundColor = .white
        let labelTop = UILabel(frame: CGRect(x: 15, y: 0, width: viewer.frame.width - 30, height: 90))
        labelTop.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        labelTop.numberOfLines = 4
        labelTop.text = "You have successfully created an account! Now try to select some news publishers you prefer. Some articles from these publishers will then show up in your feed."
        viewer.addSubview(labelTop)
        return viewer
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
        return 110
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selected.contains(arrayPubs[indexPath.section].idx) {
            selected = selected.filter{$0 != arrayPubs[indexPath.section].idx}
            tablerView.reloadRows(at: [indexPath], with: .none)
        } else {
         selected.append(arrayPubs[indexPath.section].idx)
       tablerView.reloadRows(at: [indexPath], with: .none)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selected = selected.filter{$0 != arrayPubs[indexPath.section].idx}
         tablerView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNextSelectPrefer", sender: self)
    }
    
    @IBOutlet weak var tablerView: UITableView!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
