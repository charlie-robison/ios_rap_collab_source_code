//
//  MatchController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/3/21.
//

import UIKit

class MatchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var producerOutlet: UIButton!
    @IBOutlet weak var rapperOutlet: UIButton!
    @IBOutlet weak var sampleOutlet: UIButton!
    @IBOutlet weak var matchTable: UITableView!
    
    let apiCall = ApiCalls()
    let findType = GetType()
    
    var username = ""
    var matches: [User] = []
    var following: [Following] = []
    var typeRequested = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchTable.delegate = self
        matchTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matches.count == 0 {
            return 1
        }
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Checks if there are no matches.
        if matches.count == 0 {
            //Creates one cell which indicates that are no matches.
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Matches"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        //Creates a cell using MatchCell as the class.
        guard let cell = matchTable.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as? MatchCell else {
            return UITableViewCell()
        }
        cell.usernameLabel.text = matches[indexPath.row].username
        cell.typeLabel.text = findType.getType(typeRequested: matches[indexPath.row].userType)
        //Follows the match.
        cell.followUser = {
            //Follows the user.
            self.apiCall.followUser(username: self.username, followingUsername: self.matches[indexPath.row].username)
            //Removes the match.
            self.matches.remove(at: indexPath.row)
            self.matchTable.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //Creates a refrence to the ProfileController VC.
        let profileVc = storyboard.instantiateViewController(withIdentifier: "ProfileController2") as! ProfileController
        //Sets profile username to the following's username.
        profileVc.username = matches[indexPath.row].username
        navigationController?.pushViewController(profileVc, animated: true)
    }
    
    /*Adds User data from DB to array.*/
    func getUsers(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            matches = try JSONDecoder().decode([User].self, from: dataFromDB.data(using: .utf8)!);
            print(matches);
        } catch {
            print("Failed to decode matches!")
        }
    }
    
    /*Adds Following data from DB to array.*/
    func getFollowing(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            following = try JSONDecoder().decode([Following].self, from: dataFromDB.data(using: .utf8)!);
            print(following);
        } catch {
            print("Failed to decode following!")
        }
    }
    
    /*Removes user's the user already follows from matches list.*/
    func removeFollowing() {
        var matchNames: [String] = []
        var followingNames: [String] = []
        //Gets all following names.
        for user in following {
            followingNames.append(user.followingUsername)
        }
        //Gets all match names.
        for user in matches {
            matchNames.append(user.username)
        }
        //Removes any users the user follows in the matches.
        for i in 0..<followingNames.count {
            if matchNames.contains(followingNames[i]) {
                let index = matchNames.firstIndex(of: followingNames[i])
                matches.remove(at: index!)
                matchNames.remove(at: index!)
            }
        }
    }
    
    @IBAction func producerButton(_ sender: Any) {
        typeRequested = 1
        producerOutlet.backgroundColor = .yellow
        rapperOutlet.backgroundColor = .none
        sampleOutlet.backgroundColor = .none
    }
    
    @IBAction func rapperButton(_ sender: Any) {
        typeRequested = 2
        producerOutlet.backgroundColor = .none
        rapperOutlet.backgroundColor = .yellow
        sampleOutlet.backgroundColor = .none
    }
    
    @IBAction func sampleButton(_ sender: Any) {
        typeRequested = 3
        producerOutlet.backgroundColor = .none
        rapperOutlet.backgroundColor = .none
        sampleOutlet.backgroundColor = .yellow
    }
    
    @IBAction func matchButton(_ sender: Any) {
        //Gets all matches from DB.
        apiCall.getMatches(username: username, typeRequested: typeRequested) { data in
            self.getUsers(dataFromDB: data)
            if self.matches.count != 0 {
                //Gets all following for DB.
                self.apiCall.getUserFollowing(username: self.username) { followingData in
                    self.getFollowing(dataFromDB: followingData)
                    //Removes users the user follows.
                    self.removeFollowing()
                    self.matchTable.reloadData()
                }
            }
        }
    }
}
