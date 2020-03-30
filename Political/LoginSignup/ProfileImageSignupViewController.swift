//
//  ProfileImageSignupViewController.swift
//  Political
//
//  Created by Gavin Wolfe on 5/25/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class ProfileImageSignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImagerView: UIImageView!
    @IBOutlet weak var buttonAddPhoto: UIButton!
    
    
   @objc func actionAddPhoto () {
         let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let pageAlert = UIAlertController(title: "Add Profile Photo", message: "Choose a way to add a profile photo", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        pageAlert.addAction(camera)
        pageAlert.addAction(library)
        pageAlert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(pageAlert, animated: true, completion: nil)
        }
    }
    var tookPhoto = false
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }

    
        profileImagerView.image = selectedImage
        let success = saveImage(image: selectedImage)
        print(success)
        buttonAddPhoto.setTitle("Change Image", for: .normal)
        tookPhoto = true
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        activyu.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.view.frame.height)
        activyu.color = .black
        activyu.backgroundColor = UIColor(white: 0.9, alpha: 0.1)
      
        buttonAddPhoto.addTarget(self, action: #selector(self.actionAddPhoto), for: .touchUpInside)
        
        profileImagerView.image = #imageLiteral(resourceName: "user")
        self.navigationItem.title = "Profile"
        
        
       
        doneButton.layer.cornerRadius = 6.0
        doneButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1)  ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("profileImg.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    var activyu = UIActivityIndicatorView()
    @IBAction func doneButtonAction(_ sender: Any) {
        if tookPhoto == true {
            if once == true {
                once = false
                self.activyu.startAnimating()
                self.view.addSubview(activyu)
                if let img = self.profileImagerView.image {
                    if let uid = Auth.auth().currentUser?.uid {
                        
                        let storage = Storage.storage().reference().child(uid).child("profile.jpg")
                        if let uploadData = img.jpegData(compressionQuality: 0.40) {
                            storage.putData(uploadData, metadata: nil, completion:
                                { (metadata, error) in
                                    guard let metadata = metadata else {
                                        // Uh-oh, an error occurred!
                                        print(error!)
                                        self.once = true
                                        return
                                    }
                                    
                                    print(metadata)
                                    storage.downloadURL { url, error in
                                        guard let downloadURL = url else {
                                            print("erroor downl")
                                            return
                                        }
                                        self.activyu.stopAnimating()
                                        let ref = Database.database().reference()
                                        let postFeed = ["profileUrl" : downloadURL.absoluteString]
                                        ref.child("users").child(uid).updateChildValues(postFeed)
                                        self.activyu.stopAnimating()
                                        self.performSegue(withIdentifier: "segueFinallyDone", sender: self)
                                    }
                                    
                            })
                        }
                        
                        
                    }
                }
            }
        }
        else  {
        self.performSegue(withIdentifier: "segueFinallyDone", sender: self)
        }
    }
    
    @IBOutlet weak var buttonAboveImage: UIButton!
    @IBAction func buttonAct(_ sender: Any) {
        self.actionAddPhoto()
    }
    var once = true
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
    
    
    override func viewWillLayoutSubviews() {
        //let cnst = (self.view.frame.height / 3) * -1
        //profileImagerView.translatesAutoresizingMaskIntoConstraints = false
        profileImagerView.frame = CGRect(x: self.view.frame.midX - 60, y: 100, width: 120, height: 120)
        buttonAddPhoto.frame = CGRect(x: 50, y: 240, width: self.view.frame.width - 100, height: 51)
        doneButton.frame = CGRect(x: 16, y: self.view.frame.height - 100, width: self.view.frame.width - 32, height: 60)
        buttonAboveImage.frame = profileImagerView.frame
        profileImagerView.layer.cornerRadius = 60
     profileImagerView.clipsToBounds = true
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
