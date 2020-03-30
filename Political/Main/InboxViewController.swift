//
//  InboxViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 4/27/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class InboxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Inbox"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

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



//class notificationCall {
//
//    func firstCall() {
//
//        let ref = Database.database().reference()
//        ref.child("notifications").observeSingleEvent(of: .value, with: {(snapshot) in
//            if let values = snapshot.value as? [String : AnyObject] {
//
//                for (_,one) in values {
//                    if let aidi = one["aid"] as? String, let timeSent = one["timeSent"] as? Int, let url = one["url"] as? String  {
//
//                        ref.child("users").observeSingleEvent(of: .value, with: {(snap) in
//                            if let vals = snap.value as? [String : AnyObject] {
//                                for (_,loop) in vals {
//                                    if let theirId = loop["uid"] as? String {
//
//                                        let updateRef = Database.database().reference().child("users").child(theirId).child("inbox")
//                                        let update: [String : Any] = ["sentBy" : "1234", "sentFrom" : "Politic", "unseen" : "unseen", "timeSent" : timeSent, "url" : url, "aid" : aidi, "caption" : ""]
//                                        let lastUpd = [aidi : update]
//
//                                        updateRef.updateChildValues(lastUpd)
//                                        ref.child("notifications").child(aidi).removeValue()
//
//                                    }
//                                }
//                            }
//                        })
//                    }
//                }
//
//            }
//
//        })
//
//
//    }
//
//
//}

