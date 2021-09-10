//
//  PostCell.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/3/21.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var urlOutlet: UIButton!
    
    var likePost: (() -> Void)? = nil
    var pressUrl: (() -> Void)? = nil
    var likeButtonTapped = false;
    var commentPost: (() -> Void)? = nil
    var viewComments: (() -> Void)? = nil
    var playSong: (() -> Void)? = nil
    
    @IBOutlet weak var playSongButton: UIButton!
    
    @IBAction func likeButton(_ sender: Any) {
        likePost?()
    }
    
    @IBAction func urlButton(_ sender: Any) {
        pressUrl?()
    }
    
    @IBAction func commentButton(_ sender: Any) {
        commentPost?()
    }
    @IBAction func viewCommentsButton(_ sender: Any) {
        viewComments?()
    }
}
