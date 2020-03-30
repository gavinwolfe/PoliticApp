//
//  FinalSignupViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class FinalSignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.view.backgroundColor = .black
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.dismissHome()
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
          self.view.backgroundColor = .black
        bgh.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        logo.frame = CGRect(x: view.frame.midX - 50, y: self.view.frame.midY - 100, width: 100, height: 100)
        labelLogo.frame = CGRect(x: 16, y: view.frame.midY + 20, width: self.view.frame.width - 32, height: 30)
    }
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var labelLogo: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    @IBOutlet weak var bgh: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissHome () {
        let vc = self.view.window!.rootViewController as! UITabBarController
        let dvc = vc.viewControllers![0] as! UINavigationController
        let dvcv = dvc.viewControllers[0] as! ViewController
        self.view.window!.rootViewController?.dismiss(animated: false, completion: {
            print("done")
             dvcv.doStuff()
            let del = AppDelegate()
            del.callNotifs()
        })
        
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
