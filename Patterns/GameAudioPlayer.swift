//
//  GameAudioPlayer.swift
//  FunQuence
//
//  Created by Kristian Våge on 21.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import AVFoundation

class GameAudioPlayer {
    private var sounds: [UIButton: AVAudioPlayer] = [:]
    
    /**
     Has to contain exactly four UIButtons
     */
    init(buttons: [UIButton]) {
        let players = [
            try! AVAudioPlayer(data: NSDataAsset(name: "jump_lowest")!.data, fileTypeHint: "wav"),
            try! AVAudioPlayer(data: NSDataAsset(name: "jump_low")!.data, fileTypeHint: "wav"),
            try! AVAudioPlayer(data: NSDataAsset(name: "jump_high")!.data, fileTypeHint: "wav"),
            try! AVAudioPlayer(data: NSDataAsset(name: "jump_highest")!.data, fileTypeHint: "wav")
        ]
        
        for (index, player) in players.enumerate() {
            sounds[buttons[index]] = player
        }
    }
    
    func play(pad: UIButton) {
        if UserDefaultStorage.getSound() {
            sounds[pad]!.play()
        }
    }
}
