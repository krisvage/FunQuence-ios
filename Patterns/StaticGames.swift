//
//  StaticGames.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//
var staticGames: [[String: AnyObject]] = [
    [
        "game_id": 4887,
        "game_date": "1460487684108",
        "is_active": 1,
        "players": [
            [ "username": "hanne", "owner": 0, "winner": 0 ],
            [ "username": "mathias", "owner": 1, "winner": 0]
        ],
        "game_rounds": [
            ["light_sequence": ["yellow", "yellow", "blue", "red", "green"]]
        ],
        "round_number": 1,
        "game_round_id": 174,
        "answers": [
            ["username": "", "correct_answer": "" ]
        ],
        "current_round_number": 1,
        "status": [
            "message": "Waiting for both players.",
            "game_is_over": false,
            "winner": "",
            "loser": ""
        ]
    ],
    [
        "game_id": 4888,
        "game_date": "1460487684108",
        "is_active": 1,
        "players": [
            [ "username": "rebekka", "owner": 0, "winner": 0 ],
            [ "username": "mathias", "owner": 1, "winner": 0]
        ],
        "game_rounds": [
            ["light_sequence": ["yellow", "yellow", "blue", "red", "green"]]
        ],
        "round_number": 3,
        "game_round_id": 174,
        "answers": [
            ["username": "", "correct_answer": "" ],
            ["username": "", "correct_answer": "" ],
            ["username": "", "correct_answer": "" ],
            ["username": "", "correct_answer": "" ],
            ["username": "", "correct_answer": "" ],
            ["username": "", "correct_answer": "" ]
        ],
        "current_round_number": 3,
        "status": [
            "message": "Game won.",
            "game_is_over": true,
            "winner": "mathias",
            "loser": "rebekka"
        ]
    ]

]