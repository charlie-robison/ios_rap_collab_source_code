//
//  FollowingCell.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/7/21.
//

import UIKit

class FollowingCell: UITableViewCell {

    @IBOutlet weak var followingImage: UIImageView!
    @IBOutlet weak var followingUsername: UILabel!
    
    var unfollowUser: (() -> Void)? = nil
    
    @IBAction func unfollowButton(_ sender: Any) {
        unfollowUser?()
    }
}
