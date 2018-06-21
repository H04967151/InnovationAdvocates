//
//  SecondViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import SVProgressHUD

class EventsController: UITableViewController {
    
    let cellID = "EventsCell"
    var events = [Event]()
    var index = IndexPath()
    var didTap = false
    var isAttending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"EventsTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        Network.shared.retrieveEvents { (returnedEvents) in
            self.events = returnedEvents
            print(returnedEvents)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runStyles()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if SVProgressHUD.isVisible(){
            SVProgressHUD.dismiss()
        }
    }
    
    func runStyles(){
        title = "Events"
        tabBarController?.tabBar.barTintColor = UIColor(named: "Green")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Green")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]        
        let formatter = DateFormatter()
        let timeFormatter = DateFormatter()
        formatter.dateFormat = "MMMM dd - h:mma"
        timeFormatter.dateFormat = "h:mma"
        let startDateString = formatter.string(from: event.startTime!)
        let endDateString = timeFormatter.string(from: (event.endTime)!)
        let eventsCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventsTableViewCell
        eventsCell.eventTitleLabel.text = event.title
        eventsCell.eventDescriptionLabel.text = event.description
        eventsCell.eventDateLabel.text = "\(startDateString) to \(endDateString)"
        eventsCell.eevntIconImage.image = eventsCell.eevntIconImage.image?.withRenderingMode(.alwaysTemplate)
        eventsCell.eevntIconImage.tintColor = UIColor(named: "Grey")
        
        Network.shared.eventAttendees(key: event.key!) { (attendees) in
            for user in attendees{
                if user.userID == Network.currentUser?.uid{
                    eventsCell.eevntIconImage.image = #imageLiteral(resourceName: "circle-tick-7")
                    eventsCell.eevntIconImage.image = eventsCell.eevntIconImage.image?.withRenderingMode(.alwaysTemplate)
                    eventsCell.eevntIconImage.tintColor = UIColor.white
                    eventsCell.eevntIconImage.backgroundColor = UIColor(named: "Green")
                    eventsCell.eevntIconImage.layer.cornerRadius = eventsCell.eevntIconImage.bounds.height / 2
                    eventsCell.eevntIconImage.clipsToBounds = true
                    return
                }
            }
        }
        
        return eventsCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        index = [0, indexPath.row]

        didTap = true
        if let vc = storyboard?.instantiateViewController(withIdentifier: "eventDetailView") as? EventDetailViewController {
            vc.eventTitle = event.title!
            vc.eventDescription = event.description!
            vc.startTime = event.startTime!
            vc.endTime = event.endTime!
            vc.date = event.startTime!
            vc.key = event.key!
            
            Network.shared.eventAttendees(key: event.key!) { (attendees) in
                for user in attendees{
                    if user.userID == Network.currentUser?.uid{
                        vc.isAttending = true
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}


