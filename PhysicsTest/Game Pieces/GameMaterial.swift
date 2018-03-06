//
//  GameMaterial.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 06/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit

class GameMaterial: SCNMaterial {

    override init() {
        super.init()
    }
    
    init(color: UIColor) {
        super.init()
        self.diffuse.contents = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static var materials: [String : GameMaterial] = [:]
    static var defaultMaterial = GameMaterial(color: UIColor.white)
    
    static func withName(_ name: String) -> GameMaterial {
        return materials[name] ?? defaultMaterial
    }
    
    static func newMaterial(color: UIColor, withName name: String) -> GameMaterial {
        let material = GameMaterial(color: color)
        materials[name] = material
        return material
    }
    
    static func clearMaterials() {
        materials = [:]
    }
}
