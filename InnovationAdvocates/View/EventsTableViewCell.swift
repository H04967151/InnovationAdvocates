//
//  EventsTableViewCell.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eevntIconImage: UIImageView!
    @IBOutlet weak var cellRightContainerView: UIView!
    
    var event: Event? {
        didSet{
            let formatter = DateFormatter()
            let timeFormatter = DateFormatter()
            formatter.dateFormat = "MMMM dd - h:mma"
            timeFormatter.dateFormat = "h:mma"
            let startDateString = formatter.string(from: (event?.startTime!)!)
            let endDateString = timeFormatter.string(from: (event?.endTime)!)
            
            eventTitleLabel.text = event?.title
            eventDescriptionLabel.text = event?.description
            eventDateLabel.text = "\(startDateString) to \(endDateString)"
            eevntIconImage.image = eevntIconImage.image?.withRenderingMode(.alwaysTemplate)
            eevntIconImage.tintColor = UIColor(named: "Grey")
            
            Network.shared.eventAttendees(key: (event?.key!)!) { (attendees) in
                for user in attendees{
                    if user.userID == Network.currentUser?.uid{
                        self.eevntIconImage.image = #imageLiteral(resourceName: "circle-tick-7")
                        self.eevntIconImage.image = self.eevntIconImage.image?.withRenderingMode(.alwaysTemplate)
                        self.eevntIconImage.tintColor = UIColor.white
                        self.eevntIconImage.backgroundColor = UIColor(named: "Green")
                        self.eevntIconImage.layer.cornerRadius = self.eevntIconImage.bounds.height / 2
                        self.eevntIconImage.clipsToBounds = true
                        return
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func styleCell(){

    }
    
}


