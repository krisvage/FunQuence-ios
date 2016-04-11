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
    static let loginRoute = Route(path: "/login", method: Method.POST)
    
    static func login(username: String, password: String) -> String {
        var token = "abc"
        
        
        // loginRoute!.method, basePath + loginRoute!.path
        Alamofire.request(loginRoute!.method, basePath + loginRoute!.path, parameters: ["username": username, "password": password])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.response?.statusCode)
                print(response.data)     // server data
                
                print(response.result)   // result of response serialization
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                    let parsed_json = JSON(json)
                    print("message \(parsed_json["message"].stringValue)")
                    token = parsed_json["token"].stringValue
                    print(token)
                }
        }
        
        return token
    }
}