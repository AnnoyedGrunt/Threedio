//
//  GameToolListener.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 07/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation

protocol GameToolListener: AnyObject {
    func onTap(sender: GameTool, param: Any?)
    func onEnter(sender: GameTool, param: Any?)
    func onExit(sender: GameTool, param: Any?)
    func onUpdate(sender: GameTool, param: Any?)
}

class GameToolListenerList: NSObject {
    private var listeners: [GameToolListener] = []
    
    func add(_ listener: GameToolListener) {
        if !contains(listener) {
            listeners.append(listener)
        }
    }
    
    func contains(_ listener: GameToolListener) -> Bool {
        return listeners.contains { element in
            return element === listener
        }
    }
    
    func remove(_ listener: GameToolListener) {
        if let index = listeners.index(where: {element in return element === listener}) {
            listeners.remove(at: index)
        }
        
    }
    
    func invokeOnTap(sender: GameTool, param: Any?) {
        for element in listeners {
            element.onTap(sender: sender, param: param)
        }
    }
    
    func invokeOnEnter(sender: GameTool, param: Any?) {
        for element in listeners {
            element.onEnter(sender: sender, param: param)
        }
    }
    
    func invokeOnExit(sender: GameTool, param: Any?) {
        for element in listeners {
            element.onExit(sender: sender, param: param)
        }
    }
    
    func invokeOnUpdate(sender: GameTool, param: Any?) {
        for element in listeners {
            element.onUpdate(sender: sender, param: param)
        }
    }
}
