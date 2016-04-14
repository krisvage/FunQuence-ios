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
    
    func configureCell(username: String){
        usernameLabel.text = username
    }
}

