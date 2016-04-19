//
//  GameCellTableViewCell.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class GameCellTableViewCell: UITableViewCell {

    // MARK: Game status icons
    
    // MARK :Game info

    @IBOutlet weak var roundNumberLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var gameStatusIcon: UIImageView!
    
    // MARK: Configuration
    
    
    func configureCell(game: Game){
        let usernames = [
            game.players[0]["username"] as! String,
            game.players[1]["username"] as! String
        ]
        let username = usernames[0] == UserDefaultStorage.getUsername() ? usernames[1] : usernames[0]
        let round_number = game.currentRoundNumber
        let status = game.status["status"]!["message"] as! String
        // TODO: Refactor images. Only need a placeholder and change image uri.
        // TODO: Make sure all possible states of a game is represented.
        var gameStatusIconString: String?
        print(status)
        switch status {
            case "Waiting for other player.":
                gameStatusIconString = "Grey badge";
                break;
            case "Game won.":
                let winner = game.status["status"]!["winner"] as! String
                if winner == UserDefaultStorage.getUsername() {
                    gameStatusIconString = "Win label"
                } else {
                    gameStatusIconString = "Lose label"
                }
                break;
            case "Game draw.":
                gameStatusIconString = "draw_badge";
            default:
                gameStatusIconString = "Grey badge"
        }
        gameStatusIcon = UIImageView(image: UIImage(named: gameStatusIconString!))
        self.usernameLabel.text = username
        self.roundNumberLabel.text = String(round_number)
    }
}
