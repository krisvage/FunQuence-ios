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
    
    static func getById(gameId: Int, completionHandler: (game: Game?, error: String?) -> ()) {
        let fullPath = "\(gameRoute.path)/\(gameId)"
        
        Alamofire.request(gameRoute.method, fullPath, headers: headers())
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let json = response.result.value {
                        if parsed_json["error"] == nil {
                            let game = parseGame(parsed_json["game"])
                            completionHandler(game: game, error: nil)
                        } else {
                            completionHandler(game: nil, error: parsed_json["error"])
                        }
                    }
                case .Failure(_):
                    completionHandler(game: nil, error: "failed request")
                }
        }
    }
    
    static func all(completionHandler: (games: [Game]?, error: String?) -> ()) {
        print("All games")
        
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

    static func parsePlayers(players: JSON) -> [[String: AnyObject]] {
        return players.arrayValue.map({
            [
                "username": $0["username"].stringValue,
                "owner": $0["owner"].intValue,
                "winner": $0["winner"].intValue
            ]
        })
    }
    
    static func parseGameRounds(rounds: JSON) -> [String: [String]] {
        return ["light_sequence": rounds["light_sequence"].arrayValue.map({
            $0.stringValue
        })]
    }
    
    static func parseStatus(status: JSON) -> [String: [String: AnyObject]] {
        return [
            "status": [
                "message": status["message"].stringValue,
                "game_is_over": status["game_is_over"].boolValue,
                "winner": status["winner"].stringValue,
                "loser": status["loser"].stringValue
            ]
        ]
    }
    
    static func parseGame(game: JSON) -> Game {
        return Game(gameId: game["game_id"].intValue, gameDate: game["game_date"].stringValue, isActive: game["is_active"].intValue, players: parsePlayers(game["players"]), gameRounds: parseGameRounds(game["game_rounds"]), currentRoundNumber: game["current_round_number"].intValue, status: parseStatus(game["status"]))
    }
    
    static func parseGames(games: JSON) -> [Game] {
        return games.arrayValue.map({
            parseGame($0)
        })
    }
}
