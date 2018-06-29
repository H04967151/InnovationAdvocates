//
//  ReplyHeadderTableViewCell.swift
//  InnovationAdvocates
//
//  Created by Neil on 28/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

class ReplyHeaderTableViewCell: UITableViewCell {
    

    @IBOutlet weak var replyNumLabel: UILabel!
    @IBOutlet weak var likeNumLabel: UILabel!
    @IBOutlet weak var replyRepliesLabel: UILabel!
    @IBOutlet weak var likeLikesLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
