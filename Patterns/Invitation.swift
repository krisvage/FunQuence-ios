//
//  Invitation.swift
//  Patterns
//
//  Created by Kristian Våge on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

struct Invitation {
    var accepted: Bool
    var fromUsername: String
    var toUsername: String
    var invitationSent: Double
    var invitationId: Int

    init(accepted: Bool, fromUsername: String, toUsername: String, invitationSent: Double, invitationId: Int) {
        self.accepted = accepted
        self.fromUsername = fromUsername
        self.toUsername = toUsername
        self.invitationSent = invitationSent
        self.invitationId = invitationId
    }
}