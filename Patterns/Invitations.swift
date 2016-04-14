//
//  Invitations.swift
//  Patterns
//
//  Created by Kristian Våge on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Invitations: API {
    static let sendInvitationRoute = Route(path: basePath + "/users", method: .POST)
    static let allInvitationsRoute = Route(path: basePath + "/users/me/invitations", method: .GET)
    static let replyInvitationRoute = Route(path: basePath + "/users/me/invitations", method: .PUT)
    
    static func send(username: String, completionHandler: (message: String?, error: String?) -> ()) {
        let fullPath = "\(sendInvitationRoute.path)/\(username)/invitations"
        
        Alamofire.request(sendInvitationRoute.method, fullPath, headers: headers())
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        
                        if parsed_json["error"] == nil {
                            completionHandler(message: parsed_json["message"].stringValue, error: nil)
                        } else {
                            completionHandler(message: nil, error: parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(message: nil, error: "failed request")
                }
        }
    }
    
    static func all(completionHandler: (invitations: [Invitation]?, error: String?) -> ()) {
        Alamofire.request(allInvitationsRoute.method, allInvitationsRoute.path, headers: headers())
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            let invitations = parsed_json["invitations"].arrayValue.map({Invitation(accepted: $0["accepted"].boolValue, fromUsername: $0["from_username"].stringValue, toUsername: $0["to_username"].stringValue, invitationSent: $0["invitation_sent"].doubleValue, invitationId: $0["invitation_id"].intValue)})
                            print("yo \(invitations.first?.invitationSent)")
                            completionHandler(invitations: invitations, error: nil)
                        } else {
                            completionHandler(invitations: nil, error: parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(invitations: nil, error: "request failed")
                }
        }
    }
    
    static func reply(id: Int, accepted: Bool, completionHandler: (message: String?, error: String?) -> ()) {
        let fullPath = "\(replyInvitationRoute.path)/\(id)"
        let params = ["accepted": String(accepted)]

        Alamofire.request(replyInvitationRoute.method, fullPath, headers: headers(), parameters: params)
            .responseJSON { response in
                print(response.request)
                print(response.request?.HTTPBody)
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            completionHandler(message: parsed_json["message"].stringValue, error: nil)
                        } else {
                            completionHandler(message: nil, error: parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(message: nil, error: "request failed")
                }
        }
    }
}
