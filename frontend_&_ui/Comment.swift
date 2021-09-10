//
//  Comment.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/4/21.
//

import Foundation

struct Comment: Decodable {
    var username: String
    var commenterUsername: String
    var postNumber: Int
    var comment: String
}
