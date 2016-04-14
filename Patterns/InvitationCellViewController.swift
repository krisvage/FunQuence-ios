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
    
    func configureCell(from_username: String){
        usernameLabel.text = from_username
    }
}

