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
    let light_sequence = ["red", "blue", "green", "blue", "yellow", "green", "red"]
    var sound: SystemSoundID = 0
    var soundUrl: NSURL!

    @IBOutlet weak var greenPad: UIButton!
    @IBOutlet weak var redPad: UIButton!
    @IBOutlet weak var bluePad: UIButton!
    @IBOutlet weak var yellowPad: UIButton!
    @IBOutlet weak var readyText: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPads();
    }
    
    override func viewDidAppear(animated: Bool) {
        self.soundUrl = NSBundle.mainBundle().URLForResource("boop", withExtension: "wav")
        AudioServicesCreateSystemSoundID(self.soundUrl, &sound)
    }

    func playBoopSound(){
        AudioServicesPlaySystemSound(sound);
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
            let currentColorString = self.light_sequence[current_index];
            let currentButton = self.getPadByColorString(currentColorString)
            
            self.playBoopSound()
            self.turnLightOn(currentButton!)
            setTimeout(1) {
                self.turnLightOff(currentButton!)
                if(current_index != self.light_sequence.count-1){
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
