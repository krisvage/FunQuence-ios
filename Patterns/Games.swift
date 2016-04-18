//
//  Games.swift
//  Patterns
//
//  Created by Kristian Våge on 15.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Games: API {
    static let gameRoute = Route(path: basePath + "/games", method: .GET)
    static let answerGameRoundRoute = Route(path: basePath + "/games", method: .POST)
    static let allGamesRoute = Route(path: basePath + "/users/me/games", method: .GET)
    
    /**
     GET /games/:game_id
     
     Get a game by id.
     
     => game, error
     */
    static func getById(gameId: Int, completionHandler: (game: Game?, error: String?) -> ()) {
        let fullPath = "\(gameRoute.path)/\(gameId)"
        let route = Route(path: fullPath, method: gameRoute.method)
        
        request(route) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    completionHandler(game: parseGame(json["game"]), error: nil)
                } else {
                    completionHandler(game: nil, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(game: nil, error: "API http request failed")
            }
        }
    }

    /**
     POST /games/:game_id/rounds/:round_number

     Submit an answer to the round of a game.
     
     => message, error
     */
    static func answerGameRound(answer: [String], gameId: Int, roundNumber: Int, completionHandler: (message: String?, error: String?) -> ()) {
        let fullPath = "\(answerGameRoundRoute.path)/\(gameId)/rounds/\(roundNumber)"
        let route = Route(path: fullPath, method: answerGameRoundRoute.method)
        let params = ["answer": answer]

        request(route, parameters: params) { response in
                switch response.result {
                case .Success(_):
                    let json = JSON(response.result.value!)
                    
                    if json["error"] == nil {
                        completionHandler(message: json["message"].stringValue, error: nil)
                    } else {
                        completionHandler(message: nil, error: json["error"].stringValue)
                    }
                case .Failure(_):
                    completionHandler(message: nil, error: "API http request failed")
                }
        }
    }
    
    /**
     GET /users/me/games
     
     Get a list of games that you are a part of.
     
     => games, error
     */
    static func all(completionHandler: (games: [Game]?, error: String?) -> ()) {
        request(allGamesRoute) { response in
            switch response.result {
            case .Success(_):
                let json = JSON(response.result.value!)
                
                if json["error"] == nil {
                    completionHandler(games: parseGames(json["games"]), error: nil)
                } else {
                    completionHandler(games: nil, error: json["error"].stringValue)
                }
            case .Failure(_):
                completionHandler(games: nil, error: "API http request failed")
            }
        }
    }

    private static func parsePlayers(players: JSON) -> [[String: AnyObject]] {
        return players.arrayValue.map({ player in
            [
                "username": player["username"].stringValue,
                "owner": player["owner"].intValue,
                "winner": player["winner"].intValue
            ]
        })
    }
    
    private static func parseGameRounds(rounds: JSON) -> [[String: AnyObject]] {
        return rounds.arrayValue.map({ round in
            [
                "light_sequence": round["light_sequence"].arrayValue.map({ color in
                color.stringValue
                }),
                "round_number": round["round_number"].intValue
            ]
        })
    }

    private static func parseStatus(status: JSON) -> [String: [String: AnyObject]] {
        return [
            "status": [
                "message": status["message"].stringValue,
                "game_is_over": status["game_is_over"].boolValue,
                "winner": status["winner"].stringValue,
                "loser": status["loser"].stringValue
            ]
        ]
    }
    
    private static func parseGame(game: JSON) -> Game {
        return Game(
            gameId: game["game_id"].intValue,
            gameDate: game["game_date"].stringValue,
            isActive: game["is_active"].intValue,
            players: parsePlayers(game["players"]),
            gameRounds: parseGameRounds(game["game_rounds"]),
            currentRoundNumber: game["current_round_number"].intValue,
            status: parseStatus(game["status"])
        )
    }

    private static func parseGames(games: JSON) -> [Game] {
        return games.arrayValue.map({ game in
            parseGame(game)
        })
    }
}
