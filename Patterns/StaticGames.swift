//
//  StaticGames.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//
var staticGames: [Game] = [
    Game(
        gameId: 4887,
        gameDate: "1460487684108",
        isActive: 1,
        players: [
            [ "username": "hanne", "owner": 0, "winner": 0 ],
            [ "username": "mathias", "owner": 1, "winner": 0]
        ],
        gameRounds: [
            "light_sequence": ["yellow", "yellow", "blue", "red", "green"]
        ],
        currentRoundNumber: 1,
        status: [
            "status": [
                "message": "Waiting for both players.",
                "game_is_over": false,
                "winner": "",
                "loser": ""
            ]
        ]
    ),
    Game(gameId: 4888,
        gameDate: "1460487684108",
        isActive: 1,
        players: [
            [ "username": "rebekka", "owner": 0, "winner": 0 ],
            [ "username": "mathias", "owner": 1, "winner": 0]
        ],
        gameRounds: [
            "light_sequence": ["yellow", "yellow", "blue", "red", "green"]
        ],
        currentRoundNumber: 3,
        status: [
            "status": [
                "message": "Game won.",
                "game_is_over": true,
                "winner": "mathias",
                "loser": "rebekka"
            ]
        ]
    )
]