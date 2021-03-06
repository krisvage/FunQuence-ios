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

    static func saveUsername(username: String) {
        defaults.setObject(username, forKey: "username")
    }
    
    static func getUsername() -> String {
        return defaults.objectForKey("username") as? String ?? ""
    }
    
    static func saveEmail(email: String) {
        defaults.setObject(email, forKey: "userEmail")
    }
    
    static func getEmail() -> String {
        return defaults.objectForKey("userEmail") as? String ?? ""
    }
    
    static func saveSound(state: Bool) {
        defaults.setObject(state, forKey: "soundSetting")
    }
    
    static func getSound() -> Bool {
        return defaults.objectForKey("soundSetting") as? Bool ?? true
    }
    
    static func saveBW(state: Bool) {
        defaults.setObject(state, forKey: "bwSetting")
    }
    
    static func getBW() -> Bool {
        return defaults.objectForKey("bwSetting") as? Bool ?? false
    }
    
    // Device token is specific to each device and is needed for Push Notifications
    // Not to be confused with token (JWT)
    static func getDeviceToken() -> String? {
        return defaults.objectForKey("deviceToken") as? String
    }
    // Device token is specific to each device and is needed for Push Notifications
    // Not to be confused with token (JWT)
    static func setDeviceToken(deviceToken: String) {
        defaults.setObject(deviceToken, forKey: "deviceToken")
    }
    
    static func setFinishedTutorial(didFinishTutorial: Bool){
        defaults.setObject(didFinishTutorial, forKey: "didFinishTutorial")
    }
    
    static func getFinishedTutorial() -> Bool {
        return defaults.objectForKey("didFinishTutorial") as? Bool ?? false
    }
    
    static func resetSettings() {
        UserDefaultStorage.saveToken("")
        UserDefaultStorage.saveUsername("")
        UserDefaultStorage.saveEmail("")
        UserDefaultStorage.setDeviceToken("")
        UserDefaultStorage.saveBW(false)
        UserDefaultStorage.saveSound(true)
    }
}
