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
    static let addFriendRoute = Route(path: basePath + "/users/me/friends", method: Method.POST)
    static let friendsListRoute = Route(path: basePath + "/users/me/friends", method: Method.GET)
    static let deleteFriendRoute = Route(path: basePath + "/users/me/friends", method: Method.DELETE)
    
    // TODO: Finish implementation
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
                            completionHandler(deleted: false)
                        }
                    }
                case .Failure(_):
                    completionHandler(deleted: false)
                }
        }
    }
}