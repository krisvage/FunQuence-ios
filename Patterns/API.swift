//
//  API.swift
//  Patterns
//
//  Created by Kristian Våge on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

class API {
    static let basePath = "http://recallo.noip.me/api"
    
    static func headers() -> [String: String] {
        return ["x-access-token": UserDefaultStorage.getToken()]
    }
}