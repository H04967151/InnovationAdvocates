//
//  HomeFeedImageTableViewCell.swift
//  InnovationAdvocates
//
//  Created by Neil on 15/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

protocol ReplyFeedImageCellDelegate {
    //func likePostTapped(key: String)
    //func updateLikeBtnUI(cell: ReplyFeedCell)
    //func replyButtonTapped(post: Post)
    func moreBtnTapped(key: String)
    func imageTapped(reply: Reply)
}


class ReplyFeedImageCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!

    
    var likedByUser = [String]()
    var username = String()
    var likedBy = String()
    var numberOfLikes = Int()
    
    
    var delegate: ReplyFeedImageCellDelegate?
    let impact = UINotificationFeedbackGenerator()
    
    var reply: Reply?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd - H:mm"
            let dateString = formatter.string(from: (reply?.date!)!)


            usernameLabel.text = reply?.username
            profileImageView.sd_setImage(with: URL(string: (reply?.profileImage!)!), completed: nil)
            dateLabel.text = dateString
            contentLabel.text = reply?.postContent
            postImageView.sd_setImage(with: URL(string: (reply?.postImageURL!)!), completed: nil)
            selectionStyle = .none
            
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
        delegate?.imageTapped(reply: reply!)
         print("image tapped")
    }
    
    func styleCell(){
        postImageView.layer.cornerRadius = 8
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func optionsButton(_ sender: UIButton) {
        delegate?.moreBtnTapped(key: (reply?.key!)!)
        print("options tapped")
    }
    
}
