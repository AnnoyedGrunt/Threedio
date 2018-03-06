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
    var onSolidify: SolidifyLogic

    static var blocks: [String : GamePiece] = [
        "Block": GamePiece(
            name: "block",
            settings: .hittable | .deletable,
            onSolidify: .block
        ),
        "Cylinder": GamePiece(
            name: "cylinder",
            orientation: .vertical,
            geometry: SCNCylinder(radius: 0.5, height: 1),
            settings: .hittable | .deletable,
            onSolidify: .cylinder
        ),
        "Sphere": GamePiece(
            name: "sphere",
            geometry: SCNSphere(radius: 0.5),
            settings: .hittable | .deletable
        ),
        "Tube": GamePiece(
            name: "tube",
            orientation: .vertical,
            geometry: SCNTube(innerRadius: 0.4, outerRadius: 0.5, height: 1),
            settings: .hittable | .deletable,
            onSolidify: .concave
        ),
        "Ball": GamePiece(
            name: "ball",
            orientation: .none,
            geometry: SCNSphere(radius: 0.4),
            settings: .dynamic | .deletable,
            onSolidify: .ball
        ),
        "Ramp": GamePiece(
            name: "ramp",
            orientation: .horizontal,
            node: unwrappedFromScene(named: "ramp.scn"),
            settings: .hittable | .deletable,
            onSolidify: .concave
        ),
        "Tile": GamePiece(
            name: "tile",
            orientation: .fullHorizontal,
            geometry: SCNBox(width: 0.7, height: 1.5, length: 0.2, chamferRadius: 0),
            settings: .dynamic | .deletable,
            onSolidify: .dynamic
        )
    ]

    static func unwrappedFromScene(named name: String) -> SCNNode {
        let scene = SCNScene(named: name)
        let node = scene!.rootNode.childNodes.first!
        node.geometry!.subdivisionLevel = 0
        return scene!.rootNode.childNodes.first!
    }
    
    static func withName(_ name: String) -> GamePiece? {
        return blocks[name] ?? blocks["Block"];
    }
    
    init(name: String = "piece", orientation: OrientationType = .none, settings: GamePieceSetting = .none, onSolidify solid: SolidifyLogic? = .standard) {
        self.name = name
        self.orientation = orientation
        self.node = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        self.settings = settings
        self.onSolidify = solid!
    }
    
    init(name: String = "piece", orientation: OrientationType = .none, geometry: SCNGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0), settings: GamePieceSetting = .none, onSolidify solid: SolidifyLogic? = .standard) {
        
        self.name = name
        self.orientation = orientation
        self.node = SCNNode(geometry: geometry)
        self.settings = settings
        self.onSolidify = solid!
    }
    
    init(name: String = "piece", orientation: OrientationType = .none, node: SCNNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)), settings: GamePieceSetting = .none, onSolidify solid: SolidifyLogic? = .standard) {
        self.name = name
        self.orientation = orientation
        self.node = node
        self.settings = settings
        self.onSolidify = solid!
    }
}

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
 
enum OrientationType {
    case none
    case vertical
    case horizontal
    case fullHorizontal
}
