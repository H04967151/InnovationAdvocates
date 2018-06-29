//
//  HomeFeedTableViewCell.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

protocol ReplyFeedCellDelegate {
    //func likePostTapped(key: String)
    //func replyButtonTapped(reply: Reply)
    func moreBtnTapped(key: String)
}

class ReplyFeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    var likedByUser = [String]()
    var username = String()
    var likedBy = String()
    var numberOfLikes = Int()
    
    var reply: Reply?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd - H:mm"
            let dateString = formatter.string(from: (reply?.date!)!)

            usernameLabel.text = reply?.username
            profileImage.sd_setImage(with: URL(string: (reply?.profileImage!)!), completed: nil)
            dateLabel.text = dateString
            postContentLabel.text = reply?.postContent
            selectionStyle = .none
            
        }
    }
    var delegate: ReplyFeedCellDelegate?
    
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
    }

    
    @IBAction func optionsButton(_ sender: UIButton) {
        delegate?.moreBtnTapped(key: (reply?.key!)!)
    }
    
}
