//
//  API.swift
//  Patterns
//
//  Created by Kristian Våge on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import Alamofire

class API {
    static let basePath = "http://recallo.noip.me/api"
    typealias requestJSONHandler = (response: Response<AnyObject, NSError>) -> (Void)
    
    static func headers() -> [String: String] {
        return ["x-access-token": UserDefaultStorage.getToken()]
    }
    
    static func request(route: Route, parameters: [String: AnyObject]? = nil, completionHandler: requestJSONHandler) {
        Alamofire.request(route.method, route.path, headers: headers(), parameters: parameters).responseJSON { response in
            completionHandler(response: response)
        }
    }
}
