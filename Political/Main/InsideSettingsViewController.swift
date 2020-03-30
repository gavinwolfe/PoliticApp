//
//  InsideSettingsViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 9/14/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class InsideSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var blocked = [Useri]()
    let buttonErt = UIButton()
    var tablerView =  UITableView()
    let botoonSave = UIButton()
    
     var labelFlurl = UILabel()
    var indexLor: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layout()
        tablerView.delegate = self
        tablerView.dataSource = self
        
        
        self.tablerView.register(blockedCell.self, forCellReuseIdentifier: "blockedCell")
        tablerView.separatorStyle = .none
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tablerView.backgroundColor = .black
        self.labelFlurl.frame = CGRect(x: 15, y: 60, width: self.view.frame.width - 30, height: self.view.frame.height - 200)
        self.labelFlurl.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        self.labelFlurl.textColor = .white
        self.tablerView.isHidden = true
        self.view.addSubview(labelFlurl)
        labelFlurl.numberOfLines = 0
        labelFlurl.textAlignment = .center
        if let indexPat = indexLor {
            if indexPat.row == 0 {
                self.navigationItem.title = "Password"
                
                botoonSave.frame = CGRect(x: 15, y: 100, width: self.view.frame.width - 30, height: 50)
                botoonSave.setTitle("Change Password", for: .normal)
                botoonSave.setTitleColor(.white, for: .normal)
                //botoonSave.backgroundColor = UIColor(red: 0, green: 0.4902, blue: 0.7176, alpha: 1.0)
                botoonSave.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
                botoonSave.layer.cornerRadius = 20.0
                botoonSave.clipsToBounds = true
                botoonSave.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
                botoonSave.addTarget(self, action: #selector(saverAct), for: .touchUpInside)
                
                view.addSubview(botoonSave)
                
                self.labelFlurl.isHidden = true
            }
            if indexPat.row == 1 {
                self.navigationItem.title = "Blocked Users"
                self.tablerView.isHidden = false
                self.tablerView.frame = CGRect(x: 10, y: 80, width: self.view.frame.width - 20, height: self.view.frame.height - 160)
                self.labelFlurl.isHidden = true
                self.grabBlocked()
                
                
            }
            if indexPat.row == 2 {
                
                
            }
            if indexPat.row == 4 {
                self.labelFlurl.text = "We strive to make Politic as friendly and groovy as possible, but we know that some things may go wrong. We encourage you to report any problems so our programmers(highly trained tree frogs) can fix them. Please email a problem you find at politicappcontact@gmail.com. If it is a user you would like to report, please email politicappcontact@gmail.com the user's username and a photo of the problem. Thank you"
                self.navigationItem.title = "Report a problem"
                self.labelFlurl.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: self.view.frame.height / 2)
                self.labelFlurl.numberOfLines = 20
                
            }
            
            if indexPat.row == 5 {
                self.labelFlurl.text = "We work hard to ensure that our application is great, and we hope you think so too. If you ever need to contact us, we are available. Please email politicappcontact@gmail.com, for any questions, comments, or concerns."
                self.labelFlurl.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: self.view.frame.height / 2)
                self.navigationItem.title = "Contact Us"
            }
            if indexPat.row == 6 {
                self.navigationItem.title = "About Politic"
                self.labelFlurl.frame = CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: self.view.frame.height / 2)
                self.labelFlurl.text = "Welcome to version Beta 1.06. This is the first version of Politic! Thus, technically the app is not perfect (there may be bugs D: ). But I promise we will scare the bugs away the more updates we create! Besides that, this update includes everything as a new feature, because well, it's brand new... Also! Stars, you get a star for each comment that gets more than 20 likes! Then your stars will appear on your profile. So yeah, enjoy the app, and thanks for being a part of this! - Gavin (:"
            }
            if indexPat.row == 7 {
                self.labelFlurl.isHidden = true
                self.navigationItem.title = "App Settings"
                let buttonEr = UIButton()
                buttonEr.setTitle("See App Settings", for: .normal)
                buttonEr.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 50)
                
                buttonEr.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
                buttonEr.setTitleColor(.white, for: .normal)
                buttonEr.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
               // buttonEr.backgroundColor = UIColor(red: 0, green: 0.4863, blue: 0.6078, alpha: 1.0)
                buttonEr.layer.cornerRadius = 20.0
                buttonEr.clipsToBounds = true
                buttonEr.addTarget(self, action: #selector(self.makeGoSettings), for: .touchUpInside)
                
                self.view.addSubview(buttonEr)
            }
            if indexPat.row == 8 {
self.navigationItem.title = "Third party data"
                self.labelFlurl.frame = CGRect(x: 10, y: 90, width: self.view.frame.width - 20, height: self.view.frame.height - 150)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "moreIcona"), style: .plain, target: self, action: #selector(self.openDSecty))
               self.labelFlurl.text =  "Please note that all third party data can be accessed prior to opening it in the app by clicking the link icon. All information (such as data files, written text, computer software, music, audio files or other sounds, photographs, videos or other images) which you may have access to as part of, or through your use of the Application, are the sole responsibility of the person or entity from which such content originated. All such information is referred to below as the Content presented to you through the Application, including but not limited to advertisements in the Application and sponsored Content presented within the Application may be protected by intellectual property rights which are owned by third parties. You may not modify, rent, lease, loan, sell, distribute or create derivative works based on this Content (either in whole or in part) unless you have been specifically told that you may do so by the owners of that Content, in a separate agreement."
                self.labelFlurl.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
            }
            if indexPat.row == 9 {
               
            }
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func openDSecty () {
        let alert = UIAlertController(title: "Browser option.", message: "", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "SFSafari Browser", style: .default, handler: {  (alert : UIAlertAction) -> Void in
            UserDefaults.standard.set("sfbrowser", forKey: "browse")
        })
        let action2 = UIAlertAction(title: "Safari App Browser", style: .default, handler: {  (alert : UIAlertAction) -> Void in
                   UserDefaults.standard.removeObject(forKey: "browse")
               })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(cancel)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    var oncei = false
    @objc func changePrivate () {
        if alreadyYes == true {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("privateAccount").removeValue()
                alreadyYes = false
                self.buttonErt.backgroundColor = .white
                self.buttonErt.setTitleColor(.blue, for: .normal)
                self.buttonErt.setTitle("Make account Private", for: .normal)
            }
        } else {
            if self.oncei == false {
                print("goofwd")
                self.buttonErt.backgroundColor = .white
                self.buttonErt.setTitle("Make account Public", for: .normal)
                self.buttonErt.setTitleColor(.blue, for: .normal)
                if let uid = Auth.auth().currentUser?.uid {
                    let feed = ["privateAccount" : uid]
                    let ref = Database.database().reference()
                    ref.child("users").child(uid).updateChildValues(feed)
                    self.oncei = true
                }
            }
            alreadyYes = true
        }
    }
    
    
    var alreadyYes = false
    func grabPriva () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("privateAccount").observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    self.buttonErt.setTitle("Make account public", for: .normal)
                    self.buttonErt.backgroundColor = .blue
                    self.buttonErt.setTitleColor(.white, for: .normal)
                    self.alreadyYes = true
                } else {
                    self.buttonErt.setTitle("Make account private", for: .normal)
                    self.buttonErt.backgroundColor = .white
                    self.buttonErt.setTitleColor(.blue, for: .normal)
                    
                }
            })
        }
    }
    
    @objc func makeGoSettings () {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blocked.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablerView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as! blockedCell
        cell.contentView.backgroundColor = UIColor(red: 0.0863, green: 0.0863, blue: 0.0863, alpha: 1.0)
        cell.labelTitl.text = blocked[indexPath.row].namer
     //   cell.textLabel?.textColor = .white
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var once = false
    @objc func saverAct () {
        
        if let index = indexLor {
            
            if index.row == 0 {
                if once == false {
                    once = true
                    botoonSave.setTitle("Sent to email", for: .normal)
                    botoonSave.backgroundColor = UIColor.lightGray
                    if let currentUserEmail = Auth.auth().currentUser?.email {
                        Auth.auth().sendPasswordReset(withEmail: currentUserEmail, completion: { (error) in
                            if error == nil {
                                let alert3 = UIAlertController(title: "Email sent to \(currentUserEmail)", message: "Please check your email, an email containing information on how to change your password has been sent to the entered email", preferredStyle: .alert)
                                let oky = UIAlertAction(title: "Okay", style: .cancel, handler: { (action : UIAlertAction!) -> Void in
                                    self.navigationController?.popViewController(animated: true)                                })
                                
                                alert3.addAction(oky)
                                self.present(alert3, animated: true, completion: nil)
                            }
                            else {
                                let alertCo = UIAlertController(title: "Error", message: "Sorry there was an error, please try again later", preferredStyle: .alert)
                                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                alertCo.addAction(okay)
                                self.present(alertCo, animated: true, completion: nil)
                            }
                        })
                    }
                } else {
                    
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerter = UIAlertController(title: blocked[indexPath.row].namer, message: blocked[indexPath.row].username, preferredStyle: .alert)
        let action = UIAlertAction(title: "Unblock", style: .default) { (alert : UIAlertAction) in
            let ref = Database.database().reference()
            if let theirId = self.blocked[indexPath.row].uider {
                if let uid = Auth.auth().currentUser?.uid {
                    ref.child("users").child(uid).child("blocked").child(theirId).removeValue()
                    self.blocked.remove(at: indexPath.row)
                    self.tablerView.reloadData()
                }
                
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerter.addAction(action)
        alerter.addAction(cancel)
        self.present(alerter, animated: true, completion: nil)
    }
    
    func grabBlocked () {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("blocked").observeSingleEvent(of: .value, with: {(snapshot) in
                if let blocked = snapshot.value as? [String : AnyObject] {
                    for (_, val) in blocked {
                        self.loadUser(uid: val as! String)
                    }
                } else {
                    let label = UILabel()
                    label.frame = CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: 40)
                    label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
                    label.textAlignment = .center
                    label.text = "You currently have no blocked users"
                    label.textColor = .white
                    self.view.addSubview(label)
                }
            })
        }
    }
    func loadUser(uid: String) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            if let usernamer = value?["username"] as? String, let namerl = value?["name"] as? String, let uider = value?["uid"] as? String {
                
                let newpUser = Useri()
                newpUser.namer = namerl
                newpUser.username = usernamer
                newpUser.uider = uider
                
                if self.blocked.contains( where: { $0.uider == newpUser.uider })  {
                }
                else {
                    self.blocked.append(newpUser)
                }
                
            }
            self.tablerView.reloadData()
            print("loaded a user")
            
            
        })
        
    }
    
    
    
    func layout () {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tablerView = UITableView.init(frame: frame, style: .plain)
        view.addSubview(tablerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false 
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

class blockedCell: UITableViewCell {
    var labelTitl = UILabel()
    override func layoutSubviews() {
        contentView.backgroundColor = .black
        self.selectionStyle = .none
        labelTitl.frame = CGRect(x: 15, y: 0, width: contentView.frame.width - 15, height: 30)
        labelTitl.textColor = .white
        labelTitl.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        contentView.addSubview(labelTitl)
    }
}
