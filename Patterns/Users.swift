//
//  Users.swift
//  Patterns
//
//  Created by Kristian Våge on 11.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Users {
    static let basePath = "http://recallo.noip.me/api"
    static let loginRoute = Route(path: basePath + "/login", method: Method.POST)
    static let registerRoute = Route(path: basePath + "/users", method: Method.POST)
    static let myUserRoute = Route(path: basePath + "/users/me", method: Method.GET)
    
    static func login(username: String, password: String, completionHandler: (String?, String?, String?) -> ()) {
        let params = ["username": username, "password": password]
        
        Alamofire.request(loginRoute!.method, loginRoute!.path, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            completionHandler(parsed_json["token"].stringValue, parsed_json["message"].stringValue, nil)
                        } else {
                            completionHandler(nil, nil, parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(nil, nil, "failed request")
                }
        }
    }
    
    static func register(username: String, email: String, password: String, completionHandler: (String?, String?, String?) -> ()) {
        let params = ["username": username, "email": email, "password": password]
        
        Alamofire.request(registerRoute!.method, loginRoute!.path, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        
                        if parsed_json["error"] == nil {
                            completionHandler(parsed_json["token"].stringValue, parsed_json["message"].stringValue, nil)
                        } else {
                            completionHandler(nil, nil, parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(nil, nil, "failed request")
                }
        }
    }

    static func myUser(token: String, completionHandler: (JSON?, Bool) -> ()) {
        let headers = ["x-access-token": token]
        
        Alamofire.request(myUserRoute!.method, myUserRoute!.path, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        
                        completionHandler(parsed_json["user"], false)
                    }
                case .Failure(_):
                    completionHandler(nil, true)
                }
        }
    }
}