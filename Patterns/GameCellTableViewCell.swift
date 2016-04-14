//
//  GameCellTableViewCell.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class GameCellTableViewCell: UITableViewCell {
    // Game status icons
    @IBOutlet weak var loseIcon: UIImageView!
    @IBOutlet weak var winIcon: UIImageView!
    @IBOutlet weak var greyIcon: UIImageView!
    @IBOutlet weak var greenIcon: UIImageView!
    
    // Game info
    @IBOutlet weak var roundNumberLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func configureCell(game: AnyObject){
        let username = game["players"]!![0]["username"] as! String
        let round_number = game["current_round_number"] as! NSNumber
        let status = game["status"]!!["message"] as! String
        
        // TODO: Refactor images. Only need a placeholder and change image uri.
        // TODO: Make sure all possible states of a game is represented.
        switch status {
        case "Waiting for both players.":
            loseIcon.hidden = true;
            winIcon.hidden = true;
            greenIcon.hidden = false;
            greyIcon.hidden = true;
            break;
        case "Game won.":
            loseIcon.hidden = true;
            winIcon.hidden = false;
            greenIcon.hidden = true;
            greyIcon.hidden = true;
            break;

        default:
            loseIcon.hidden = true;
            winIcon.hidden = false;
            greenIcon.hidden = true;
            greyIcon.hidden = true;
        }
        self.usernameLabel.text = username
        self.roundNumberLabel.text = String(round_number)
    }
}
