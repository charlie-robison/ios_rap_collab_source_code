//
//  CommentController.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/4/21.
//

import UIKit
import Alamofire

class CommentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    let apiCall = ApiCalls()
    
    var username = ""
    
    var comments: [Comment] = []
    var postUsername: String = ""
    var postNumber: Int = 0
    
    /*Sets up the comment table.*/
    func setUpTable() {
        //Assigns commentTable to the delegate and datasource in this controller.
        commentTable.delegate = self
        commentTable.dataSource = self
        //Estimates the row height based on how much text there is.
        commentTable.rowHeight = UITableView.automaticDimension
        commentTable.estimatedRowHeight = 80
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        setUpTable()
        loadAllComments()
    }
    
    /*Loads all comments for a post and reloads table view.*/
    func loadAllComments() {
        let wordConverter = StringConversion()
        postUsername = wordConverter.convertString(word: postUsername)
        apiCall.getAllComments(username: postUsername, postNumber: postNumber) { data in
            self.getComments(dataFromDB: data)
            self.commentTable.reloadData()
        }
    }
    
    /*Adds PostComment data from DB to array.*/
    func getComments(dataFromDB: String){
        //Do catch block.
        do {
            //Decodes the JSON objects in the structyure of User from dataFromDB using .utf8 encoding. This is stored in array, users.
            comments = try JSONDecoder().decode([Comment].self, from: dataFromDB.data(using: .utf8)!);
        } catch {
            print("Failed to decode comments!")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commentTable.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        let stringConverter = StringConversion()
        //Gets the commenter username.
        var commenterUsername = comments[indexPath.row].commenterUsername
        //Converts commenter username back to a normal string.
        commenterUsername = stringConverter.convertStringBack(word: commenterUsername)
        cell.commentLabel.numberOfLines = 5
        //Fills cell info with comment info.
        cell.commentLabel.text = commenterUsername + ": " + comments[indexPath.row].comment
        return cell
    }
    
    /*Posts a comment and adds it to the table view. The comment is then saved to the DB.*/
    @IBAction func postCommentButton(_ sender: Any) {
        //Creates a new comment object.
        let usernameOfPost = postUsername
        let commenterUsername = username
        let numberOfPost = postNumber
        let comment = commentTextField.text
        let newComment = Comment(username: usernameOfPost, commenterUsername: commenterUsername, postNumber: numberOfPost, comment: comment!)
        //Posts the comment to the DB.
        apiCall.createComment(username: usernameOfPost, commenterUsername: commenterUsername, postNumber: numberOfPost, comment: comment!)
        //Appends the object to the array of comments.
        comments.append(newComment)
        //Adds comment to table.
        commentTable.reloadData()
        //Resets comment text field.
        commentTextField.text = ""
    }
    
}
