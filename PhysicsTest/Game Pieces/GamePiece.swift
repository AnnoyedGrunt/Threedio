//
//  Data.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 10/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class GamePiece {    
    var name: String
    var orientation: OrientationType
    var node: SCNNode
    var settings: GamePieceSetting
    var onSolidify: solidifyLogic

    static func unwrappedFromScene(named name: String) -> SCNNode {
        let scene = SCNScene(named: name)
        let node = scene!.rootNode.childNodes.first!
        node.geometry!.subdivisionLevel = 0
        return scene!.rootNode.childNodes.first!
    }
    
    static func withName(_ name: String) -> GamePiece? {
        return blocks[name] ?? blocks["Block"];
    }
    
    
    init(name: String, orientation: OrientationType, geometry: SCNGeometry, settings: GamePieceSetting, onSolidify solid: solidifyLogic) {
        self.name = name
        self.orientation = orientation
        self.node = SCNNode(geometry: geometry)
        self.settings = settings
        self.onSolidify = solid
    }
    
    init(name: String, orientation: OrientationType, node: SCNNode, settings: GamePieceSetting, onSolidify solid: solidifyLogic) {
        self.name = name
        self.orientation = orientation
        self.node = node
        self.settings = settings
        self.onSolidify = solid
    }
}
