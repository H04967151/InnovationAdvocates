//
//  HomeFeedImageTableViewCell.swift
//  InnovationAdvocates
//
//  Created by Neil on 15/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

protocol HomeFeedImageTableViewCellDelegate {
    func likePostTapped(key: String)
    func updateLikeBtnUI(cell: HomeFeedImageTableViewCell)
    func replyButtonTapped(post: Post)
    func moreBtnTapped(key: String)
    func imageTapped(post: Post)
}


class HomeFeedImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likleCountLabel: UILabel!
    @IBOutlet weak var likeBtnImage: UIButton!
    @IBOutlet weak var likedByUseLabel: UILabel!
    @IBOutlet weak var replyBtnImage: UIButton!
    @IBOutlet weak var replyLabel: UILabel!
    
    var likedByUser = [String]()
    var username = String()
    var likedBy = String()
    var numberOfLikes = Int()
    
    
    var delegate: HomeFeedImageTableViewCellDelegate?
    let impact = UINotificationFeedbackGenerator()
    
    var post: Post?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd - H:mm"
            let dateString = formatter.string(from: (post?.date!)!)
            usernameLabel.text = post?.username
            profileImageView.sd_setImage(with: URL(string: (post?.profileImage!)!), completed: nil)
            dateLabel.text = dateString
            contentLabel.text = post?.postContent
            postImageView.sd_setImage(with: URL(string: (post?.postImageURL!)!), completed: nil)
            likleCountLabel.text = "\(post?.numberOfLikes ?? 0)"
            replyLabel.text = "\(post?.numberOfReplies ?? 0)"
            selectionStyle = .none
            
            if post?.numberOfReplies != nil {
                replyLabel.layer.opacity = 1
                replyBtnImage.setImage(#imageLiteral(resourceName: "chat-filled"), for: .normal)
            }
            
            if post?.likedBy != nil {
                
                likedByUseLabel.layer.opacity = 1
                likleCountLabel.layer.opacity = 1
                numberOfLikes = (post?.numberOfLikes)!
                
                
                let username = Network.currentUser?.uid
                let userLikedPost = post?.likedBy![username!]
                if userLikedPost != nil{
                    likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .normal)
                    likeBtnImage.tintColor = UIColor(named: "Red")
                }else{
                    likeBtnImage.setImage(#imageLiteral(resourceName: "favorite-heart-button-outline"), for: .normal)
                    likeBtnImage.tintColor = UIColor(named: "Red")
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        tap.delegate = self
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
        delegate?.imageTapped(post: post!)
    }
    
    func styleCell(){
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        likeBtnImage.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        replyBtnImage.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        delegate?.likePostTapped(key: (post?.key!)!)
        delegate?.updateLikeBtnUI(cell: self)
        impact.notificationOccurred(.success)
    }
    
    
    @IBAction func replyButton(_ sender: UIButton) {
        delegate?.replyButtonTapped(post: (post)!)
    }
    
    @IBAction func optionsButton(_ sender: UIButton) {
        delegate?.moreBtnTapped(key: (post?.key!)!)
    }
    
}
