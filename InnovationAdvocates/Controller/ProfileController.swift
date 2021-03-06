//
//  ProfileController.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class ProfileController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {


    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastLoginLabel: UILabel!
    var userObject = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading...")
        profileImageView.layer.opacity = 0
        usernameLabel.layer.opacity = 0
        emailLabel.layer.opacity = 0
        lastLoginLabel.layer.opacity = 0
        signOutBtn.layer.opacity = 0
        Network.shared.getUserInfo(uid: (Network.currentUser?.uid)!) { (user) in
            if let user = user {
                self.userObject = user
                self.usernameLabel.text = self.userObject["username"] as? String
                self.profileImageView.sd_setImage(with: URL(string: self.userObject["profileImage"] as! String), completed: nil)
                self.emailLabel.text = self.userObject["email"] as? String
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM dd - HH:mm"
                let dateString = formatter.string(from: self.userObject["lastLogIn"] as! Date)
                self.lastLoginLabel.text = "Last Login - \(dateString)"
                SVProgressHUD.dismiss()
                UIView.animate(withDuration: 0.3) {
                    self.profileImageView.layer.opacity = 1
                    self.usernameLabel.layer.opacity = 1
                    self.emailLabel.layer.opacity = 1
                    self.lastLoginLabel.layer.opacity = 1
                    self.signOutBtn.layer.opacity = 1
                }
            }else{
                print("No User")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        runStyles()
    }
    
    func runStyles(){
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        title = "Profile"
        tabBarController?.tabBar.barTintColor = UIColor(named: "Grey")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Grey")
        signOutBtn.layer.cornerRadius = signOutBtn.frame.height / 2
    }
    @IBAction func changeProfileImage(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                vc.sourceType = .photoLibrary
                vc.allowsEditing = true
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }))

        present(alertController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImageView.image = image
        picker.dismiss(animated: true) {
            Network.shared.uploadPicture(image: image, view: self)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        Network.shared.signOutUser()
    }
}
