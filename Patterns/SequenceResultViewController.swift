//
//  SequenceResultViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class SequenceResultViewController: UIViewController {
    var currentGame: Game?
    var roundResult: String?
    @IBOutlet weak var answerStatusIcon: UIImageView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var roundResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(roundResult! != "Correct answer."){
            answerStatusIcon.image = UIImage(named: "Wrong_icon")
        }
        
        Games.getById(currentGame!.gameId) { (game, error) in
            let usernames = [
                self.currentGame!.players[0]["username"] as! String,
                self.currentGame!.players[1]["username"] as! String
            ]
            let username = usernames[0] == UserDefaultStorage.getUsername() ? usernames[1] : usernames[0]
            let status = game!.status["status"]!["message"] as! String
            print(status)
            self.roundResultLabel.text = self.getResultText(status, opponentUsername: username)
        }
    }
    
    func getResultText(gameStatus: String, opponentUsername: String) -> String {
        if(gameStatus == "Waiting for other player.") {
            if(roundResult == "Correct answer."){
                return "You answer is correct!. Wait for \(opponentUsername) to answer and move on to the next round."
            } else {
                return "You answer is wrong!. If \(opponentUsername) answers correctly he will win the game!"
            }
        }
        if(gameStatus == "Game won."){
            return "Someone has won the game!"
        }
        if(gameStatus == "Game draw."){
            return "You and \(opponentUsername) both got the answer wrong! Game is drawn."
        }
        return "";
    }
    
    @IBAction func toMenuTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToMain", sender: self)
    }
    
    func setUpView(){
        roundLabel.text = "Round " + String(currentGame!.currentRoundNumber)
        currentUserLabel.text = UserDefaultStorage.getUsername()
        let usernames = [
            currentGame!.players[0]["username"] as! String,
            currentGame!.players[1]["username"] as! String
        ]
        let username = usernames[0] == UserDefaultStorage.getUsername() ? usernames[1] : usernames[0]
        opponentLabel.text = username;
    }
}
