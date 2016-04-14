//
//  FriendCellTableViewCell.swift
//  Patterns
//
//  Created by Mathias Iden on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class FriendCellTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    
    func configureCell(username: String, row: Int){
        usernameLabel.text = username
        
        inviteButton.addTarget(self, action: #selector(self.sendInvite), forControlEvents: .TouchUpInside)
    }
    
    func sendInvite() {
        Invitations.send(usernameLabel.text!) { message, error in
            if error == nil {
                print(message)
            } else {
                print(error)
            }
        }
    }
}

