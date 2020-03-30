//
//  LoginViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/28/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase



class LoginViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
     
        emailLabel.frame = CGRect(x: 20, y: self.view.frame.height / 4.5, width: self.view.frame.width - 200, height: 20)
        emailTextField.frame = CGRect(x: 18, y: self.view.frame.height / 3.9, width: self.view.frame.width - 36, height: 30)
        forgotPasswordBtn.addTarget(self, action: #selector(self.openSettings), for: .touchUpInside)
        passwordEnterLabel.frame = CGRect(x: 20, y: self.view.frame.height / 3, width: self.view.frame.width - 200, height: 20)
        passwordTextField.frame = CGRect(x: 18, y: self.view.frame.height / 2.7, width: self.view.frame.width - 36, height: 30)
        forgotPasswordBtn.frame = CGRect(x: 90, y: self.view.frame.height / 2.1, width: self.view.frame.width - 180, height: 20)
        passwordTextField.delegate = self
        loginButton.frame = CGRect(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, height: 52)
        loginButton.layer.cornerRadius = 12.0
        loginButton.clipsToBounds = true
        
        passwordTextField.placeholder = "Enter your password..."
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
                emailLabel.frame = CGRect(x: 20, y: self.view.frame.height / 4.5, width: self.view.frame.width - 200, height: 20)
                emailTextField.frame = CGRect(x: 18, y: self.view.frame.height / 3.9, width: self.view.frame.width - 36, height: 30)
                passwordEnterLabel.frame = CGRect(x: 20, y: self.view.frame.height / 3.1, width: self.view.frame.width - 200, height: 20)
                passwordTextField.frame = CGRect(x: 18, y: self.view.frame.height / 2.8, width: self.view.frame.width - 36, height: 30)
                forgotPasswordBtn.frame = CGRect(x: 90, y: self.view.frame.height / 2.3, width: self.view.frame.width - 180, height: 20)
            case 2688:
                print("iPhone XS Max")
                emailLabel.frame = CGRect(x: 20, y: self.view.frame.height / 4.5, width: self.view.frame.width - 200, height: 20)
                emailTextField.frame = CGRect(x: 18, y: self.view.frame.height / 3.9, width: self.view.frame.width - 36, height: 30)
                passwordEnterLabel.frame = CGRect(x: 20, y: self.view.frame.height / 3.1, width: self.view.frame.width - 200, height: 20)
                passwordTextField.frame = CGRect(x: 18, y: self.view.frame.height / 2.8, width: self.view.frame.width - 36, height: 30)
                forgotPasswordBtn.frame = CGRect(x: 90, y: self.view.frame.height / 2.3, width: self.view.frame.width - 180, height: 20)
            case 1792:
                print("iPhone XR")
                emailLabel.frame = CGRect(x: 20, y: self.view.frame.height / 4.5, width: self.view.frame.width - 200, height: 20)
                emailTextField.frame = CGRect(x: 18, y: self.view.frame.height / 3.9, width: self.view.frame.width - 36, height: 30)
                passwordEnterLabel.frame = CGRect(x: 20, y: self.view.frame.height / 3.1, width: self.view.frame.width - 200, height: 20)
                passwordTextField.frame = CGRect(x: 18, y: self.view.frame.height / 2.8, width: self.view.frame.width - 36, height: 30)
                forgotPasswordBtn.frame = CGRect(x: 90, y: self.view.frame.height / 2.3, width: self.view.frame.width - 180, height: 20)
            default:
                print("Unknown")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordEnterLabel: UILabel!
    
    @IBOutlet weak var backBtnObj: UIBarButtonItem!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func forgottenAction(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var pressOnce = false
    @IBAction func loginAct(_ sender: Any) {
        if pressOnce == false {
            pressOnce = true
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    Auth.auth().signIn(withEmail: email, password: password, completion: {(logedIn, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            var problem = UIAlertController()
                            problem = UIAlertController(title: "There was a problem", message: "The email or password is incorrect", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                            problem.addAction(cancel)
                            self.present(problem, animated: true, completion: nil)
                            self.pressOnce = false
                        }
                        else {
                            let vc = self.view.window!.rootViewController as! UITabBarController
                            let dvc = vc.viewControllers![0] as! UINavigationController
                            let dvcv = dvc.viewControllers[0] as! ViewController
                            self.view.window!.rootViewController?.dismiss(animated: true, completion: {
                             dvcv.doStuff()
//                                let appDel = AppDelegate()
//                                appDel.callNotifs()
                            })
                            
                        }
                    })
                }
            }
        }
    }
    
    @objc func openSettings () {
        let vc = ResetViewController()
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
