//
//  FriendCellTableViewCell.swift
//  Patterns
//
//  Created by Mathias Iden on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

protocol FriendCellDelegate {
    func inviteTapped(username: String)
}

class FriendCellTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var sentInvitationButton: UIImageView!
    var delegate:FriendCellDelegate?
    var username:String?
    var has_pending_invitation: String?;
    
    func configureCell(username: String, row: Int, has_pending_invitation: String){
        self.username = username;
        usernameLabel.text = self.username
        self.has_pending_invitation = has_pending_invitation;
        inviteButton.addTarget(self, action: #selector(self.sendInvite), forControlEvents: .TouchUpInside)
        if(has_pending_invitation == "true"){
            sentInvitationButton.hidden = false;
            inviteButton.hidden = true;
        } else {
            inviteButton.hidden = false;
            sentInvitationButton.hidden = true;
        }
    }
    
    func sendInvite() {
       delegate?.inviteTapped(self.username!)
    }
}

