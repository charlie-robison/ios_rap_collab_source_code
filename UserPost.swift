//
//  UserPost.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/3/21.
//

import Foundation

struct UserPost: Decodable {
    var username: String
    var postNumber: Int
    var postCaption: String
    var numberOfLikes: Int
    var numberOfComments: Int
    var postUrl: String
    var urlName: String
}
