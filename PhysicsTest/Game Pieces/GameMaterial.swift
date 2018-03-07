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
    //MARK: - Class functionality
    
    static var materials: [String : GameMaterial] = [:]
    static var defaultMaterial = GameMaterial(color: UIColor.white)
    
    init(color: UIColor) {
        super.init()
        self.diffuse.contents = color
    }
    
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
    
    //MARK: - Necessary for inheritance
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
