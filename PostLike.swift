//
//  PostLike.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/4/21.
//

import Foundation

struct PostLike: Decodable {
    var username: String
    var likesUsername: String
    var postNumber: Int
}
