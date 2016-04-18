//
//  Friends.swift
//  Patterns
//
//  Created by Kristian Våge on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Friends: API {
    static let friendsListRoute = Route(path: basePath + "/users/me/friends", method: .GET)
    static let addFriendRoute = Route(path: basePath + "/users/me/friends", method: .POST)
    static let deleteFriendRoute = Route(path: basePath + "/users/me/friends", method: .DELETE)
    
    typealias friendsListHandler = (friends: [(username: String, has_pending_invitation: String)]?, error: String?) -> ()
    typealias addFriendHandler = (added: Bool, error: String?) -> ()
    typealias deleteFriendHandler = (deleted: Bool, error: String?) -> ()

    /**
     GET /users/me/friends
     
     Get userlist for current user
     
     => friends, error
     */
    static func friendsList(completionHandler: friendsListHandler) {
        request(friendsListRoute) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    let friendsList = json["friendList"].arrayValue.map {
                        (friend) -> (username: String, has_pending_invitation: String) in
                        
                        let username = friend["username"].stringValue
                        let has_pending_invitation = friend["has_pending_invitation"].stringValue
                        return (username: username, has_pending_invitation: has_pending_invitation)
                    }
                    completionHandler(friends: friendsList, error: nil)
                } else {
                    completionHandler(friends: nil, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(friends: nil, error: "API http request failed")
            }
        }
    }
    
    /**
     POST /users/me/friends
     
     Add a new user to your friendlist.
     
     => added, error
     */
    static func add(username: String, completionHandler: addFriendHandler) {
        let params = ["username": username]
        
        request(addFriendRoute, parameters: params) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    completionHandler(added: true, error: nil)
                } else {
                    completionHandler(added: false, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(added: false, error: "API http request failed")
            }
        }
    }

    /**
     DELETE /users/me/friends/:username

     Delete :username from friend list.
     
     => deleted, error
     */
    static func delete(username: String, completionHandler: deleteFriendHandler) {
        let fullPath = deleteFriendRoute.path + "/" + username
        let route = Route(path: fullPath, method: deleteFriendRoute.method)
        
        request(route) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    completionHandler(deleted: true, error: nil)
                } else {
                    completionHandler(deleted: false, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(deleted: false, error: "API http request failed")
            }
        }
    }
}