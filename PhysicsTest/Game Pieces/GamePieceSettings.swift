//
//  GamePieceSettings.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 06/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation

struct GamePieceSetting: OptionSet {
    let rawValue: Int
    
    static let none = GamePieceSetting(rawValue: 1<<0)
    static let hittable = GamePieceSetting(rawValue: 1<<1)
    static let deletable = GamePieceSetting(rawValue: 1<<2)
    static let dynamic = GamePieceSetting(rawValue: 1<<3)
    
    static func |(left: GamePieceSetting, right: GamePieceSetting) -> GamePieceSetting {
        return GamePieceSetting(rawValue: left.rawValue | right.rawValue)
    }
    
    static func raw(_ setting: GamePieceSetting) -> Int {
        return setting.rawValue
    }
    
    func contains(_ setting: GamePieceSetting) -> Bool {
        return ((self.rawValue & setting.rawValue) != 0)
    }
}
