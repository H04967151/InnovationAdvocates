//
//  ReplyFeedTableViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 26/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

class ReplyFeedTableViewController: UITableViewController {
    
    let cellID = "replyCell"
    let cellIDTwo = "replyImageCell"
    var replies = [Reply]()
    var originalPost: Post?
       

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName:"ReplyFeedCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName:"ReplyFeedImageCell", bundle: nil), forCellReuseIdentifier: cellIDTwo)
        tableView.register(UINib(nibName:"HomeFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "homeCell")
        tableView.register(UINib(nibName:"HomeFeedImageTableViewCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        tableView.register(UINib(nibName:"ReplyHeader", bundle: nil), forCellReuseIdentifier: "replyHeader")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        
        Network.shared.retrieveReplies(originalPost: originalPost!) { (repliesRet) in
            self.replies = repliesRet
            print(repliesRet)
            self.tableView.reloadData()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else if section == 1 {
            return 40
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return replies.count
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = tableView.dequeueReusableCell(withIdentifier: "replyHeader") as! ReplyHeaderTableViewCell
            header.likeNumLabel.text = "\(originalPost?.numberOfLikes ?? 0)"
            header.replyNumLabel.text = "\(originalPost?.numberOfReplies ?? 0)"
            
            if let numLikes = originalPost?.numberOfLikes {
                if numLikes == 1 {
                    header.likeLikesLabel.text = "Like"
                }
            }
            
            if let numReplies = originalPost?.numberOfReplies {
                if numReplies == 1 {
                    header.replyRepliesLabel.text = "Reply"
                }
            }
            
            return header
        }else{
            return nil
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let replyCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ReplyFeedCell
        replyCell.delegate = self
        let replyImageCell = tableView.dequeueReusableCell(withIdentifier: cellIDTwo, for: indexPath) as! ReplyFeedImageCell
        replyImageCell.delegate = self
        let homeCell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeFeedTableViewCell
        homeCell.delegate = self
        let homeImageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! HomeFeedImageTableViewCell
        homeImageCell.delegate = self

        switch (indexPath.section) {
        case 0:
            if originalPost?.postImageURL == "nil"{
                homeCell.post = originalPost
                return homeCell
            }else{
                homeImageCell.post = originalPost
                return homeImageCell
            }
        case 1:
            let  reply = replies[indexPath.row]
            replyCell.reply = replies[indexPath.row]
            replyImageCell.reply = replies[indexPath.row]

            
            if reply.postImageURL == "nil"{
                return replyCell
            }else{
                return replyImageCell
            }
        default:
            print("nil")
        }
        return replyCell
    }
}

extension ReplyFeedTableViewController: ReplyFeedCellDelegate, ReplyFeedImageCellDelegate, HomeFeedImageTableViewCellDelegate, HomeFeedTableViewCellDelegate{
    func imageTapped(post: Post) {
        if let vc = UIStoryboard(name: "MainFeed", bundle: nil).instantiateViewController(withIdentifier: "postDetailView") as? PostDetailViewController {
            vc.content = post.postContent!
            vc.date = post.date!
            vc.username = post.username!
            vc.image = post.postImageURL!
            vc.profileImage = post.profileImage!
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func moreBtnTapped(key: String) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Block User", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Hide Post", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Report Post", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    func replyButtonTapped(post: Post) {
        if let vc = UIStoryboard(name: "MainFeed", bundle: nil).instantiateViewController(withIdentifier: "ComposePostController") as? ComposePostController {
            vc.sentPost = post
            vc.isReply = true
            present(vc, animated:true)
        }
        
    }
    
    
    func updateLikeBtnUI(cell: HomeFeedImageTableViewCell) {
        cell.likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
        cell.likeBtnImage.isUserInteractionEnabled = false
        let updatedLikeCount = Int(cell.likleCountLabel.text!)
        cell.likleCountLabel.text = String(updatedLikeCount! + 1)
    }
    
    func likePostTapped(key: String) {
        Network.shared.likePost(key: key)
    }
    
    
    
    func imageTapped(reply: Reply) {
        if let vc = UIStoryboard(name: "MainFeed", bundle: nil).instantiateViewController(withIdentifier: "postDetailView") as? PostDetailViewController {
            vc.content = reply.postContent!
            vc.date = reply.date!
            vc.username = reply.username!
            vc.image = reply.postImageURL!
            vc.profileImage = reply.profileImage!
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
