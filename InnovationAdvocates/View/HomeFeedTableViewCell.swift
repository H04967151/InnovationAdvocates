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
}

class HomeFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeBtnImage: UIButton!
    @IBOutlet weak var likedByLabel: UILabel!
    
    var post: Post!
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
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        delegate?.likePostTapped(key: post.key!)
    }
    
}
