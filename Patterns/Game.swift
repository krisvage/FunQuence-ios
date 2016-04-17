//
//  Game.swift
//  Patterns
//
//  Created by Kristian Våge on 15.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

struct Game {
    var gameId: Int
    var gameDate: String
    var isActive: Int
    var players: [[String: AnyObject]]
    var gameRounds: [String: [String]]
    var currentRoundNumber: Int
    var status: [String: [String: AnyObject]]
    
    init(gameId: Int, gameDate: String, isActive: Int, players: [[String: AnyObject]], gameRounds: [String: [String]], currentRoundNumber: Int, status: [String: [String: AnyObject]]) {
        self.gameId = gameId
        self.gameDate = gameDate
        self.isActive = isActive
        self.players = players
        self.gameRounds = gameRounds
        self.currentRoundNumber = currentRoundNumber
        self.status = status
    }
}