//
//  SequencePlaynackViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import AVFoundation

class SequenceInputViewController: UIViewController, countdownStarter, UIGestureRecognizerDelegate {
    var currentGame: Game?
    var light_sequence: [String]?
    
    // Private state variables
    private var answer_sequence = [String]()
    private var current_index = 0
    private var audioPlayer: GameAudioPlayer?
    private let circleLayer = CAShapeLayer()
    private var secondInterval = NSTimer();
    private var countdownTimer = NSTimer();
    private var roundResult: String?
    private var pads: [UIButton] = []
    
    // Outlets and Actions
    @IBOutlet weak var greenPad: UIButton!
    @IBOutlet weak var redPad: UIButton!
    @IBOutlet weak var bluePad: UIButton!
    @IBOutlet weak var yellowPad: UIButton!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var countdownAnchor: UIView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        if currentGame != nil {
            light_sequence = currentGame!.gameRounds.last!["light_sequence"] as? [String]
            
            
        } else {
            NSLog("error: %@", "Game was not loaded")
            return
        }
        setPadAlpha(1)
        setUpView()
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @IBAction func padTapped(sender: AnyObject) {
        // Start the counter if this was the first entry.
        let senderPad = sender as! UIButton;
        
        // This make sure that the UI doesn't hang while audioPlayer buffers the .wav files.
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.audioPlayer!.play(senderPad)
        }
        
        let colorString = self.getColorStringByPad(senderPad)
        answer_sequence.append(colorString!)
        if(answer_sequence.count == light_sequence!.count){
            checkResult();
            cancelCountDown()
        }
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
        
        if UserDefaultStorage.getBW() {
            for pad in pads {
                pad.setBackgroundImage(UIImage(named: "black_pad_button"), forState: .Normal)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        performSegueWithIdentifier("goToReadyOverlay", sender: self)
        
        audioPlayer = GameAudioPlayer(buttons: [greenPad, redPad, bluePad, yellowPad])
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToReadyOverlay"){
            let destinationVC = segue.destinationViewController as! GetReadyOverlayViewController;
            destinationVC.delegate = self;
        }
        if(segue.identifier == "goToResults"){
            let destinationVC = segue.destinationViewController as! SequenceResultViewController;
            destinationVC.currentGame = self.currentGame!
            destinationVC.roundResult = self.roundResult!
        }
    }
    
    //
    func checkResult(){
        freezeButtons()
        if(answer_sequence.count == 0){
            answer_sequence.append("wronganswer")
        }
        Games.answerGameRound(answer_sequence, gameId: currentGame!.gameId, roundNumber: currentGame!.currentRoundNumber) { (message, error) in
            if message != nil {
                self.roundResult = message!
            } else {
                self.roundResult = error!
            }
            self.performSegueWithIdentifier("goToResults", sender: self)
        }
        
    }

    func setPadAlpha(alpha: CGFloat){
        pads = [greenPad, redPad, bluePad, yellowPad]
        
        for pad in pads {
            pad.alpha = alpha
        }
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
        let countdownDuration = Double(self.light_sequence!.count * 3);
        self.addCircleWithAnimation(countdownDuration)
        
        countdownTimer = setTimeout(countdownDuration) {
            self.checkResult();
            self.cancelCountDown()
        }
    }
    
    func cancelCountDown(){
        secondInterval.invalidate()
        countdownTimer.invalidate()
        cancelCircleAnimation()
        freezeButtons();
    }
    
    func addCircleWithAnimation(duration: Double){
        circleLayer.removeFromSuperlayer();
        let circlePath = UIBezierPath(arcCenter: countdownAnchor.center, radius: CGFloat(40), startAngle: CGFloat(-M_PI_2), endAngle:CGFloat(2*M_PI-M_PI_2), clockwise: true)
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
