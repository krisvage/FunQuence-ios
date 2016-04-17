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
    static let allGamesRoute = Route(path: basePath + "/users/me/games", method: .GET)
    static let answerGameRoundRoute = Route(path: basePath + "/games", method: .POST)
    
    static func getById(gameId: Int, completionHandler: (game: Game?, error: String?) -> ()) {
        let fullPath = "\(gameRoute.path)/\(gameId)"
        
        Alamofire.request(gameRoute.method, fullPath, headers: headers())
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            let game = parseGame(parsed_json["game"])
                            completionHandler(game: game, error: nil)
                        } else {
                            completionHandler(game: nil, error: parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(game: nil, error: "failed request")
                }
        }
    }
    
    static func answerGameRound(answer: [String], gameId: Int, roundNumber: Int, completionHandler: (message: String?, error: String?) -> ()) {
        let fullPath = "\(answerGameRoundRoute.path)/\(gameId)/rounds/\(roundNumber)"
        let params = ["answer": answer]

        Alamofire.request(answerGameRoundRoute.method, fullPath, headers: headers(), parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            let message = parsed_json["message"].stringValue
                            completionHandler(message: message, error: nil)
                        } else {
                            completionHandler(message: nil, error: parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(message: nil, error: "failed request")
                }
        }
    }
    
    static func all(completionHandler: (games: [Game]?, error: String?) -> ()) {
        Alamofire.request(allGamesRoute.method, allGamesRoute.path, headers: headers())
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        let parsed_json = JSON(json)
                        if parsed_json["error"] == nil {
                            let games = parseGames(parsed_json["games"])
                            completionHandler(games: games, error: nil)
                        } else {
                            completionHandler(games: nil, error: parsed_json["error"].stringValue)
                        }
                    }
                case .Failure(_):
                    completionHandler(games: nil, error: "failed request")
                }
        }
    }

    private static func parsePlayers(players: JSON) -> [[String: AnyObject]] {
        return players.arrayValue.map({
            [
                "username": $0["username"].stringValue,
                "owner": $0["owner"].intValue,
                "winner": $0["winner"].intValue
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
        return Game(gameId: game["game_id"].intValue, gameDate: game["game_date"].stringValue, isActive: game["is_active"].intValue, players: parsePlayers(game["players"]), gameRounds: parseGameRounds(game["game_rounds"]), currentRoundNumber: game["current_round_number"].intValue, status: parseStatus(game["status"]))
    }
    
    private static func parseGames(games: JSON) -> [Game] {
        return games.arrayValue.map({
            parseGame($0)
        })
    }
}
