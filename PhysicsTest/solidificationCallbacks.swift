//
//  SolidifyLogics.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 02/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension GamePiece {
    class SolidifyLogic {
        var logic: (_ node: SCNNode, _ scene: SCNScene) -> ()
        
        init( _ logic: @escaping (SCNNode, SCNScene) -> ()) {
            self.logic = logic
        }
        
        static func withGeometry<Geometry: SCNGeometry>(_ node: SCNNode, geometry: Geometry, type: SCNPhysicsBodyType){
            let options: [SCNPhysicsShape.Option: Any] = [SCNPhysicsShape.Option.scale: node.scale]
            let shape = SCNPhysicsShape(geometry: geometry, options: options)
            let body = SCNPhysicsBody(type: type, shape: shape)
            node.physicsBody = body
        }
        
        static let standard = SolidifyLogic() { node, scene in
            let options: [SCNPhysicsShape.Option: Any] = [SCNPhysicsShape.Option.scale: node.scale]
            let shape = SCNPhysicsShape(geometry: node.geometry!, options: options)
            let physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            node.physicsBody = physicsBody
        }
        
        static let block = SolidifyLogic() { node, scene in
            withGeometry(node, geometry: node.geometry as! SCNBox, type: .static)
        }
        
        static let cylinder = SolidifyLogic() { node, scene in
            withGeometry(node, geometry: node.geometry as! SCNCylinder, type: .static)
        }
        
        static let concave = SolidifyLogic() { node, scene in
            let options: [SCNPhysicsShape.Option: Any] = [
                SCNPhysicsShape.Option.scale: node.scale,
                SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron
            ]
            let shape = SCNPhysicsShape(geometry: node.geometry!, options: options)
            let physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            node.physicsBody = physicsBody
        }
        
        static let dynamic = SolidifyLogic() { node, scene in
            let options: [SCNPhysicsShape.Option: Any] = [SCNPhysicsShape.Option.scale: node.scale]
            let shape = SCNPhysicsShape(geometry: node.geometry!, options: options)
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
            node.physicsBody = physicsBody
        }
        
        static let ball = SolidifyLogic() { node, scene in
            SolidifyLogic.dynamic.logic(node, scene)
            node.physicsBody!.restitution = 0.6
            node.physicsBody!.rollingFriction = 0.0
            node.physicsBody!.friction = 0.1
        }
    }
}

