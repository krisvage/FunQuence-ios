//
//  InvitationCellViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class InvitationCellViewController: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var invitationId: Int = 0
    var delegate: InvitationViewController? = nil
    
    // MARK: Configuration

    func configureCell(invitation: Invitation, delegate: InvitationViewController){
        let timeStamp = invitation.invitationSent
        let timeObject = NSDate(timeIntervalSince1970: floor(timeStamp/1000))
        
        usernameLabel.text = invitation.fromUsername
        timeAgoLabel.text = timeAgoSince(timeObject)
        self.invitationId = invitation.invitationId
        self.delegate = delegate
        
        acceptButton.addTarget(self, action: #selector(self.acceptInvite), forControlEvents: .TouchUpInside)
        declineButton.addTarget(self, action: #selector(self.declineInvite), forControlEvents: .TouchUpInside)
    }
    
    // MARK: Navigation
    
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
                NSLog("error: %@", error!)
            }
        }
    }
}

