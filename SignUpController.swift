//
//  SignUpController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/10/21.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    let apiCall = ApiCalls()
    
    var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        password2TextField.isSecureTextEntry = true
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
    
    @IBAction func signUpButton(_ sender: Any) {
        //Stores inputs.
        let username = usernameTextField.text
        let password = passwordTextField.text
        let password2 = password2TextField.text
        //Checks if the passwords are the same.
        if password == password2 {
            //Gets all users with the username inputted.
            apiCall.getUser(username: username!) { data in
                self.getUsers(dataFromDB: data)
                //Checks if there are no users with the same username.
                if self.users.count == 0 {
                    //Creates a user with the given info and adds it to DB.
                    self.apiCall.createUser(username: username!, password: password!, userType: 1, genre: 1)
                    //Pops all view controllers off the navigation stack untilit reach the root view controller.
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Username already taken!")
                    return
                }
            }
        } else {
            print("Passwords do not match!")
            return
        }
    }
}
