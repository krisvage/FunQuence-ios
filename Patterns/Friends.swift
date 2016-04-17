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
    static let friendsListRoute = Route(path: basePath + "/users/me/friends", method: Method.GET)
    static let addFriendRoute = Route(path: basePath + "/users/me/friends", method: Method.POST)
    static let deleteFriendRoute = Route(path: basePath + "/users/me/friends", method: Method.DELETE)
    
    // TODO: Use 'has_pending_invitation' as well
    static func friendsList(completionHandler: (friends: [(username: String, has_pending_invitation: String)]?, error: String?) -> ()) {
        Alamofire.request(friendsListRoute.method, friendsListRoute.path, headers: headers())
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            let friendsList = parsed_json["friendList"].arrayValue.map {
                                (friend) -> (username: String, has_pending_invitation: String) in
                                let username = friend["username"].stringValue
                                let has_pending_invitation = friend["has_pending_invitation"].stringValue
                                return (username: username, has_pending_invitation: has_pending_invitation)
                            }
                            completionHandler(friends: friendsList, error: nil)
                        } else {
                            completionHandler(friends: nil, error: parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(friends: nil, error: "request failed")
                }
        }
    }
    
    static func add(username: String, completionHandler: (added: Bool, error: String?) -> ()) {
        let params = ["username": username]
        
        Alamofire.request(addFriendRoute.method, addFriendRoute.path, headers: headers(), parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            completionHandler(added: true, error: nil)
                        } else {
                            let error = parsed_json["error"].stringValue
                            completionHandler(added: false, error: error)
                        }
                    }
                case .Failure(_):
                    completionHandler(added: false, error: nil)
                }
        }
    }

    static func delete(username: String, completionHandler: (deleted: Bool) -> ()) {
        let fullPath = deleteFriendRoute.path + "/" + username
        
        Alamofire.request(deleteFriendRoute.method, fullPath, headers: headers())
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            completionHandler(deleted: true)
                        } else {
                            print(parsed_json["error"].stringValue)
                            completionHandler(deleted: false)
                        }
                    }
                case .Failure(_):
                    print("request failed")
                    completionHandler(deleted: false)
                }
        }
    }
}