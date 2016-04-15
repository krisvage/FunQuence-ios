//
//  Games.swift
//  Patterns
//
//  Created by Kristian Våge on 15.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Games: API {
    static let allGamesRoute = Route(path: "/users/me/games", method: .GET)
    
    func all(completionHandler: (games: [Game]?, error: String?) -> ()) {
        
    }
}
