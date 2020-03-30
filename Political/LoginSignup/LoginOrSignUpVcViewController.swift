//
//  LoginOrSignUpVcViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 2/3/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class LoginOrSignUpVcViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false 
        
        bgh.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        pImage.frame = CGRect(x: view.frame.midX-110, y: 180, width: 220, height: 100)
        loginButton.frame = CGRect(x: 0, y: view.frame.height - 160, width: self.view.frame.width, height: 80)
        signUpButton.frame = CGRect(x: 0, y: view.frame.height - 80, width: self.view.frame.width, height: 80)
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
                loginButton.frame = CGRect(x: 0, y: view.frame.height - 200, width: self.view.frame.width, height: 80)
                signUpButton.frame = CGRect(x: 0, y: view.frame.height - 120, width: self.view.frame.width, height: 90)
            case 2688:
                print("iPhone XS Max")
                loginButton.frame = CGRect(x: 0, y: view.frame.height - 200, width: self.view.frame.width, height: 80)
                signUpButton.frame = CGRect(x: 0, y: view.frame.height - 120, width: self.view.frame.width, height: 90)
            case 1792:
                print("iPhone XR")
                loginButton.frame = CGRect(x: 0, y: view.frame.height - 200, width: self.view.frame.width, height: 80)
                signUpButton.frame = CGRect(x: 0, y: view.frame.height - 120, width: self.view.frame.width, height: 90)
            default:
                print("Unknown")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    @IBOutlet weak var bgh: UIImageView!
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var pImage: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    @IBAction func loginAction(_ sender: Any) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVc") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpVc") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
      
        self.present(vc, animated: true, completion: nil)
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
