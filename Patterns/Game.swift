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
    var players: [String: AnyObject]
    var gameRound: [String: [String]]
    var currentRoundNumber: Int
    var status: [String: AnyObject]
}