//
//  NetworkTwo.swift
//  InnovationAdvocates
//
//  Created by Neil on 23/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import Foundation
import Firebase
import LocalAuthentication
import SVProgressHUD

class NetworkTwo{
    static let shared = NetworkTwo()
    let db = Firestore.firestore()
    var ref = Storage.storage().reference()

    
    func getEvents(completion: @escaping([Event], [EventAttendee])->()){
        var events = [Event]()
        var attendees = [EventAttendee]()
        db.collection("Events").getDocuments { (snap, err) in
            for doc in (snap?.documents)!{
                let title = doc.data()["title"] as! String
                let description = doc.data()["description"] as! String
                let startDate = doc.data()["startDate"] as! Date
                let endDate = doc.data()["endDate"] as! Date
                let spaces = doc.data()["spaces"] as! Int
                let key = doc.documentID
                events.insert(Event(title: title, description: description, startTime: startDate, endTime: endDate, spaces: spaces, key: key, attendees: nil), at: 0)
            }
            
            for event in events{
                self.db.collection("Events").document(event.key!).collection("attendees").getDocuments(completion: { (snap, err) in
                    for doc in (snap?.documents)!{
                        let userID = doc.documentID
                        let userImage = doc.data()["userImage"]
                        attendees.insert(EventAttendee(userID: userID, userImage: userImage as! String), at: 0)
                    }
                })
                completion(events, attendees)
                print()
            }
            
            
        }
    }
}
