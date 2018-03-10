//
//  GameToolManipulator.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 07/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

/**
 handles manipulation of dynamic GamePieces, like balls or dominoes.
 
 
  Like all GameTools, it is 'selected' by assigning an instance of it to the *tool* property of a GameController.
 
 
 It allows for the following actions:
 * "dropObject": takes no value. Drops the current heldObject if not nil.
 * "throwObject": takes no value. Throws the current heldObject if not nil.
 
  - Author: Raffaele Tontaro
 */
class GameToolManipulator: GameTool {
    var sceneView: ARSCNView!
    var listeners = GameToolListenerList()
    
    var heldObject: SCNNode?
    let throwingStrength: Float = 2
    let holdingDistance: Float = 0.8
    let origin: SCNNode!
    
    
    required init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        origin = sceneView.scene.rootNode.childNode(withName: "Origin", recursively: true)
    }
    
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {}
    func ARRenderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {}
    
    func onTap(_ sender: UITapGestureRecognizer) {
        manipulate()
    }
    
    func onReselect() {
        manipulate()
    }
    
    func onExit() {
        dropObject()
    }
    
    func action(type: String, value: Any? = nil) {
        if type == "throwObject" {
            throwObject()
        } else if type == "dropObject" {
            dropObject()
        }
    }
}

private extension GameToolManipulator {
    
    func manipulate() {
        if heldObject == nil {
            grabObject()
        } else {
            throwObject()
        }
    }
    
    func grabObject() {
        if let hit = raycast(filter: .dynamic) {
            dropObject()
            heldObject = hit.node
            sceneView.pointOfView!.addChildNode(hit.node)
            hit.node.position = SCNVector3(0, 0, -holdingDistance)
            hit.node.physicsBody?.clearAllForces()
            hit.node.physicsBody?.velocity = SCNVector3(0,0,0)
            hit.node.physicsBody?.isAffectedByGravity = false
        }
    }
    
    func dropObject() {
        if let object = heldObject {
            let newTransform = sceneView.pointOfView!.convertTransform(object.transform, to: origin)
            object.transform = newTransform
            origin.addChildNode(object)
            object.physicsBody?.isAffectedByGravity = true
            heldObject = nil
        }
    }
    
    func throwObject() {
        if let object = heldObject {
            let newTransform = sceneView.pointOfView!.convertTransform(object.transform, to: origin)
            let localForce = SCNVector3(0,0, -throwingStrength)
            let globalForce = sceneView.pointOfView!.convertVector(localForce, to: origin)
            origin.addChildNode(object)
            object.transform = newTransform
            object.physicsBody?.applyForce(globalForce, asImpulse: true)
            object.physicsBody?.isAffectedByGravity = true
            heldObject = nil
        }
    }
    
    //MARK: - UTILITY
    func raycast(filter mask: GamePieceSetting?) -> SCNHitTestResult? {
        let point = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        var options : [SCNHitTestOption: Any] = [SCNHitTestOption.boundingBoxOnly: true, SCNHitTestOption.firstFoundOnly : true]
        if mask != nil {
            options[SCNHitTestOption.categoryBitMask] = mask!.rawValue
        }
        let hits = sceneView.hitTest(point, options: options)
        if !hits.isEmpty {
            return hits.first
        }
        return nil
    }
    
}
