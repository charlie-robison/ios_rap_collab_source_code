//
//  FriendCell.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/11/21.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendUsername: UILabel!
    @IBOutlet weak var followButtonOutlet: UIButton!
    
    var followCheck = false
    
    var followUser: (() -> Void)?
    
    @IBAction func followButton(_ sender: Any) {
        followUser?()
    }
}
