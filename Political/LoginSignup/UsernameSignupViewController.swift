//
//  UsernameSignupViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class UsernameSignupViewController: UIViewController {
    
    var nameString: String?
let labelTaken = UILabel()
    override func viewWillAppear(_ animated: Bool) {
        self.usernameTextField.becomeFirstResponder()
    }
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var usernameExplainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Username"
       
        
        usernameTextField.frame = CGRect(x: 16, y: 200, width: self.view.frame.width - 32, height: 30)
        usernameExplainLabel.frame = CGRect(x: 15, y: 104, width: self.view.frame.width - 30, height: 60)
        usernameLabel.frame = CGRect(x: 20, y: 170, width: 100, height: 30)
        nextButton.frame = CGRect(x: 56, y: 280, width: self.view.frame.width - 112, height: 52)
        nextButton.layer.cornerRadius = 6.0
        nextButton.clipsToBounds = true
        self.labelTaken.frame = CGRect(x: 50, y: 250, width: self.view.frame.width - 100, height: 25)
        self.labelTaken.font = UIFont(name: "Futura", size: 20)
        self.labelTaken.textColor = .red
        self.labelTaken.textAlignment = .center
        self.view.addSubview(labelTaken)
        self.labelTaken.text = "This username is taken"
        self.labelTaken.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if let textlo = usernameTextField.text {
            if textlo.count > 4 && textlo.count < 19 {
                if let namer = nameString {
                    print(namer)
                    let string = textlo.lowercased()
                    if   string.contains(":") || string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/")  || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("'") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("~") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("nigger")
                        || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains(" ") || string.contains("nigga")
                    {
                        
                        
                    } else {
                        
                        let ref = Database.database().reference()
                        let input = self.usernameTextField.text?.lowercased()
                        ref.child("users").queryOrdered(byChild: "username").queryStarting(atValue: input!).queryEnding(atValue: input! + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.exists() {
                                self.labelTaken.isHidden = false
                            }
                            else {
                                self.labelTaken.isHidden = true
                               self.performSegue(withIdentifier: "segueUsername", sender: self)

                            }

                        })
                        
                        
                    }
                    
                }
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if let dest = segue.destination as? EmailSignupViewController {
            if let namer = nameString {
                if let username = usernameTextField.text?.lowercased() {
                    dest.nameString = namer
                    dest.usernameString = username
                    print("segued both")
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
