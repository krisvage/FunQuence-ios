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
    
    typealias sendHandler = (message: String?, error: String?) -> ()
    typealias allCountHandler = (invitationCount: Int, error: String?) -> ()
    typealias allInvitationsHandler = (invitations: [Invitation]?, error: String?) -> ()
    typealias replyInvitationHandler = (message: String?, error: String?) -> ()
    
    /**
     POST /users/:username/invitations

     Sends a game invitation to :username
     
     => message, error
     */
    static func send(username: String, completionHandler: sendHandler) {
        let fullPath = "\(sendInvitationRoute.path)/\(username)/invitations"
        let route = Route(path: fullPath, method: sendInvitationRoute.method)
        
        request(route) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    completionHandler(message: json["message"].stringValue, error: nil)
                } else {
                    completionHandler(message: nil, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(message: nil, error: "API http request failed")
            }
        }
    }
    
    /**
     Returns the count of .all()
     
     => invitationCount, erorr
     */
    static func allCount(completionHandler: allCountHandler) {
        all { invitations, error in
            if error == nil {
                completionHandler(invitationCount: invitations!.count, error: nil)
            } else {
                completionHandler(invitationCount: 0, error: error)
            }
        }
    }
    
    /**
     GET /users/me/invitations

     Gets all invitations sent to user.
     
     => invitations, error
     */
    static func all(completionHandler: allInvitationsHandler) {
        request(allInvitationsRoute) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    let invitations = parseInvitations(json["invitations"])
                    completionHandler(invitations: invitations, error: nil)
                } else {
                    completionHandler(invitations: nil, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(invitations: nil, error: "API http request failed")
            }
        }
    }
    
    private static func parseInvitations(invitations: JSON) -> [Invitation] {
        return invitations.arrayValue.map({ invitation in
            Invitation(
                accepted: invitation["accepted"].boolValue,
                fromUsername: invitation["from_username"].stringValue,
                toUsername: invitation["to_username"].stringValue,
                invitationSent: invitation["invitation_sent"].doubleValue,
                invitationId: invitation["invitation_id"].intValue
            )
        })
    }

    /**
     PUT /users/me/invitations/:invitation_id
     
     Accepts or declines a game invitation to :username

     => message, error
     */
    static func reply(id: Int, accepted: Bool, completionHandler: replyInvitationHandler) {
        let fullPath = "\(replyInvitationRoute.path)/\(id)"
        let route = Route(path: fullPath, method: replyInvitationRoute.method)
        let params = ["accepted": String(accepted)]
        
        request(route, parameters: params) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    completionHandler(message: json["message"].stringValue, error: nil)
                } else {
                    completionHandler(message: nil, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(message: nil, error: "API http request failed")
            }
        }
    }
}
