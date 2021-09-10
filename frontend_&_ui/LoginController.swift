//
//  LoginController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/10/21.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let apiCall = ApiCalls()
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
    
    /*Adds User data from DB to array.*/
    func getUsers(dataFromDB: String) {
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            users = try JSONDecoder().decode([User].self, from: dataFromDB.data(using: .utf8)!);
            print(users);
        } catch {
            print("Failed to decode posts!")
        }
    }
    
    /*Creates a UITabBarController withe appropriate navigation and view controllers.*/
    func createTabBar(username: String) -> UITabBarController {
        //Accesses storyboard.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //Creates reference to TabBar Controller.
        let tabVc = storyboard.instantiateViewController(withIdentifier: "TabBar") as! TabBarController
        //Creates reference to Home Navigation Controller.
        let navVc1 = storyboard.instantiateViewController(withIdentifier: "HomeNavController") as! HomeNavController
        let navVc2 = storyboard.instantiateViewController(withIdentifier: "MatchNavController") as! MatchNavController
        let navVc3 = storyboard.instantiateViewController(withIdentifier: "ProfileNavController") as! ProfileNavController
        //Creates reference to Home View Controller.
        let homeVc = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        let matchVc = storyboard.instantiateViewController(withIdentifier: "MatchController") as! MatchController
        let profileVc = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        //Sets username in to all view controllers
        homeVc.username = username
        matchVc.username = username
        profileVc.username = username
        //Sets 1st view controller to each navigation controller to the correspoding vc.
        navVc1.viewControllers[0] = homeVc
        navVc2.viewControllers[0] = matchVc
        navVc3.viewControllers[0] = profileVc
        //Sets navVcs for each tab in the tab bar controller.
        tabVc.viewControllers?[0] = navVc1
        tabVc.viewControllers?[1] = navVc2
        tabVc.viewControllers?[2] = navVc3
        tabVc.viewControllers?[2].title = username
        tabVc.modalPresentationStyle = .fullScreen
        return tabVc
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let username = usernameTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        apiCall.getUser(username: username) { data in
            self.getUsers(dataFromDB: data)
            if self.users.count > 0 {
                let user = self.users[0]
                if user.username == username && user.password == password {
                    let tabVc = self.createTabBar(username: username)
                    self.present(tabVc, animated: true, completion: nil)
                }
            } else {
                print("EITHER YOUR USERNAME OR PASSWORD IS INCORRECT!!")
            }
        }
    }
    
}
