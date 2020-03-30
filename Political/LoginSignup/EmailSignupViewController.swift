//
//  EmailSignupViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class EmailSignupViewController: UIViewController, UITextFieldDelegate {
    
    var nameString: String?
    var usernameString: String?
    
    @IBOutlet weak var emailExplainLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.title = "Email and Password"
        doneButton.layer.cornerRadius = 6.0
        doneButton.clipsToBounds = true
        passwordField.delegate = self
        emailField.frame = CGRect(x: 16, y: 220, width: self.view.frame.width - 32, height: 30)
        emailExplainLabel.frame = CGRect(x: 15, y: 104, width: self.view.frame.width - 30, height: 80)
        nameLabel.frame = CGRect(x: 20, y: 190, width: 100, height: 30)
        passwordLabel.frame = CGRect(x: 20, y: 280, width: 100, height: 30)
        passwordField.frame = CGRect(x: 16, y: 310, width: self.view.frame.width - 30, height: 30)
        doneButton.frame = CGRect(x: 56, y: 380, width: self.view.frame.width - 112, height: 52)
        doneButton.layer.cornerRadius = 6.0
        doneButton.clipsToBounds = true
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
              
                
            case 1136:
                //  self.emailExplainLabel.frame = CGRect(x: 15, y: 84, width: self.view.frame.width - 30, height: 120)
                self.emailExplainLabel.text = "Almost done! Enter a password and email for your account."
            default:
                print("Unknown")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var once = false
    @IBAction func doneAction(_ sender: Any) {
        if once == false {
            once = true
            if let usernm = usernameString {
                if let namer = nameString {
                            if let texterEmail = emailField.text {
                                if texterEmail.count < 52  {
                                    if passwordField.text != "" {
                                       
                                        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                                            if let error = error {
                                                let alert = UIAlertController(title: error.localizedDescription, message: "Please enter a different email", preferredStyle: .alert)
                                                let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                                alert.addAction(cancel)
                                                self.doneButton.isHidden = false
                                                self.navigationItem.leftBarButtonItem?.isEnabled = true
                                                self.present(alert, animated: true, completion: nil)
                                                self.once = false
                                            }
                                            if let user = user {

                                                let timelnow: Int = Int(NSDate().timeIntervalSince1970)

                                                UserDefaults.standard.set(usernm, forKey: "username")
                                                let ref = Database.database().reference()
                                                let userInfo : [String : Any] = ["uid": user.user.uid as String, "name": namer, "username": usernm, "showDirections" : user.user.uid, "newUser" : timelnow]
                                                ref.child("users").child(user.user.uid).setValue(userInfo)
                                                let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()




                                                changeRequest.displayName = namer
                                                changeRequest.commitChanges(completion: nil)
                                                print(changeRequest.displayName!)
                                                print(user)


                                                self.performSegue(withIdentifier: "segueEmailSignUp", sender: self)

                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailField.becomeFirstResponder()
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
