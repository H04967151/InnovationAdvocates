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
    var inittalFeedLoaded = false
    let user = Network.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"HomeFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName:"HomeFeedImageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIDTwo)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        Network.shared.retrievePosts { (returnedPosts) in
            if self.inittalFeedLoaded == false{
                self.posts = returnedPosts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.inittalFeedLoaded = true
            }else if self.inittalFeedLoaded == true {
                self.posts = returnedPosts
                DispatchQueue.main.async {
                    let offsetY = self.tableView.contentOffset.y
                    self.tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
                    self.tableView.reloadData()
                }
                
                
                
            }
            
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
        _ = ""
        
        let homeCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeFeedTableViewCell
        homeCell.delegate = self
        homeCell.post = posts[indexPath.row]
        homeCell.likedByLabel.layer.opacity = 0
        homeCell.likeCountLabel.layer.opacity = 0
        
        let homeImageCell = tableView.dequeueReusableCell(withIdentifier: cellIDTwo, for: indexPath) as! HomeFeedImageTableViewCell
        homeImageCell.post = posts[indexPath.row]
        homeImageCell.delegate = self
        homeImageCell.likedByUseLabel.layer.opacity = 0
        homeImageCell.likleCountLabel.layer.opacity = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd - H:mm"
        let dateString = formatter.string(from: post.date!)
        
        if post.numberOfLikes! > 0 {
            Network.shared.retreiveLikes(key: post.key!) { (likes) in
                var likedByUser = [String]()

                homeCell.likedByLabel.layer.opacity = 1
                homeCell.likeCountLabel.layer.opacity = 1
                homeImageCell.likedByUseLabel.layer.opacity = 1
                homeImageCell.likleCountLabel.layer.opacity = 1
                for like in likes{
                    likedByUser.append((like["username"] as? String)!)
                }
                
                let username = Network.currentUser?.displayName
                if likedByUser.contains(username!){
                    homeImageCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
                    homeCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
                }else{
                    
                    homeImageCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
                    homeCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
                }
                
                

                guard let likedBy = likes[0]["username"] else {return}
                if likedBy as? String == Network.currentUser?.displayName{
                    homeImageCell.likedByUseLabel.text = "-  You like"
                    homeCell.likedByLabel.text = "-  You liked"
                }else{
                    homeImageCell.likedByUseLabel.text = "-  \(likedBy) liked"
                    homeCell.likedByLabel.text = "-  \(likedBy) liked"
                }
                
            }
        }else{
            homeImageCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
            homeCell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
        }
        
        if post.postImageURL != "nil"{
            homeImageCell.usernameLabel.text = post.username
            homeImageCell.profileImageView.sd_setImage(with: URL(string: post.profileImage!), completed: nil)
            homeImageCell.dateLabel.text = dateString
            homeImageCell.contentLabel.text = post.postContent
            homeImageCell.postImageView.sd_setImage(with: URL(string: post.postImageURL!), completed: nil)
            homeImageCell.likleCountLabel.text = "\(post.numberOfLikes ?? 0)"
            homeImageCell.selectionStyle = .none
            return homeImageCell
            
        }else{
            homeCell.usernameLabel.text = post.username
            homeCell.profileImage.sd_setImage(with: URL(string: post.profileImage!), completed: nil)
            homeCell.dateLabel.text = dateString
            homeCell.postContentLabel.text = post.postContent
            homeCell.likeCountLabel.text = "\(post.numberOfLikes ?? 0)"
            homeCell.selectionStyle = .none
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

