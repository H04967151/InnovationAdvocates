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
    
    var post: Post!
    var delegate: HomeFeedImageTableViewCellDelegate?
    let impact = UINotificationFeedbackGenerator()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleCell()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        delegate?.likePostTapped(key: post.key!)
        delegate?.updateLikeBtnUI(cell: self)
        impact.notificationOccurred(.success)
    }
    
    func styleCell(){
        postImageView.layer.cornerRadius = 8
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        likeBtnImage.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
}
