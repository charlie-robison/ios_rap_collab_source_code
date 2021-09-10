//
//  PostController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/6/21.
//

import UIKit
import SafariServices

class PostController: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    
    let apiCall = ApiCalls()
    
    var username = ""
    var post: UserPost?
    var likeButtonTapped = false
    
    func setUpPost() {
        postLikes.text = "Likes: " + String(post!.numberOfLikes)
        postCaption.numberOfLines = 10
        postCaption.text = post!.username + ": " + post!.postCaption
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = post!.username
        setUpPost()
    }
    
    /*Adds PostLike data from DB to array.*/
    func getLikes(dataFromDB: String) -> [PostLike] {
        var likes: [PostLike] = []
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            likes = try JSONDecoder().decode([PostLike].self, from: dataFromDB.data(using: .utf8)!);
            print("Likes: ", likes)
        } catch {
            print("Failed to decode posts!")
            return []
        }
        return likes
    }

    @IBAction func likePost(_ sender: Any) {
        var likes: Int = post!.numberOfLikes
        //Checks if user already liked the post.
        apiCall.getLike(username: post!.username, likesUsername: username, postNumber: post!.postNumber) { data in
            //Accesses searched like from DB.
            let likesArray = self.getLikes(dataFromDB: data)
            //Checks if there is only one result from DB.
            if (likesArray.count > 0 && !self.likeButtonTapped) {
                //Subtracts like.
                likes -= 1
                self.postLikes.text = "Likes: " + String(likes)
                self.likeButtonTapped = false
                //Posts the unlike for the post to the DB.
                self.apiCall.unlikePost(username: self.post!.username, likesUsername: self.username, postNumber: self.post!.postNumber)
            } else {
                //Adds like.
                likes += 1
                self.postLikes.text = "Likes: " + String(likes)
                self.likeButtonTapped = true
                //Posts the like for the post to the DB.
                self.apiCall.likePost(username: self.post!.username, likesUsername: self.username, postNumber: self.post!.postNumber)
            }
        }
    }
    @IBAction func commentPost(_ sender: Any) {
    }
    @IBAction func playButton(_ sender: Any) {
    }
    @IBAction func viewComments(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let commentController = storyBoard.instantiateViewController(withIdentifier: "CommentController") as! CommentController
        commentController.username = username
        commentController.postUsername = post!.username
        commentController.postNumber = post!.postNumber
        navigationController?.pushViewController(commentController, animated: true)
    }
}
