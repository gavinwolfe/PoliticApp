//
//  SettingsViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 9/14/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var essentials = ["Password", "Blocked Users", "Privacy Policy", "Terms of Service", "Report a problem", "Contact Us" , "About Politic", "App Settings", "Third party data", "Share Politic"]
    
    var tablerView = UITableView()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationItem.title = "Settings"
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isAnonymous == false  {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        }
        self.layout()
        tablerView.delegate = self
        tablerView.dataSource = self
        
        self.tablerView.register(cellSettings.self, forCellReuseIdentifier: "aSet")
        tablerView.separatorStyle = .none
        self.tablerView.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    var oneTimeGo = false
    @objc func logout () {
        if oneTimeGo == false  {
            self.oneTimeGo = true
        let alerto = UIAlertController(title: "Logout", message: "Sign out of your account?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Logout", style: .default, handler: { (action : UIAlertAction)
            in
            self.signOut()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginSignUpVc") as! LoginOrSignUpVcViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: {
                self.oneTimeGo = false
            })
        })
        let canceler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerto.addAction(action)
        alerto.addAction(canceler)
        self.present(alerto, animated: true, completion: nil)
        
    }
    }
    func signOut () {
        if Auth.auth().currentUser?.uid != nil {
            do {
                try! Auth.auth().signOut()
                print("logged out")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     //   self.navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return essentials.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "aSet") as! cellSettings
        cell.contentView.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        cell.labelCenter.text = essentials[indexPath.row]
        return cell
    }
    
    func layout () {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .plain)
        view.addSubview(tablerView)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 2 && indexPath.row != 3 && indexPath.row != 9 && Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isAnonymous == false {
        let vc = InsideSettingsViewController()
        if let navigator = navigationController {
            vc.indexLor = indexPath
            navigator.pushViewController(vc, animated: true)
        }
            
        }
        if Auth.auth().currentUser?.uid == nil || Auth.auth().currentUser?.isAnonymous == true  {
            if indexPath.row != 0 && indexPath.row != 1 {
                let vc = InsideSettingsViewController()
                if let navigator = navigationController {
                    vc.indexLor = indexPath
                    navigator.pushViewController(vc, animated: true)
                }
        }
    }
        if indexPath.row == 2 {
            
            UIApplication.shared.open(URL(string:"https://www.berlarksoftware.com/privacy")!, options: [:], completionHandler: nil)
        }
        if indexPath.row == 3 {
            UIApplication.shared.open(URL(string:"https://www.berlarksoftware.com/terms")!, options: [:], completionHandler: nil)
        }
        if indexPath.row == 9 {
           
            let activityVc = UIActivityViewController(activityItems: ["https://apps.apple.com/us/app/politic/id1438028803"], applicationActivities: nil)
            activityVc.popoverPresentationController?.sourceView = self.view
            DispatchQueue.main.async {
                self.present(activityVc, animated: true, completion: nil)
            }
        }
    }
    

}


class cellSettings: UITableViewCell {
    let labelCenter = UILabel()
    override func layoutSubviews() {
        labelCenter.frame = CGRect(x: 20, y: 5, width: contentView.frame.width, height: 40)
        labelCenter.textColor = .white
        contentView.addSubview(labelCenter)
        labelCenter.font =  UIFont(name: "HelveticaNeue-Medium", size: 26)
        self.selectionStyle = .none
    }
}
