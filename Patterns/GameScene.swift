//
//  GameScene.swift
//  Patterns
//
//  Created by Kristian Våge on 01.03.2016.
//  Copyright (c) 2016 TDT4240G12. All rights reserved.
//

import SpriteKit
import Alamofire
import SwiftyJSON

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))

        self.addChild(myLabel)

        let api_location = "http://recallo.noip.me/api/users/me" /// "http://82.196.0.219.xip.io/api/users/me"
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImtyaXN2YWdlIiwiaWF0IjoxNDYwMzY4MjE2fQ.H5dmE_pBGSTzaE08Yk5_aZgR_lNia8jGZsL9zd2yjG0"

        let headers = ["x-access-token": token]

        Alamofire.request(.GET, api_location, headers: headers)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.response?.statusCode)
                print(response.data)     // server data

                print(response.result)   // result of response serialization

                if let json = response.result.value {
                    print("JSON: \(json)")
                    let parsed_json = JSON(json)
                    print("message \(parsed_json["message"].stringValue)")
                }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
