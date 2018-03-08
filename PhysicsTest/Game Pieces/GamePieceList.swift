//
//  List of GamePieces.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 06/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit

extension GamePiece {
    
    /**
     A complete list of all GamePieces usable within the game.
     */
    static var blocks: [String : GamePiece] = [
        "Block": GamePiece(
            name: "block",
            orientation: .none,
            geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0),
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
            orientation: .none,
            geometry: SCNSphere(radius: 0.5),
            settings: .hittable | .deletable,
            onSolidify: .standard
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
}
