//
//  SequencePlaybackViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import AVFoundation

class SequencePlaybackViewController: UIViewController {
    var currentGame: Game?
    var light_sequence: [String]?
    
    // Private state variables
    private var sound: SystemSoundID = 0
    private var soundUrl: NSURL!

    @IBOutlet weak var greenPad: UIButton!
    @IBOutlet weak var redPad: UIButton!
    @IBOutlet weak var bluePad: UIButton!
    @IBOutlet weak var yellowPad: UIButton!
    @IBOutlet weak var readyText: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    
    @IBAction func readyButtonTapped(sender: AnyObject) {
        setTimeout(2) {
            self.startSequence({ 
                setTimeout(1, block: {
                    self.performSegueWithIdentifier("goToSequenceInput", sender: self)
                })
            })
        }
        self.readyButton.hidden = true;
        self.readyText.hidden = true;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToSequenceInput"){
            let destinationVC = segue.destinationViewController as! SequenceInputViewController
            destinationVC.currentGame = self.currentGame;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentGame != nil {
            light_sequence = currentGame!.gameRounds.last!["light_sequence"] as? [String]
            
            
        } else {
            print("Game was not loaded")
        }
        setUpPads()
        setUpView()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.soundUrl = NSBundle.mainBundle().URLForResource("boop", withExtension: "wav")
        AudioServicesCreateSystemSoundID(self.soundUrl, &sound)
    }

    func playBoopSound(){
        AudioServicesPlaySystemSound(sound);
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
    
    func setUpPads(){
        greenPad.alpha = 0.3
        redPad.alpha = 0.3
        bluePad.alpha = 0.3
        yellowPad.alpha = 0.3
    }
    
    func resetView(){
        setUpPads();
        readyText.hidden = false;
        readyButton.hidden = false;
    }
    
    func getPadByColorString(colorString: String) -> UIButton?{
        if(colorString == "red"){
            return redPad;
        }
        if(colorString == "blue"){
            return bluePad
        }
        if(colorString == "green"){
            return greenPad
        }
        if(colorString == "yellow"){
            return yellowPad;
        }
        return nil;
    }
    
    func startSequence(completion: (() -> Void)?) {
        var current_index = 0;
        
        func playSequence(){
            let currentColorString = self.light_sequence![current_index];
            let currentButton = self.getPadByColorString(currentColorString)
            
            self.playBoopSound()
            self.turnLightOn(currentButton!)
            setTimeout(1) {
                self.turnLightOff(currentButton!)
                if(current_index != self.light_sequence!.count-1){
                    current_index += 1;
                    playSequence()
                } else {
                    if completion != nil {
                        completion!()
                    }
                }
            }
        }
        playSequence();
    }
    
    func turnLightOn(button: UIButton){
        button.alpha = 1;
    }
    
    func turnLightOff(button: UIButton){
        button.alpha = 0.3;
    }

}
