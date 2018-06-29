//
//  Reply.swift
//  InnovationAdvocates
//
//  Created by Neil on 26/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import Foundation

struct Reply {
    let username: String?
    let profileImage: String?
    let postContent: String?
    let postImageURL: String?
    let date: Date?
    let key: String?
    let numberOfLikes: Int?
    let likedBy: [String:Any]?
}
