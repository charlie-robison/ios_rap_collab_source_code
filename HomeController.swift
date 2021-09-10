//
//  ViewController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/3/21.
//

import UIKit
import Alamofire
import SafariServices

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTable: UITableView!

    let apiCall = ApiCalls()
    var posts: [UserPost] = []
    var username = ""
    var check = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome " + username + "!")
        self.title = "Rap Collab"
        self.feedTable.delegate = self;
        self.feedTable.dataSource = self;
        feedTable.rowHeight = self.feedTable.frame.height
        apiCall.getFeed(username: username) { data in
            self.addToPostsArray(dataFromDB: data)
            self.feedTable.reloadData()
        }
    }
    
    /*Adds UserPost data from DB to array.*/
    func addToPostsArray(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            posts = try JSONDecoder().decode([UserPost].self, from: dataFromDB.data(using: .utf8)!);
            print(posts);
        } catch {
            print("Failed to decode posts!")
        }
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = feedTable.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        //Adds post data to the cell.
        var likes = posts[indexPath.row].numberOfLikes
        cell.likeLabel.text = "Likes: " + String(likes)
        cell.postCaption.numberOfLines = 10
        cell.postCaption.text = posts[indexPath.row].username + ": " + posts[indexPath.row].postCaption
        cell.likePost = {
            //Checks if user already liked the post.
            self.apiCall.getLike(username: self.posts[indexPath.row].username, likesUsername: self.username, postNumber: self.posts[indexPath.row].postNumber) { data in
                //Accesses searched like from DB.
                let likesArray = self.getLikes(dataFromDB: data)
                //Checks if there is only one result from DB.
                if (likesArray.count > 0 && !cell.likeButtonTapped) {
                    //Subtracts like.
                    likes -= 1
                    cell.likeLabel.text = "Likes: " + String(likes)
                    cell.likeButtonTapped = false
                    //Posts the unlike for the post to the DB.
                    self.apiCall.unlikePost(username: self.posts[indexPath.row].username, likesUsername: self.username, postNumber: self.posts[indexPath.row].postNumber)
                } else {
                    //Adds like.
                    likes += 1
                    cell.likeLabel.text = "Likes: " + String(likes)
                    cell.likeButtonTapped = true
                    //Posts the like for the post to the DB.
                    self.apiCall.likePost(username: self.posts[indexPath.row].username, likesUsername: self.username, postNumber: self.posts[indexPath.row].postNumber)
                }
            }
        }
    
        cell.commentPost = {
            print("Comments Post")
        }
        
        cell.viewComments = {
            self.switchToComments(indexPath: indexPath)
        }
        
        return cell
    }
    
    /*Switches VC to CommentController by pushing it onto the Navigation Stack.*/
    func switchToComments(indexPath: IndexPath) {
        //Accesses storyboard.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //Creates a refrence to the CommentController VC.
        let commentVc = storyboard.instantiateViewController(withIdentifier: "CommentController") as! CommentController
        //Sends data to CommentController.
        commentVc.username = self.username
        commentVc.postUsername = self.posts[indexPath.row].username
        commentVc.postNumber = self.posts[indexPath.row].postNumber
        //Pushed CommentController VC onto the navigation stack.
        navigationController?.pushViewController(commentVc, animated: true)
    }

}

