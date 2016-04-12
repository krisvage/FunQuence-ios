//
//  Route.swift
//  Patterns
//
//  Created by Kristian Våge on 11.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import Alamofire

class Route {
    var path: String
    var method: Method
    
    init(path: String, method: Method) {
        self.path = path
        self.method = method
    }
}