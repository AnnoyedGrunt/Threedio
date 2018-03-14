//
//  GameToolDestroyer.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 07/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

/**
 Handles the destruction of GamePieces that have already been inserted into the AR environment.
 
 
  Like all GameTools, it is 'selected' by assigning an instance of it to the *tool* property of a GameController.
 
 
 It allows for no actions.
 
  - Author: Raffaele Tontaro
 */
class GameToolDestroyer: GameTool {
    var sceneView: ARSCNView!
    var listeners = GameToolListenerList()
    
    let previewMaterial = GameMaterial(color: UIColor.red.withAlphaComponent(0.8))
    var oldMaterial: GameMaterial?
    var currentNode: SCNNode?
    
    var audioPlayer = UIApplication.shared.delegate as! AppDelegate
    
    
    required init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let hit = raycast(filter: .deletable ) {
            if hit.node != currentNode {
                resetMaterial()
                currentNode = hit.node
                oldMaterial = currentNode!.geometry?.firstMaterial as? GameMaterial
                currentNode!.geometry?.firstMaterial = previewMaterial
            }
        } else {
            resetMaterial()
            currentNode = nil
        }
    }
    
    func onTap(_ sender: UITapGestureRecognizer) -> Any? {
        destroyBlock()
        
        return nil
    }
    
    func onReselect() {
        destroyBlock()
    }
    
    func onExit() -> Any? {
        resetMaterial()
        currentNode = nil
        
        return nil
    }
    
    private func destroyBlock() {
        if let node = currentNode {
            let explosion = SCNParticleSystem(named: "Explode.scnp", inDirectory: nil)
            node.geometry = nil
            node.physicsBody = nil
            node.addParticleSystem(explosion!)
            node.scale = SCNVector3(1,1,1)
            node.castsShadow = false
            currentNode = nil
            
            audioPlayer.playSound(file: "break", ext: "mp3")
        }
    }
    private func resetMaterial() {
        guard let node = currentNode else {return}
        guard let material = oldMaterial else {return}
        
        node.geometry?.firstMaterial = material
    }
    
    private func raycast(filter mask: GamePieceSetting?) -> SCNHitTestResult? {
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
