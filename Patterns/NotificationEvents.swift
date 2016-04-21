//
//  NotificationEvents.swift
//  FunQuence
//
//  Created by Mathias Iden on 21.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import Foundation

class NotificationEvents {
    typealias closureThatReturnsVoid = () -> Void
    private var listeners: [() -> Void] = []
    
    static let sharedInstance = NotificationEvents()
    
    private init(){}
    
    private func notifyListeners(){
        listeners.forEach { listener in listener() }
    }
    
    func subscribe(function newListener: closureThatReturnsVoid) -> closureThatReturnsVoid {
        listeners.append(newListener)
        let insertedAtIndex = listeners.count - 1
        return { _ in _ = self.listeners.removeAtIndex(insertedAtIndex) }
    }
    
    func newNotificationReceived(){
        notifyListeners();
    }
}