//
//  HomeFeedTableViewCell.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

protocol HomeFeedTableViewCellDelegate {
        func likePostTapped(key: String)
        func replyButtonTapped(post: Post)
        func moreBtnTapped(key: String)
}

class HomeFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeBtnImage: UIButton!
    @IBOutlet weak var likedByLabel: UILabel!
    @IBOutlet weak var replyBtnImage: UIButton!
    @IBOutlet weak var replyLabel: UILabel!
    
    var likedByUser = [String]()
    var username = String()
    var likedBy = String()
    var numberOfLikes = Int()
    
    var post: Post?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd - H:mm"
            let dateString = formatter.string(from: (post?.date!)!)
            
            likedByLabel.layer.opacity = 0
            likeCountLabel.layer.opacity = 0
            replyLabel.layer.opacity = 0
            usernameLabel.text = post?.username
            profileImage.sd_setImage(with: URL(string: (post?.profileImage!)!), completed: nil)
            dateLabel.text = dateString
            postContentLabel.text = post?.postContent
            likeCountLabel.text = "\(post?.numberOfLikes ?? 0)"
            replyLabel.text = "\(post?.numberOfReplies ?? 0)"
            replyBtnImage.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            selectionStyle = .none
            
            if post?.numberOfReplies != nil {
                replyLabel.layer.opacity = 1
                replyBtnImage.setImage(#imageLiteral(resourceName: "chat-filled"), for: .normal)
            }
            
            if let postLikedBy = post?.likedBy {
                
                likedByLabel.layer.opacity = 1
                likeCountLabel.layer.opacity = 1
                numberOfLikes = (post?.numberOfLikes)!
                
                
                let username = Network.currentUser?.uid
                let userLikedPost = postLikedBy[username!]
                if userLikedPost != nil{
                    likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
                }else{
                    likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
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
                likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
            }
            
        }
    }
    var delegate: HomeFeedTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func styleCell(){
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        likeBtnImage.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        replyBtnImage.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        delegate?.likePostTapped(key: (post?.key!)!)
    }
    
    @IBAction func replyButton(_ sender: UIButton) {
        delegate?.replyButtonTapped(post: (post)!)
    }
    
    @IBAction func optionsButton(_ sender: UIButton) {
        delegate?.moreBtnTapped(key: (post?.key!)!)
    }
    
}
