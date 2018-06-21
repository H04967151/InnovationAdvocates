//
//  Events.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import Foundation

struct Event {
    let title: String?
    let description: String?
    let startTime: Date?
    let endTime: Date?
    let spaces: Int?
    let key: String?
}

struct EventAttendee {
    let userID: String?
    let userImage: String?
}
