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

class GameToolDestroyer: GameTool {
    var sceneView: ARSCNView!
    
    required init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {}
    
    func onTap() {
        if let hit = raycast(filter: .deletable ) {
            hit.node.removeFromParentNode()
        }
    }
    
    func onEnter() {}
    func onExit() {}
    func action(type: String, value: Any? = nil) {}
    
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
