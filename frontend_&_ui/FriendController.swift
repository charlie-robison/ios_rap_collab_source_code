//
//  FriendController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/10/21.
//

import UIKit

class FriendController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendTable: UITableView!
    
    let apiCall = ApiCalls()
    
    var username: String = ""
    var followers: [Follower] = []
    var friendSuggestions: [Following] = []
    var suggestions: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        friendTable.delegate = self
        friendTable.dataSource = self
        //Creates friend suggestions for the user.
        apiCall.getFriendSuggestions(username: username) { data in
            //Gets friends from DB.
            self.getFriends(dataFromDB: data)
            //Removes any duplicate friend suggestions.
            self.removeDuplicates()
            self.friendTable.reloadData()
        }
    }
    
    /*Removes any duplicate friend suggestions from list.*/
    func removeDuplicates() {
        //Loops through each friend in friend suggestions.
        for friend in friendSuggestions {
            //Adds the username to the suggestions list.
            suggestions.append(friend.followingUsername)
        }
        //Creates a copy of suggestions.
        let filteredSuggestions = suggestions
        //Sets suggestions to an empty list.
        suggestions = []
        //Loops through all suggestions.
        for suggestion in filteredSuggestions {
            //Checks if suggestions does not contain suggestion.
            if !suggestions.contains(suggestion) {
                //Add suggestion to suggestions.
                suggestions.append(suggestion)
            }
        }
    }
    
    /*Adds FriendSuggestion data from DB to array.*/
    func getFriends(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            friendSuggestions = try JSONDecoder().decode([Following].self, from: dataFromDB.data(using: .utf8)!);
        } catch {
            print("Failed to decode friend suggestions!")
        }
    }
    
    
    /*Adds Follower data from DB to array.*/
    func addToFollowersArray(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            followers = try JSONDecoder().decode([Follower].self, from: dataFromDB.data(using: .utf8)!);
            print("Followers: ", followers);
        } catch {
            print("Failed to decode followers!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if suggestions.count == 0 {
            return 1
        }
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Checks if there are no followers.
        if suggestions.count == 0 {
            //Creates a cell which indicates there are no followers.
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Suggestions Available"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        guard let cell = friendTable.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        //Adds data to the cell.
        cell.friendUsername.text = suggestions[indexPath.row]
        //Follow button was pressed.
        cell.followUser = {
            //Gets all of the friend suggestions followers.
            self.apiCall.getUserFollowers(username: self.suggestions[indexPath.row]) { data in
                self.addToFollowersArray(dataFromDB: data)
                //Loops throigh each follower.
                for follower in self.followers {
                    //Checks if any of the followers match the user pressing the button.
                    if follower.followerUsername == self.username  && cell.followCheck {
                        //Changes the text of the button to follow.
                        cell.followButtonOutlet.setTitle("Follow", for: .normal)
                        //User unfollows the other user.
                        self.apiCall.unfollowUser(username: self.username, followingUsername: self.suggestions[indexPath.row])
                        cell.followCheck = false
                        return
                    }
                }
                //User follows the friend suggestion.
                self.apiCall.followUser(username: self.username, followingUsername: self.suggestions[indexPath.row])
                //Changes the text of the button to unfollow.
                cell.followButtonOutlet.setTitle("Unfollow", for: .normal)
                cell.followCheck = true
            }
            
        }
        return cell
    }
    

}
