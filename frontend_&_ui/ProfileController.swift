//
//  ProfileController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/3/21.
//

import UIKit
import Alamofire
import SafariServices

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var urlStack: UIStackView!
    @IBOutlet weak var url1Outlet: UIButton!
    @IBOutlet weak var url2Outlet: UIButton!
    @IBOutlet weak var url3Outlet: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var postCollection: UICollectionView!
    
    let apiCall = ApiCalls()
    
    var username: String = ""
    var posts: [UserPost] = []
    var followers: [Follower] = []
    var following: [Following] = []
    var profile: [UserProfile] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bioLabel.numberOfLines = 5
        self.title = username
        postCollection.delegate = self
        postCollection.dataSource = self
        usernameLabel.text = username
        //Gets all posts.
        apiCall.getAllPosts(username: username) { data in
            self.addToPostsArray(dataFromDB: data)
            self.postCollection.reloadData()
        }
        //Gets all followers.
        apiCall.getUserFollowers(username: username) { data in
            self.addToFollowersArray(dataFromDB: data)
            self.followerButton.setTitle(String(self.followers.count), for: .normal)
        }
        //Gets all following.
        apiCall.getUserFollowing(username: username) { data in
            self.addToFollowingArray(dataFromDB: data)
            self.followingButton.setTitle(String(self.following.count), for: .normal)
        }
        apiCall.getProfile(username: username) { data in
            self.addToProfileArray(dataFromDB: data)
            //Checks if there is profile info.
            if self.profile.count > 0 {
                //Sets text for bio and url names.
                self.bioLabel.text = self.profile[0].userBio
                self.url1Outlet.setTitle(self.profile[0].urlName1, for: .normal)
                self.url2Outlet.setTitle(self.profile[0].urlName2, for: .normal)
                self.url3Outlet.setTitle(self.profile[0].urlName3, for: .normal)
                //Checks if any of the url names are empty and removes the link.
                if self.profile[0].userUrl1 == "" {
                    self.urlStack.arrangedSubviews[0].removeFromSuperview()
                } else if self.profile[0].userUrl3 == "" {
                    self.urlStack.arrangedSubviews[1].removeFromSuperview()
                } else if self.profile[0].userUrl3 == "" {
                    self.urlStack.arrangedSubviews[2].removeFromSuperview()
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*Adds Follower data from DB to array.*/
    func addToFollowersArray(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            followers = try JSONDecoder().decode([Follower].self, from: dataFromDB.data(using: .utf8)!);
            print(followers);
        } catch {
            print("Failed to decode followers!")
        }
    }
    
    /*Adds Following data from DB to array.*/
    func addToFollowingArray(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            following = try JSONDecoder().decode([Following].self, from: dataFromDB.data(using: .utf8)!);
            print(following);
        } catch {
            print("Failed to decode following!")
        }
    }
    
    /*Adds Profile data from DB to array.*/
    func addToProfileArray(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            profile = try JSONDecoder().decode([UserProfile].self, from: dataFromDB.data(using: .utf8)!);
            print(profile);
        } catch {
            print("Failed to decode profiless!")
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = postCollection.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCollectionCell else {
            return UICollectionViewCell()
        }
        cell.postLikes.text = "Likes: " + String(posts[indexPath.row].numberOfLikes)
        return cell
    }
    
    /*Function for when cell is selected.*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        switchToPost(post: post)
    }
    
    func switchToPost(post: UserPost) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let postController  = storyboard.instantiateViewController(withIdentifier: "PostController") as! PostController
        postController.username = username
        postController.post = post
        navigationController?.pushViewController(postController, animated: true)
    }
    
    
    @IBAction func viewFollowers(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let followerController  = storyboard.instantiateViewController(withIdentifier: "FollowerController") as! FollowerController
        followerController.followers = followers
        navigationController?.pushViewController(followerController, animated: true)
    }
    
    @IBAction func viewFollowing(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let followingController  = storyboard.instantiateViewController(withIdentifier: "FollowingController") as! FollowingController2
        if following.count > 0 {
            followingController.following = following
        }
        navigationController?.pushViewController(followingController, animated: true)
    }
    
    @IBAction func editProfileButton(_ sender: Any) {
        print("Edit profile!")
    }
    
    @IBAction func friendSuggestions(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendController = storyboard.instantiateViewController(withIdentifier: "FriendController") as! FriendController
        friendController.username = username
        navigationController?.pushViewController(friendController, animated: true)
    }
    
    @IBAction func url1Button(_ sender: Any) {
        let url = URL(string: profile[0].userUrl1)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func url2Button(_ sender: Any) {
        let url = URL(string: profile[0].userUrl2)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func url3Button(_ sender: Any) {
        let url = URL(string: profile[0].userUrl3)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    
}
