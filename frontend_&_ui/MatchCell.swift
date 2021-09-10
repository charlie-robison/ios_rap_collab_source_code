//
//  MatchCell.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/14/21.
//

import UIKit

class MatchCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var followUser: (() -> Void)? = nil
    
    @IBAction func followButton(_ sender: Any) {
        followUser?()
    }
}
