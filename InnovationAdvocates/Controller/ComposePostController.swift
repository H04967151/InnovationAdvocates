//
//  ComposePostController.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import Firebase
import SDWebImage

class ComposePostController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var dismissBtnView: UIButton!
    @IBOutlet weak var postBtnView: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var placeholderTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    let homeVC = HomeFeedController()
    let bar = UIToolbar()
    var userObject = [String:Any]()
    
    @IBAction func sendPost(_ sender: UIButton) {
        savePostData()
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        postTextView.resignFirstResponder()
        postTextView.text = ""
        placeholderTextLabel.text = "How are you INNOVATING?"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.becomeFirstResponder()
        self.runStyles()
        let url = Network.currentUser?.photoURL?.absoluteString
        self.profileImageView.sd_setImage(with: URL(string: url!), completed: nil)
    }
    
   
    func runStyles(){
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        postBtnView.layer.cornerRadius = postBtnView.frame.height / 2
        postImageView.layer.cornerRadius = 8
        postBtnView.layer.opacity = 0.2
        postBtnView.isUserInteractionEnabled = false
        
        let camera = UIButton(type: UIButtonType.custom) as UIButton
        camera.setImage(UIImage(named: "camera-7"), for: .normal)
        camera.tintColor = UIColor.white
        camera.sizeToFit()
        camera.addTarget(self, action: #selector(launchCamera), for: .touchUpInside)
        
        let cameraBtn = UIBarButtonItem(customView: camera)
        
        let photoLibrary = UIButton(type: UIButtonType.custom) as UIButton
        photoLibrary.setImage(UIImage(named: "photo-7"), for: .normal)
        photoLibrary.tintColor = UIColor.white
        photoLibrary.sizeToFit()
        photoLibrary.addTarget(self, action: #selector(launchPhotoLibray), for: .touchUpInside)
        
        let photoLibraryBtn = UIBarButtonItem(customView: photoLibrary)
        
        bar.items = [cameraBtn, photoLibraryBtn]
        bar.sizeToFit()
        postTextView.inputAccessoryView = bar
    }

    @objc func launchCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.mediaTypes = [kUTTypeImage as String]
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func launchPhotoLibray(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.mediaTypes = [kUTTypeGIF as String, kUTTypeImage as String]
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true) {
            self.postTextView.becomeFirstResponder()
            self.postImageView.image = image
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.postTextView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if postTextView.text == ""{
            placeholderTextLabel.text = "How are you INNOVATING?"
            postBtnView.layer.opacity = 0.2
            postBtnView.isUserInteractionEnabled = false
        }else{
            placeholderTextLabel.text = ""
            postBtnView.layer.opacity = 1
            postBtnView.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func savePostData() {
        let username = Network.currentUser?.displayName 
        let profileImage = Network.currentUser?.photoURL?.absoluteString
        if postImageView.image != nil {
            let storage = Storage.storage()
            let ref = storage.reference()
            let postImages = ref.child("posts/images/\(Date()).jpg")
            var data = Data()
            var url = String()
            data = UIImageJPEGRepresentation(postImageView.image!, 0.2)!
            
            postImages.putData(data, metadata: nil) { (meta, err) in
                print("Upload started")
                if err == nil {
                    url = (meta?.downloadURLs![0].absoluteString as String?)!
                    let newCreatedPost = Post(username: username, profileImage: profileImage, postContent: self.postTextView.text, postImageURL: url, date: Date(), key: nil, numberOfLikes: 0, likedBy: nil)
                    Network.shared.addPost(post: newCreatedPost)
                }else{
                    print(err?.localizedDescription as Any)
                }
            }
            dismiss(animated: true, completion: nil)
        }else{
            let newCreatedPost = Post(username: username, profileImage: profileImage, postContent: self.postTextView.text, postImageURL: "nil", date: Date(), key: nil, numberOfLikes: 0, likedBy: nil)
            Network.shared.addPost(post: newCreatedPost)
            dismiss(animated: true, completion: nil)
        }
    }
    
    

}
