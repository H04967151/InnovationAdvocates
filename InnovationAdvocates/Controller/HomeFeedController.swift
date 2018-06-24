//
//  FirstViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeFeedController: UITableViewController {
    
    let cellID = "homeCell"
    let cellIDTwo = "imageCell"
    var posts = [Post]()
    let user = Network.currentUser
    var events = [Event]()
    var attendees = [EventAttendee]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"HomeFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName:"HomeFeedImageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIDTwo)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        Network.shared.retrievePosts { (returnedPosts) in
            self.posts = returnedPosts
            self.tableView.reloadData()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runStyles()
    }
    
    func runStyles(){
        title = "Home"
        tabBarController?.tabBar.barTintColor = UIColor(named: "Blue")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5)
        navigationController?.navigationBar.barTintColor = UIColor(named: "Blue")
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.sd_setImage(with: user?.photoURL, for: .normal, completed: nil)
        button.imageView?.contentMode = .scaleAspectFill
        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.navigationItem.leftBarButtonItem = barButton
    }
}

extension HomeFeedController: HomeFeedImageTableViewCellDelegate, HomeFeedTableViewCellDelegate {
    
    func updateLikeBtnUI(cell: HomeFeedImageTableViewCell) {
        cell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
        cell.likeBtnImage.isUserInteractionEnabled = false
        let updatedLikeCount = Int(cell.likleCountLabel.text!)
        cell.likleCountLabel.text = String(updatedLikeCount! + 1)
    }
    
    func likePostTapped(key: String) {
        Network.shared.likePost(key: key)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        let homeCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeFeedTableViewCell
        homeCell.delegate = self
        homeCell.post = posts[indexPath.row]
        
        
        let homeImageCell = tableView.dequeueReusableCell(withIdentifier: cellIDTwo, for: indexPath) as! HomeFeedImageTableViewCell
        homeImageCell.delegate = self
        homeImageCell.post = posts[indexPath.row]
        
        if post.likedBy != nil {
            
            homeCell.likedByLabel.layer.opacity = 1
            homeCell.likeCountLabel.layer.opacity = 1
            homeCell.numberOfLikes = (post.numberOfLikes)!
            
            homeImageCell.likedByUseLabel.layer.opacity = 1
            homeImageCell.likleCountLabel.layer.opacity = 1
            homeImageCell.numberOfLikes = (post.numberOfLikes)!

            
            let username = Network.currentUser?.uid
            let userLikedPost = post.likedBy![username!]
            if userLikedPost != nil{
                    homeImageCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
                    homeCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
                }else{
                    homeImageCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
                    homeCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
                }

//            if let likedBy = post.likedBy!.first {
//                if likedBy.key == Network.currentUser?.uid{
//                    homeImageCell.likedByUseLabel.text = "-  You like"
//                    homeCell.likedByLabel.text = "-  You liked"
//                }else{
//                    homeImageCell.likedByUseLabel.text = "-  \(likedBy.value) liked"
//                    homeCell.likedByLabel.text = "-  \(likedBy.value) liked"
//                }
//            }
            
        }else{
            homeImageCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
            homeCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
        }

        if post.postImageURL != "nil"{
            return homeImageCell
        }else{
            return homeCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "postDetailView") as? PostDetailViewController {
            vc.content = post.postContent!
            vc.date = post.date!
            vc.username = post.username!
            vc.image = post.postImageURL!
            vc.profileImage = post.profileImage!
            self.present(vc, animated: true, completion: nil)
        }
    }
}

