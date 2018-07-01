//
//  Network.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import Foundation
import Firebase
import LocalAuthentication
import SVProgressHUD

class Network {
    
    static let shared = Network()
    let db = Firestore.firestore()
    let ref = Storage.storage().reference()
    static let currentUser = Auth.auth().currentUser
    static let userDetails = Network.getUserInfo
    let defaults = UserDefaults.standard
    var bioSignInCancelled = false
    

    
    func addPost(post: Post){
        SVProgressHUD.show(withStatus: "Posting...")
        var ref: DocumentReference? = nil
        ref = db.collection("Posts").addDocument(data: [
            "username": post.username as Any,
            "profileImage": post.profileImage as Any,
            "postContent": post.postContent as Any,
            "date": post.date as Any,
            "postImageURL": post.postImageURL as Any
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let key = ref?.documentID
                self.saveToUserPostList(docID: key!)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func replyToPost(post: Post, key: String){
            SVProgressHUD.show(withStatus: "Posting...")
            var ref: DocumentReference? = nil
            ref = db.collection("Posts").document(key).collection("replies").addDocument(data: [
                "username": post.username as Any,
                "profileImage": post.profileImage as Any,
                "postContent": post.postContent as Any,
                "date": post.date as Any,
                "postImageURL": post.postImageURL as Any
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
    //                let key = ref?.documentID
    //                self.saveToUserPostList(docID: key!)
                    let UID = UUID()
                    SVProgressHUD.dismiss()
                    if let userUID = Auth.auth().currentUser?.uid {
                        self.db.collection("Posts").document(key).updateData(["repliedBy.\(UID)" : userUID]) { (err) in
                            if err == nil{
                                print("saved")
                            }
                        }
                    }
                }
            }
        }
    
    func retrieveReplies(originalPost: Post, completion: @escaping ([Reply]) -> ()){
        db.collection("Posts").document(originalPost.key!).collection("replies").order(by: "date").addSnapshotListener { (QuerySnapshot, err) in
            var returnedReplies: [Reply]
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                returnedReplies = []
                for document in QuerySnapshot!.documents {
                    let key                 = document.documentID
                    let username            = document.data()["username"] as! String
                    let profileImage        = document.data()["profileImage"] as! String
                    let postContent         = document.data()["postContent"] as! String
                    let date                = document.data()["date"] as! Date
                    let imageURL            = document.data()["postImageURL"] as! String
                    let likedBy             = document.data()["likedBy"] as? [String: Any]
                    returnedReplies.insert(Reply(username: username, profileImage: profileImage, postContent: postContent, postImageURL: imageURL, date: date, key: key, numberOfLikes: likedBy?.count, likedBy: likedBy), at: 0)
                }
                completion(returnedReplies)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func addVideo(video: Video){
        db.collection("Videos").addDocument(data: [
            "thumbnailURL" : video.thumbnailURL as Any,
            "videoURL" : video.videoURL as Any,
            "title": video.title as Any,
            "description" : video.description as Any,
            "date" : video.date as Any
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {

            }
        }
    }
    
    
    func likePost(key: String){
        if let userUID = Auth.auth().currentUser?.uid, let username = Auth.auth().currentUser?.displayName {
            db.collection("Posts").document(key).updateData(["likedBy.\(userUID)" : username]) { (err) in
                if err == nil {
                    self.db.collection("Posts").document(key).collection("likedBy").document((Auth.auth().currentUser?.uid)!).setData(["username" : Auth.auth().currentUser?.displayName, "profileImage" : Auth.auth().currentUser?.photoURL?.absoluteString as! String], completion: { (err) in
                        
                    })
                }
            }
        }
    }
    
        
    func retreiveLikes(key: String,  completion: @escaping([[String:Any]])->()){
        var likes = [[String:Any]]()
        db.collection("Posts").document(key).collection("likedBy").getDocuments { (snapshot, err) in
            if err == nil{
                for doc in (snapshot?.documents)!{
                    likes.append(doc.data() )
                }
                completion(likes)
            }
            
        }
    }
    
    func uploadPicture(image: UIImage, view: UIViewController){
        let data = UIImageJPEGRepresentation(image, 0.2)
        let profileImages = ref.child("users/images/\(Date()).jpg")
        let user = Auth.auth().currentUser
        SVProgressHUD.show(withStatus: "Uploading..")
        profileImages.putData(data!, metadata: nil) { (meta, err) in
            if err == nil {
                let newProfileURL = (meta?.downloadURLs![0])!
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.photoURL = newProfileURL
                changeRequest?.commitChanges(completion: { (err) in
                    if err == nil {
                        self.db.collection("Users").document((user?.uid)!).updateData(["profileImage" : newProfileURL.absoluteString])
                        self.retrieveUsersPosts(completion: { (posts) in
                            self.uppdateProfileImageURL(posts: posts, url: newProfileURL.absoluteString)
                        })
                        SVProgressHUD.dismiss()
                        let ac = UIAlertController(title: "Woooo Hooo!" , message: "Your new image has been uploaded", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (nil) in
                            
                        }))
                        view.present(ac, animated: true)
                    }else{
                        print(err?.localizedDescription as Any)
                    }
                })
                
            }else{
                print(err?.localizedDescription as Any)
            }
        }
    }
    
    func retrieveUsersPosts(completion: @escaping([[String:Any]]) -> ()){
        db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("posts").getDocuments { (snapshot, err) in
            var usersPosts = [[String:Any]]()
            if err == nil {
                for document in (snapshot?.documents)! {
                    usersPosts.append(document.data())
                }
                completion(usersPosts)
            }
        }
    }
    
    func uppdateProfileImageURL(posts: [[String:Any]], url: String){
        for post in posts {
            let key = post["key"] as! String
            print(key)
            db.collection("Posts").document(key).updateData(["profileImage" : url])
        }
    }
    
    func saveToUserPostList(docID: String){
        var ref: DocumentReference? = nil
        ref = db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("posts").addDocument(data: ["key": docID]) {
            err in if err != nil {
                print(err?.localizedDescription as Any)
            }else{
            }
        }
    }
    
    func retrievePosts(completion: @escaping ([Post]) -> ()){
        SVProgressHUD.show(withStatus: "Loading..")
        var returnedPosts = [Post]()
        db.collection("Posts").order(by: "date").addSnapshotListener{ (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                returnedPosts = []
                for document in snapshot!.documents {
                    let key                 = document.documentID
                    let username            = document.data()["username"] as! String
                    let profileImage        = document.data()["profileImage"] as! String
                    let postContent         = document.data()["postContent"] as! String
                    let date                = document.data()["date"] as! Date
                    let imageURL            = document.data()["postImageURL"] as! String
                    let likedBy             = document.data()["likedBy"] as? [String: Any]
                    let repliedBy           = document.data()["repliedBy"] as? [String: Any]
                    returnedPosts.insert(Post(username: username, profileImage: profileImage, postContent: postContent, postImageURL: imageURL, date: date, key: key, numberOfLikes: likedBy?.count, likedBy: likedBy, numberOfReplies: repliedBy?.count), at: 0)
                }
                completion(returnedPosts)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func retrieveVideos(completion: @escaping ([Video]) -> ()){
        SVProgressHUD.show(withStatus: "Loading..")
        var returnedVideos = [Video]()
        db.collection("Videos").order(by: "date", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let title = document.data()["title"] as! String
                    let videoURL = document.data()["videoURL"] as! String
                    let thumbnailURL = document.data()["thumbnailURL"] as! String
                    let description = document.data()["description"] as! String
                    let date = document.data()["date"] as! Date
                    returnedVideos.append(Video(thumbnailURL: thumbnailURL, videoURL: videoURL, title: title, description: description, date: date))
                }
            }
            completion(returnedVideos)
            SVProgressHUD.dismiss()
        }
    }
    
    func retrieveEvents(completion: @escaping([Event])->()){
        SVProgressHUD.show(withStatus: "Loading..")
        var returnedEvents = [Event]()
        db.collection("Events").order(by: "startDate", descending: true).getDocuments { (querySnapshot, err) in
            if err == nil {
                returnedEvents = []
                for doc in (querySnapshot?.documents)!{
                    let title = doc.data()["title"] as! String
                    let description = doc.data()["description"] as! String
                    let startDate = doc.data()["startDate"] as! Date
                    let endDate = doc.data()["endDate"] as! Date
                    let spaces = doc.data()["spaces"] as! Int
                    let key = doc.documentID
                    returnedEvents.insert(Event(title: title, description: description, startTime: startDate, endTime: endDate, spaces: spaces, key: key, attendees: nil), at: 0)
                }
                completion(returnedEvents)
                SVProgressHUD.setSuccessImage(#imageLiteral(resourceName: "favorite-heart-button"))
                SVProgressHUD.dismiss()
            }else{
                print(err?.localizedDescription as Any)
            }
        }
    }
    
    func attendEvent(key: String, view: UIViewController, completion: @escaping (Bool) -> ()){
        SVProgressHUD.show(withStatus: "Booking your space")
        db.collection("Events").document(key).collection("attendees").document((Auth.auth().currentUser?.uid)!).setData(["userImage" : Auth.auth().currentUser?.photoURL?.absoluteString as Any]) { (err) in
            if err == nil {
                if err == nil {
                    SVProgressHUD.showSuccess(withStatus: "Ticket Reserved")
                    self.defaults.set(true, forKey: key)
                    completion(true)
                }
            }
        }
    }
    
    func eventAttendees(key: String, completion: @escaping([EventAttendee])->()){
        var attendees = [EventAttendee]()
        db.collection("Events").document(key).collection("attendees").getDocuments { (QuerySnapshot, err) in
            attendees = []
            for doc in (QuerySnapshot?.documents)! {
                let userId = doc.documentID
                let userImageUrl = doc.data()["userImage"]
                attendees.insert(EventAttendee(userID: userId, userImage: userImageUrl as? String), at: 0)
            }
            completion(attendees)
        }
    }
    
    func retrievePresentations(completion: @escaping([Presentation])->()){
        SVProgressHUD.show(withStatus: "Loading...")
        var returnedPresentations = [Presentation]()
        db.collection("Presentations").getDocuments { (querySnapshot, err) in
            if err == nil {
                returnedPresentations = []
                for doc in (querySnapshot?.documents)!{
                    let title = doc.data()["title"] as! String
                    let description = doc.data()["description"] as! String
                    let url = doc.data()["url"] as! String
                    returnedPresentations.insert(Presentation(title: title, description: description, url: url), at: 0)
                }
                completion(returnedPresentations)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func isUserLoggedIn(view: UIViewController){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil && self.bioSignInCancelled == false{
                self.bioMetricCheck(view: view)
            }
        }
    }
    
    func bioMetricCheck(view: UIViewController){
        let context = LAContext()
        var err: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err){
            let reason = "It's OK I dont bite"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, err) in
                DispatchQueue.main.async {
                    if success {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home")
                        UIApplication.shared.keyWindow?.rootViewController = vc
                    }else{
                        self.bioSignInCancelled = true
                        let ac = UIAlertController(title: "Oooops!" , message: "Authentication Failed! Please login with Username & Password", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (nil) in
                            let vc = UIStoryboard(name: "MainFeed", bundle: nil).instantiateViewController(withIdentifier: "login")
                            UIApplication.shared.keyWindow?.rootViewController = vc
                        }))
                        view.present(ac, animated: true)
                    }
                }
            })
        }
    }
    
    func signOutUser(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.defaults.removeObject(forKey: "username")
            self.defaults.removeObject(forKey: "email")
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
            UIApplication.shared.keyWindow?.rootViewController = vc
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError) 
        }
        
    }
    
    func getUserInfo(uid: String, completion: @escaping ([String: Any]?)->()){
        db.collection("Users").document(uid).getDocument { (doc, err) in
            if let _ = doc, (doc?.exists)! {
                if let dataDescription = doc?.data() {
                    completion(dataDescription)
                }else{return}
                
            }
            
        }
    }
    
    func createUser(email: String, password: String, username: String, lastLogin: Date){
        SVProgressHUD.show(withStatus: "Creating Account")
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let activeUser = user {
                SVProgressHUD.dismiss()
                self.db.collection("Users").document(activeUser.uid).setData([
                    "username": username ,
                    "uid": activeUser.uid ,
                    "email": activeUser.email as Any,
                    "profileImage": "https://firebasestorage.googleapis.com/v0/b/innovation-app-e79c3.appspot.com/o/Defaults%2Fimages%2FIcon-512.png?alt=media&token=39a5c9f1-13f7-456a-be0a-b6a10652b4e6",
                    "lastLogIn": lastLogin
                    ])
                let changeRequ = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequ?.photoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/innovation-app-e79c3.appspot.com/o/Defaults%2Fimages%2FIcon-512.png?alt=media&token=39a5c9f1-13f7-456a-be0a-b6a10652b4e6")
                changeRequ?.displayName = username
                changeRequ?.commitChanges(completion: { (err) in
                    if err == nil {
                        self.loginUser(email: email, password: password)
                    }
                })
                self.defaults.set(username, forKey: "username")
                self.defaults.set(email, forKey: "email")
            }else if err?.localizedDescription != nil {
                SVProgressHUD.dismiss()
                SVProgressHUD.show(withStatus: "Siging In")
                self.loginUser(email: email, password: password)
                print(err?.localizedDescription as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String){
        SVProgressHUD.show(withStatus: "Loging In")
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if err == nil {
                let username = Auth.auth().currentUser?.displayName
                let email = Auth.auth().currentUser?.email
                SVProgressHUD.dismiss()
                self.defaults.set(username, forKey: "username")
                self.defaults.set(email, forKey: "email")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home")
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
            
        }
    }
}
