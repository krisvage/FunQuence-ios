//
//  SequencePlaynackViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import AVFoundation

class SequenceInputViewController: UIViewController {
    let light_sequence = ["red", "blue", "green", "blue", "yellow", "green", "red"]
    var answer_sequence = [String]()
    var current_index = 0
    var sound: SystemSoundID = 0
    
    @IBOutlet weak var greenPad: UIButton!
    @IBOutlet weak var redPad: UIButton!
    @IBOutlet weak var bluePad: UIButton!
    @IBOutlet weak var yellowPad: UIButton!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countdownAnchor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPads();        addCircle()
    }
    @IBAction func padTapped(sender: AnyObject) {
        playBoopSound()
        let senderPad = sender as! UIButton;
        let colorString = self.getColorStringByPad(senderPad)
        answer_sequence.append(colorString!)
        if(answer_sequence.count == light_sequence.count){
            // GO TO RESULTS
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let soundURL = NSBundle.mainBundle().URLForResource("boop", withExtension: "wav") {
            AudioServicesCreateSystemSoundID(soundURL, &sound)
        }
    }
    
    func playBoopSound(){
        AudioServicesPlaySystemSound(sound);
    }
    
    func setUpPads(){
        greenPad.alpha = 1
        redPad.alpha = 1
        bluePad.alpha = 1
        yellowPad.alpha = 1
    }
    
    func resetView(){
        setUpPads();
        current_index = 0;
    }
    
    func addCircle(){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 160,y: 240), radius: CGFloat(100), startAngle: CGFloat(-M_PI_2), endAngle:CGFloat(2*M_PI-M_PI_2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.lineWidth = 1.0
        countdownAnchor.layer.addSublayer(shapeLayer)
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
