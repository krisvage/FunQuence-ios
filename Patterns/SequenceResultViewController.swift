//
//  SequenceResultViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class SequenceResultViewController: UIViewController, UIGestureRecognizerDelegate {
    var currentGame: Game?
    var roundResult: String?
    @IBOutlet weak var answerStatusIcon: UIImageView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var roundResultLabel: UILabel!
    @IBOutlet weak var answerResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        setUpView()
        Games.getById(currentGame!.gameId) { (game, error) in
            let usernames = [
                self.currentGame!.players[0]["username"] as! String,
                self.currentGame!.players[1]["username"] as! String
            ]
            let username = usernames[0] == UserDefaultStorage.getUsername() ? usernames[1] : usernames[0]
            let status = game!.status["status"]!["message"] as! String
            let winner = game!.status["status"]!["winner"] as! String
            self.roundResultLabel.text = self.getResultText(status, opponentUsername: username, winner: winner)
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func getResultText(gameStatus: String, opponentUsername: String, winner: String?) -> String {
        if(gameStatus == "Waiting for both players."){
            return "You have both answered the round correctly and move on to the next round"
        }
        
        if(gameStatus == "Waiting for \(opponentUsername).") {
            if(roundResult == "Correct answer."){
                return "Your answer is correct! Wait for \(opponentUsername) to answer and move on to the next round."
            } else {
                return "Your answer is wrong! If \(opponentUsername) answers correctly he will win the game! If not the game will be drawn."
            }
        }
        if(gameStatus == "Game won."){
            if(winner == UserDefaultStorage.getUsername()){
                return "\(opponentUsername) has answered incorrectly and you have won the game!";
            } else {
                return "\(opponentUsername) answered this round correctly and has won the game!"
            }
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
        answerResultLabel.text = (roundResult == "Correct answer." ? "Correct" : "Wrong")
        roundLabel.text = "Round " + String(currentGame!.currentRoundNumber)
        currentUserLabel.text = UserDefaultStorage.getUsername()
        let usernames = [
            currentGame!.players[0]["username"] as! String,
            currentGame!.players[1]["username"] as! String
        ]
        let username = usernames[0] == UserDefaultStorage.getUsername() ? usernames[1] : usernames[0]
        opponentLabel.text = username;
        if(roundResult! != "Correct answer."){
            answerStatusIcon.image = UIImage(named: "Wrong_icon")
        }
    }
}
