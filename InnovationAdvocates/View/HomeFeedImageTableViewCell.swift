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
            likedByUseLabel.layer.opacity = 0
            likleCountLabel.layer.opacity = 0
            usernameLabel.text = post?.username
            profileImageView.sd_setImage(with: URL(string: (post?.profileImage!)!), completed: nil)
            dateLabel.text = dateString
            contentLabel.text = post?.postContent
            postImageView.sd_setImage(with: URL(string: (post?.postImageURL!)!), completed: nil)
            likleCountLabel.text = "\(post?.numberOfLikes ?? 0)"
            selectionStyle = .none

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
        
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
    
    func styleCell(){
        postImageView.layer.cornerRadius = 8
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        likeBtnImage.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
}
