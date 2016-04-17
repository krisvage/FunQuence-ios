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
    
    func configureCell(game: Game){
        let usernames = [
            game.players[0]["username"] as! String,
            game.players[1]["username"] as! String
        ]

        let username = usernames[0] == UserDefaultStorage.getUsername() ? usernames[1] : usernames[0]
        let round_number = game.currentRoundNumber // game["current_round_number"] as! NSNumber
        let status = game.status["status"]!["message"] as! String // game["status"]!!["message"] as! String
        
        // TODO: Refactor images. Only need a placeholder and change image uri.
        // TODO: Make sure all possible states of a game is represented.
        switch status {
        case "Waiting for both players.":
            loseIcon.hidden = true;
            winIcon.hidden = true;
            greenIcon.hidden = false;
            greyIcon.hidden = true;
            break;
        case "Waiting for other player.":
            loseIcon.hidden = true;
            winIcon.hidden = true;
            greenIcon.hidden = true;
            greyIcon.hidden = false;
        case "Game won.":
            let winner = game.status["status"]!["winner"] as! String

            if winner == UserDefaultStorage.getUsername() {
                loseIcon.hidden = true;
                winIcon.hidden = false;
                greenIcon.hidden = true;
                greyIcon.hidden = true;
            } else {
                loseIcon.hidden = false;
                winIcon.hidden = true;
                greenIcon.hidden = true;
                greyIcon.hidden = true;
            }
            break;
        default:
            loseIcon.hidden = true;
            winIcon.hidden = true;
            greenIcon.hidden = true;
            greyIcon.hidden = true;
        }
        self.usernameLabel.text = username
        self.roundNumberLabel.text = String(round_number)
    }
}
