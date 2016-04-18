//
//  SequencePlaynackViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import AVFoundation

class SequenceInputViewController: UIViewController, countdownStarter {
    let light_sequence = ["red", "blue", "green", "blue", "yellow", "green", "red"]
    var answer_sequence = [String]()
    var current_index = 0
    var sound: SystemSoundID = 0
    let circleLayer = CAShapeLayer()
    var secondInterval = NSTimer();
    var countdownTimer = NSTimer();
    

    @IBOutlet weak var greenPad: UIButton!
    @IBOutlet weak var redPad: UIButton!
    @IBOutlet weak var bluePad: UIButton!
    @IBOutlet weak var yellowPad: UIButton!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countdownAnchor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPadAlpha(1)
        countdownLabel.hidden = true;
    }
    @IBAction func padTapped(sender: AnyObject) {
        playBoopSound()
        // Start the counter if this was the first entry.
        let senderPad = sender as! UIButton;
        let colorString = self.getColorStringByPad(senderPad)
        answer_sequence.append(colorString!)
        if(answer_sequence.count == light_sequence.count){
            checkResult();
            cancelCountDown()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        performSegueWithIdentifier("goToReadyOverlay", sender: self)
        let soundURL = NSBundle.mainBundle().URLForResource("boop", withExtension: "wav")
        AudioServicesCreateSystemSoundID(soundURL!, &sound)
        print("Appeared")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToReadyOverlay"){
            let toView = segue.destinationViewController as! GetReadyOverlayViewController;
            toView.delegate = self;
        }
    }
    
    func checkResult(){
        if(answer_sequence == light_sequence){
            // Handle correct answer. Go to next view.
            print("Correct answer")
        } else {
            print("Incorrect answer")
            // Handle incorrect answer. Go to next view.
        }
        performSegueWithIdentifier("goToResults", sender: self)
    }
    
    func playBoopSound(){
        AudioServicesPlaySystemSound(sound);
    }
    
    func setPadAlpha(alpha: CGFloat){
        greenPad.alpha = alpha
        redPad.alpha = alpha
        bluePad.alpha = alpha
        yellowPad.alpha = alpha
    }
    
    func resetView(){
        setPadAlpha(1);
        current_index = 0;
    }
    
    func freezeButtons(){
        greenPad.userInteractionEnabled = false;
        redPad.userInteractionEnabled = false;
        bluePad.userInteractionEnabled = false;
        yellowPad.userInteractionEnabled = false;
        setPadAlpha(0.3)
    }
    
    func startCountDown(){
        var counter = 0;
        let countdownDuration = Double(self.light_sequence.count * 3);
        self.addCircleWithAnimation(countdownDuration)
        
        secondInterval = setInterval(1) {
            counter += 1
            self.countdownLabel.text = String(counter)
        }
        
        countdownTimer = setTimeout(countdownDuration) {
            self.checkResult();
            self.cancelCountDown()
        }
        countdownLabel.hidden = false;
    }
    
    func cancelCountDown(){
        secondInterval.invalidate()
        countdownTimer.invalidate()
        cancelCircleAnimation()
        freezeButtons();
        countdownLabel.text = "Done"
    }
    
    func addCircleWithAnimation(duration: Double){
        circleLayer.removeFromSuperlayer();
        let circlePath = UIBezierPath(arcCenter: countdownAnchor.center, radius: CGFloat(50), startAngle: CGFloat(-M_PI_2), endAngle:CGFloat(2*M_PI-M_PI_2), clockwise: true)
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.grayColor().CGColor
        circleLayer.lineWidth = 10.0
        view.layer.addSublayer(circleLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration;
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        circleLayer.addAnimation(animation, forKey: "ani")
    }
    
    func cancelCircleAnimation(){
        circleLayer.removeAnimationForKey("ani")
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
    
    func getColorStringByPad(pad: UIButton) -> String? {
        if(pad == greenPad){
            return "green";
        }
        if(pad == bluePad){
            return "blue";
        }
        if(pad == redPad){
            return "red";
        }
        if(pad == yellowPad){
            return "yellow";
        }
        return nil;
    }

    func turnLightOn(button: UIButton){
        button.alpha = 1;
    }
    
    func turnLightOff(button: UIButton){
        button.alpha = 0.3;
    }
    
}
