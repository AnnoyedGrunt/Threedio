//
//  solidificationCallbacks.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 02/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension GamePiece {
    
    static func standardSolidification(_ node: SCNNode, _ scene: SCNScene) {
        let options: [SCNPhysicsShape.Option: Any] = [SCNPhysicsShape.Option.scale: node.scale]
        let shape = SCNPhysicsShape(geometry: node.geometry!, options: options)
        let physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        node.physicsBody = physicsBody
    }
    
    static func baseSolidification<Geometry: SCNGeometry>(_ node: SCNNode, geometry: Geometry, type: SCNPhysicsBodyType){
        let options: [SCNPhysicsShape.Option: Any] = [SCNPhysicsShape.Option.scale: node.scale]
        let shape = SCNPhysicsShape(geometry: geometry, options: options)
        let body = SCNPhysicsBody(type: type, shape: shape)
        node.physicsBody = body
    }
    static func blockSolidification(_ node: SCNNode, _ scene: SCNScene) {
        baseSolidification(node, geometry: node.geometry as! SCNBox, type: .static)
    }
    
    static func cylinderSolidification(_ node: SCNNode, _ scene: SCNScene) {
        baseSolidification(node, geometry: node.geometry as! SCNCylinder, type: .static)
    }
    
    static func concaveSolidification(_ node: SCNNode, _ scene: SCNScene) {
        let options: [SCNPhysicsShape.Option: Any] = [
            SCNPhysicsShape.Option.scale: node.scale,
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron
        ]
        let shape = SCNPhysicsShape(geometry: node.geometry!, options: options)
        let physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        node.physicsBody = physicsBody
    }
    
    static func dynamicSolidification(_ node: SCNNode, _ scene: SCNScene) {
        let options: [SCNPhysicsShape.Option: Any] = [SCNPhysicsShape.Option.scale: node.scale]
        let shape = SCNPhysicsShape(geometry: node.geometry!, options: options)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        node.physicsBody = physicsBody
    }
    
    static func ballSolidification(_ node: SCNNode, _ scene: SCNScene) {
        dynamicSolidification(node, scene)
        node.physicsBody!.restitution = 0.6
        node.physicsBody!.rollingFriction = 0.0
        node.physicsBody!.friction = 0.1
    }
}

