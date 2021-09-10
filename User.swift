//
//  User.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/10/21.
//

import Foundation

struct User: Decodable {
    var username: String
    var password: String
    var userType: Int
    var genre: Int
}
