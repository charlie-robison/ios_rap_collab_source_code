//
//  UserProfile.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/15/21.
//

import Foundation

struct UserProfile: Decodable {
    var username: String
    var userBio: String
    var userUrl1: String
    var userUrl2: String
    var userUrl3: String
    var urlName1: String
    var urlName2: String
    var urlName3: String
}
