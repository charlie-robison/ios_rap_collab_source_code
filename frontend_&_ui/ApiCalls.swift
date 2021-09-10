//
//  ApiCalls.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/10/21.
//

import Foundation
import Alamofire

class ApiCalls {
    
    /*Gets a user's data*/
    func getUser(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/userInfo/"+newUsername+"/get").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Creates user data*/
    func createUser(username: String, password: String, userType: Int, genre: Int) {
        let params = ["username": username, "password": password, "userType": userType, "genre": genre] as [String : Any]
        AF.request("http://127.0.0.1:8000/userInfo/create", method: .post, parameters: params).response { response in
            debugPrint(response.result)
        }
    }
    
    /*Gets profile data for a user*/
    func getProfile(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/profileInfo/"+newUsername+"/get").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Creates profile data*/
    func createProfile(username: String, userBio: String, userUrl1: String, userUrl2: String, userUrl3: String, urlName1: String, urlName2: String, urlName3: String) {
        let params = ["username": username, "userBio": userBio, "userUrl1": userUrl1, "userUrl2": userUrl2, "userUrl3": userUrl3, "urlName1": urlName1, "urlName2": urlName2, "urlName3": urlName3]
        AF.request("http://127.0.0.1:8000/profileInfo/create", method: .post, parameters: params).response { response in
            debugPrint(response.result)
        }
    }
    
    
    
    /*Follows a user. username is the user being followed. followingUsername is the user following.*/
    func followUser(username: String, followingUsername: String) {
        let params = ["username": username, "followingUsername": followingUsername]
        AF.request("http://127.0.0.1:8000/followingInfo/followUser", method: .post, parameters: params).response { response in
            debugPrint(response.result)
        }
    }
    
    /*Unfollows a user. username is the user being unfollowed. followingUsername is the user unfollowing.*/
    func unfollowUser(username: String, followingUsername: String) {
        let params = ["username": username, "followingUsername": followingUsername]
        AF.request("http://127.0.0.1:8000/followingInfo/unfollowUser", method: .delete, parameters: params).response { response in
            debugPrint(response.result)
        }
    }
    
    /*Gets all of the user's followers.*/
    func getUserFollowers(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/followerInfo/"+newUsername+"/getAll").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Gets all of the user's following.*/
    func getUserFollowing(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/followingInfo/"+newUsername+"/getAll").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*User creates a post.*/
    func createPost(username: String, postCaption: String, postUrl: String, urlName: String) {
        let params = ["username": username, "postNumber": 0, "postCaption": postCaption, "numberOfLikes": 0, "numberOfComments": 0, "postUrl": postUrl, "urlName": urlName] as [String : Any]
        AF.request("http://127.0.0.1:8000/followingInfo/unfollowUser", method: .post, parameters: params).response { response in
            debugPrint(response.result)
        }
    }
    
    /*Gets all the posts posted by the user.*/
    func getAllPosts(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/postInfo/"+newUsername+"/getAllPosts").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Gets a specific post from the user.*/
    func getPost(username: String, postNumber: Int, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/postInfo/"+newUsername+"/"+String(postNumber)+"/getPost").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Gets a specific like for a post from the DB.*/
    func getLike(username: String, likesUsername: String, postNumber: Int, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        let newLikesUsername = stringConveter.convertString(word: likesUsername)
        AF.request("http://127.0.0.1:8000/postInfo/"+newUsername+"/"+newLikesUsername+"/"+String(postNumber)+"/getLike").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*User likes a post.*/
    func likePost(username: String, likesUsername: String, postNumber: Int) {
        let params = ["username": username, "likesUsername": likesUsername, "postNumber": postNumber] as [String : Any]
        AF.request("http://127.0.0.1:8000/postInfo/likePost", method: .post, parameters: params).response { response in
            debugPrint(response.result)
        }
    }
    
    /*User unlikes a post they previously liked.*/
    func unlikePost(username: String, likesUsername: String, postNumber: Int) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        let newLikesUsername = stringConveter.convertString(word: likesUsername)
        AF.request("http://127.0.0.1:8000/postInfo/"+newUsername+"/"+newLikesUsername+"/"+String(postNumber)+"/unlikePost", method: .delete).response { response in
            debugPrint(response.result)
        }
    }
    
    /*Gets all comments from a particular post.*/
    func getAllComments(username: String, postNumber: Int, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/postInfo/"+newUsername+"/"+String(postNumber)+"/getAllComments").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*User likes a comment on a post. username is the user of the post, commenterUsername is the user commenting*/
    func createComment(username: String, commenterUsername: String, postNumber: Int, comment: String) {
        let params = ["username": username, "commenterUsername": commenterUsername, "postNumber": postNumber, "comment": comment] as [String : Any]
        AF.request("http://127.0.0.1:8000/postInfo/commentPost", method: .post, parameters: params).response { response in
            debugPrint(response.result)
        }
    }
    
    /*Deletes a comment from a post.*/
    func deleteComment(username: String, commenterUsername: String, comment: String, postNumber: Int) {
        //
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        let newCommenterUsername = stringConveter.convertString(word: commenterUsername)
        let newComment = stringConveter.convertString(word: comment)
        AF.request("http://127.0.0.1:8000/postInfo/"+newUsername+"/"+newCommenterUsername+"/"+newComment+"/"+String(postNumber)+"/commentPost", method: .delete).response { response in
            debugPrint(response.result)
        }
    }
    
    /*Gets a user's feed based on the users they follow.*/
    func getFeed(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/postInfo/"+newUsername+"/getFeed").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Creates friend suggestions for a user.*/
    func createFriendSuggestions(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/friendSuggestions/"+newUsername+"/createSuggestions").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Gets the user's friend suggestions.*/
    func getFriendSuggestions(username: String, completionHandler: @escaping (String) -> Void) {
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/friendSuggestions/"+newUsername+"/getSuggestions").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    /*Gets a user's matches*/
    func getMatches(username: String, typeRequested: Int, completionHandler: @escaping (String) -> Void) {
        //
        let stringConveter = StringConversion()
        let newUsername = stringConveter.convertString(word: username)
        AF.request("http://127.0.0.1:8000/matchInfo/"+newUsername+"/"+String(typeRequested)+"/getMatches").response { response in
            let data = String(data: response.data!, encoding: .utf8)
            switch response.result {
            case .success(_):
                completionHandler(data!)
                break;
            case .failure(_):
                print("Failed!")
                break;
            }
        }
    }
    
    
}
