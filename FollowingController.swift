//
//  FollowingController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/7/21.
//

import UIKit
import Alamofire

class FollowingController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followingTable: UITableView!
    
    let apiCall = ApiCalls()
    
    var following: [Following] = []
    var username = "DJ Chack"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Following"
        followingTable.delegate = self
        followingTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func changeData() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let profileController  = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.following = following
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if following.count == 0 {
            return 1
        }
        return following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Checks if there are no followers.
        if following.count == 0 {
            //Creates a cell which indicates there are no followers.
            let cell = UITableViewCell()
            cell.textLabel?.text = "You Do Not Follow Anyone"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        //Creates cells.
        guard let cell = followingTable.dequeueReusableCell(withIdentifier: "FollowingCell", for: indexPath) as? FollowingCell else {
            return UITableViewCell()
        }
        cell.followingUsername.text = following[indexPath.row].followingUsername
        cell.unfollowUser = {
            let user = self.following[indexPath.row]
            self.following.remove(at: indexPath.row)
            self.followingTable.reloadData()
            self.apiCall.unfollowUser(username: user.username, followingUsername: user.followingUsername)
            self.changeData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //Creates a refrence to the ProfileController VC.
        let profileVc = storyboard.instantiateViewController(withIdentifier: "ProfileController2") as! ProfileController
        //Sets profile username to the following's username.
        profileVc.username = following[indexPath.row].followingUsername
        navigationController?.pushViewController(profileVc, animated: true)
    }


}
