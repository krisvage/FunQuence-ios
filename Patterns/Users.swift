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

class Users: API {
    static let loginRoute = Route(path: basePath + "/login", method: .POST)
    static let registerRoute = Route(path: basePath + "/users", method: .POST)
    static let meRoute = Route(path: basePath + "/users/me", method: .GET)
    static let setDeviceTokenRoute = Route(path: basePath + "/users/me", method: .PUT)

    
    typealias loginRegisterHandler = (token: String?, message: String?, error: String?) -> ()
    typealias meHandler = (username: String?, email: String?, errorOccured: Bool) -> ()
    
    static let loginRegisterClosure: (Response<AnyObject, NSError>, loginRegisterHandler) -> () = { response, completionHandler in
        switch response.result {
        case .Success(_):
            let json = JSON(response.result.value!)
            
            if json["error"] == nil {
                let token = json["token"].stringValue
                let message = json["message"].stringValue
                
                completionHandler(token: token, message: message, error: nil)
            } else {
                completionHandler(token: nil, message: nil, error: json["error"].stringValue)
            }
        case .Failure(_):
            completionHandler(token: nil, message: nil, error: "API http request failed")
        }
    }

    /**
     POST /login
     
     Log a user in and get a JWT (token).
     
     => token, message, error
     */
    static func login(username: String, password: String, completionHandler: loginRegisterHandler) {
        let params = ["username": username, "password": password]
        
        request(loginRoute, parameters: params) { response in
            loginRegisterClosure(response, completionHandler)
        }
    }
    
    /**
     POST /users
     
     Register a new account.
     
     => token, message, error
     */
    
    static func register(username: String, email: String, password: String, device_token: String?, completionHandler: loginRegisterHandler) {
        var device_token_string = ""
        if device_token != nil {
            device_token_string = device_token!;
        }
        
        let params = ["username": username, "email": email, "password": password, "device_token": device_token_string]
        
        request(registerRoute, parameters: params) { response in
            loginRegisterClosure(response, completionHandler)
        }
    }
    
    /**
     PUT /users/me
     
     Set new device_token for user
     
     => token, message, error
     */
    static func setDeviceToken(device_token: String, completionHandler: ((errorOccured: Bool) -> Void)?) {
        let params = [ "device_token": device_token]
        
        request(setDeviceTokenRoute, parameters: params) { response in
            if(completionHandler != nil){
                completionHandler!(errorOccured: false)
            }
        }
    }

    /**
     GET /users/me

     Get current user.
     
     => username, email, errorOccured
     */
    static func me(completionHandler: meHandler) {
        request(meRoute) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                completionHandler(
                    username: json["user"]["username"].stringValue,
                    email: json["user"]["email"].stringValue,
                    errorOccured: false
                )
            case .Failure(_):
                completionHandler(username: nil, email: nil, errorOccured: true)
            }
        }
    }
}