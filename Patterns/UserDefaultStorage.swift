//
//  UserDefaultStorage.swift
//  Patterns
//
//  Created by Kristian Våge on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class UserDefaultStorage {
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static func saveToken(token: String) {
        defaults.setObject(token, forKey: "userToken")
    }
    
    static func getToken() -> String {
        return defaults.objectForKey("userToken") as? String ?? ""
    }
}
