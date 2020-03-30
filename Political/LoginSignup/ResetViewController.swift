//
//  ResetViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 9/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
    
    
    class ResetViewController: UIViewController, UITextFieldDelegate {
        
         var labeler = UILabel()
         var textFielder = UITextField()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            self.view.addSubview(labeler)
            self.view.addSubview(textFielder)
            self.view.addSubview(resetAction)
            self.textFielder.becomeFirstResponder()
            self.resetAction.addTarget(self, action: #selector(self.realResetAction(_:)), for: .touchUpInside)
            self.textFielder.delegate = self
            self.textFielder.placeholder = "Enter email..."
            self.navigationItem.title = "Reset Password"
            textFielder.frame = CGRect(x: 15, y: 140, width: self.view.frame.width - 30, height: 30)
            resetAction.frame = CGRect(x: 15, y: self.view.frame.height - 80, width: self.view.frame.width - 30, height: 60)
            resetAction.layer.cornerRadius = 22.0
            resetAction.clipsToBounds = true
            labeler.text = "Enter the email of your account."
            textFielder.borderStyle = .line
            textFielder.layer.borderColor = UIColor.black.cgColor
            labeler.textColor = .black
            labeler.frame = CGRect(x: 15, y: 90, width: self.view.frame.width - 30, height: 25)
            resetAction.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
            resetAction.titleLabel?.textColor = .white
            resetAction.setTitle("Reset", for: .normal)
            // Do any additional setup after loading the view.
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textFielder.resignFirstResponder()
            return true
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        var once = false
         var resetAction = UIButton()
        @objc func realResetAction(_ sender: Any) {
            if once == false {
                once = true
                if textFielder.text != "" {
                    Auth.auth().sendPasswordReset(withEmail: textFielder.text!, completion: { (error) in
                        if error == nil {
                            let emailText = self.textFielder.text!
                            let alert = UIAlertController(title: "Email sent to \(emailText)", message: "Please check your email, An email containing information on how to reset your password has been sent to the entered email", preferredStyle: .alert)
                            let oky = UIAlertAction(title: "Okay", style: .cancel, handler: { (action : UIAlertAction!) -> Void in
                                self.dismiss(animated: true, completion: nil)
                            })
                            alert.addAction(oky)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            let alertCo = UIAlertController(title: "There is no user corresponding to this email", message: "Please enter the email of your registered account, or create an account by going back to sign up", preferredStyle: .alert)
                            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                            alertCo.addAction(okay)
                            self.textFielder.text = ""
                            self.present(alertCo, animated: true, completion: nil)
                            self.once = false
                        }
                    })
                }
            }
        }

}

