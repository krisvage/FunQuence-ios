//
//  InvitationCellViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class InvitationCellViewController: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var invitationId: Int = 0
    var delegate: InvitationViewController? = nil

    func configureCell(from_username: String, time_ago: String, invitationId: Int, delegate: InvitationViewController){
        usernameLabel.text = from_username
        timeAgoLabel.text = time_ago
        self.invitationId = invitationId
        self.delegate = delegate
        
        acceptButton.addTarget(self, action: #selector(self.acceptInvite), forControlEvents: .TouchUpInside)
        declineButton.addTarget(self, action: #selector(self.declineInvite), forControlEvents: .TouchUpInside)
    }
    
    func acceptInvite() {
        respondInvite(true)
    }
    
    func declineInvite() {
        respondInvite(false)
    }
    
    func respondInvite(accepted: Bool) {
        Invitations.reply(self.invitationId, accepted: accepted) { message, error in
            if error == nil {
                self.delegate!.reloadData()
            } else {
                print(error)
            }
        }
    }
}

