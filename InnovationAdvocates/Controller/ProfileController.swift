//
//  ProfileController.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var editImageButtom: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastLoginLabel: UILabel!
    var userObject = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Network.shared.getUserInfo { (user) in
            if let user = user {
                self.userObject = user
                self.usernameLabel.text = self.userObject["username"] as? String
                self.profileImageView.sd_setImage(with: URL(string: self.userObject["profileImage"] as! String), completed: nil)
                self.emailLabel.text = self.userObject["email"] as? String
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM dd - HH:mm"
                let dateString = formatter.string(from: self.userObject["lastLogIn"] as! Date)
                self.lastLoginLabel.text = "Last Login - \(dateString)"
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
        editImageButtom.layer.cornerRadius = editImageButtom.frame.height / 2
        editImageButtom.layer.borderColor = UIColor(named: "Red")?.cgColor
        editImageButtom.layer.borderWidth = 2
    }
    @IBAction func changeProfileImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        }else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImageView.image = image
        picker.dismiss(animated: true) {
            Network.shared.uploadPicture(image: image, view: self)
        }
        
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        Network.shared.signOutUser()
    }
}
