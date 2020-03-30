//
//  NameSignupViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class NameSignupViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.nameTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.frame = CGRect(x: 16, y: 200, width: self.view.frame.width - 32, height: 30)
        explainLabel.frame = CGRect(x: 15, y: 104, width: self.view.frame.width - 30, height: 60)
        nameLabel.frame = CGRect(x: 20, y: 170, width: 100, height: 30)
        nextButton.frame = CGRect(x: 56, y: 280, width: self.view.frame.width - 112, height: 52)
        nextButton.layer.cornerRadius = 6.0
        nextButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var explainLabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func dismisser(_ sender: Any) {
        nameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var nextButtonAction: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "segueNameSignUp" {
            if let texter = nameTextField.text {
                let dest = segue.destination as! UsernameSignupViewController
                dest.nameString = texter
               
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let textlo = nameTextField.text {
            if textlo.count > 2 && textlo.count < 32 {
                let string = textlo.lowercased()
                if  string.contains("-") || string.contains("_") || string.contains(":") || string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/")  || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("'") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("~") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("nigger")
                    || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ") || string.contains("nigga")
                {
                    return false
                    
                } else {
                    return true
                }
            }
        }
        return false
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
