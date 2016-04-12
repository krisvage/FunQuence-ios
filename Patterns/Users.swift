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
    
    static func login(username: String, password: String, completionHandler: (token: String?, message: String?, error: String?) -> ()) {
        let params = ["username": username, "password": password]
        
        Alamofire.request(loginRoute!.method, loginRoute!.path, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            let token = parsed_json["token"].stringValue
                            let message = parsed_json["message"].stringValue

                            completionHandler(token: token, message: message, error: nil)
                        } else {
                            let error = parsed_json["error"].stringValue
                            
                            completionHandler(token: nil, message: nil, error: error)
                        }
                    }
                case .Failure(_):
                    completionHandler(token: nil, message: nil, error: "failed request")
                }
        }
    }
    
    static func register(username: String, email: String, password: String, completionHandler: (token: String?, message: String?, error: String?) -> ()) {
        let params = ["username": username, "email": email, "password": password]

        Alamofire.request(registerRoute!.method, registerRoute!.path, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        
                        if parsed_json["error"] == nil {
                            let token = parsed_json["token"].stringValue
                            let message = parsed_json["message"].stringValue

                            completionHandler(token: token, message: message, error: nil)
                        } else {
                            let error = parsed_json["error"].stringValue
                            
                            completionHandler(token: nil, message: nil, error: error)
                        }
                    }
                case .Failure(_):
                    completionHandler(token: nil, message: nil, error: "failed request")
                }
        }
    }

    static func myUser(token: String, completionHandler: (userJSON: JSON?, errorOccured: Bool) -> ()) {
        let headers = ["x-access-token": token]
        
        Alamofire.request(myUserRoute!.method, myUserRoute!.path, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        
                        completionHandler(userJSON: parsed_json["user"], errorOccured: false)
                    }
                case .Failure(_):
                    completionHandler(userJSON: nil, errorOccured: true)
                }
        }
    }
}