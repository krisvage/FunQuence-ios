//
//  SequencePlaybackViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import AVFoundation

class SequencePlaybackViewController: UIViewController, UIGestureRecognizerDelegate {
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
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        if currentGame != nil {
            light_sequence = currentGame!.gameRounds.last!["light_sequence"] as? [String]
            
            
        } else {
            print("Game was not loaded")
        }
        setUpPads()
        setUpView()
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
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
    
    func flashPad(pad: UIButton, completion: () -> Void ){
        self.playBoopSound()
        self.turnLightOn(pad)
        setTimeout(0.8) {
            self.turnLightOff(pad)
        }
        setTimeout(1) {
            completion()
        }
      
    }
    
    func startSequence(completion: (() -> Void)?) {
        var current_index = 0;
        
        func playSequence(){
            let currentColorString = self.light_sequence![current_index];
            let currentPad = self.getPadByColorString(currentColorString)
            flashPad(currentPad!) { 
                current_index += 1;
                if(current_index == self.light_sequence?.count){
                    if completion != nil {
                        completion!()
                    }
                } else {
                    playSequence();
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
