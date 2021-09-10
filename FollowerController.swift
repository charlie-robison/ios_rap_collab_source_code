//
//  FollowerController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/6/21.
//

import UIKit

class FollowerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followerTable: UITableView!
    
    var followers: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Followers"
        followerTable.delegate = self
        followerTable.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followers.count == 0 {
            return 1
        }
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Checks if there are no followers.
        if followers.count == 0 {
            //Creates a cell which indicates there are no followers.
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Followers"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        //Creates cells.
        guard let cell = followerTable.dequeueReusableCell(withIdentifier: "FollowerCell", for: indexPath) as? FollowerCell else {
            return UITableViewCell()
        }
        cell.followerUsername.text = followers[indexPath.row].followerUsername
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //Creates a refrence to the ProfileController VC.
        let profileVc = storyboard.instantiateViewController(withIdentifier: "ProfileController2") as! ProfileController
        //Sets profile username to the follower's username.
        profileVc.username = followers[indexPath.row].followerUsername
        navigationController?.pushViewController(profileVc, animated: true)
    }
    
    

}
