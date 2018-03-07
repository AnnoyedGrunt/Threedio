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

/**
 Contains information about one of the shapes or objects that make up the game, as well as a global list of all GamePieces and static methods for handling of said list.
 
 - Author: Raffaele Tontaro
 */
class GamePiece {    
    var name: String
    var orientation: OrientationType
    var node: SCNNode
    var settings: GamePieceSetting
    var onSolidify: SolidifyLogic

    /**
     Loads a scene and returns the first node in it.
     - Parameter name: the name of the scene to load, along with its extension.
     */
    static func unwrappedFromScene(named name: String) -> SCNNode {
        let scene = SCNScene(named: name)
        let node = scene!.rootNode.childNodes.first!
        node.geometry!.subdivisionLevel = 0
        return scene!.rootNode.childNodes.first!
    }
    
    /**
     Allows for the fetching of a specific GamePiece by name.
     - Parameter name: name of the GamePiece to obtain.
     */
    static func withName(_ name: String) -> GamePiece? {
        return blocks[name] ?? blocks["Block"];
    }
    
    init(name: String, orientation: OrientationType, geometry: SCNGeometry, settings: GamePieceSetting, onSolidify solid: SolidifyLogic) {
        self.name = name
        self.orientation = orientation
        self.node = SCNNode(geometry: geometry)
        self.settings = settings
        self.onSolidify = solid
    }
    
    init(name: String, orientation: OrientationType, node: SCNNode, settings: GamePieceSetting, onSolidify solid: SolidifyLogic) {
        self.name = name
        self.orientation = orientation
        self.node = node
        self.settings = settings
        self.onSolidify = solid
    }
}
