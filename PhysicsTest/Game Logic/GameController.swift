//
//  BuilderCamera.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 08/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

/**
 cThe GameController allows for interfacing between an ARSCNView and GameTools. By changing the **tool** property, one can change the currently active tool.
 
 - Note: This class creates a UITapGestureRecognizer for the targetView and becomes its delegate on init.
 - Author: Raffaele Tontaro
*/
class GameController: NSObject, ARSCNViewDelegate {
    var sceneView : ARSCNView!
    var tapper : UITapGestureRecognizer!
    
    var tool: GameTool? {
        willSet(newTool) {
            guard let oldTool = tool else {return}
            if newTool != nil && oldTool !== newTool! {
               oldTool.onExit()
            }
        }
        didSet(oldTool) {
            guard let newTool = tool else {return}
            if oldTool != nil && newTool === oldTool! {
                newTool.onTap()
            } else {
                newTool.onEnter()
            }
        }
    }
    
    init(targetView: ARSCNView) {
        super.init()
        
        sceneView = targetView
        sceneView.delegate = self
        tapper = UITapGestureRecognizer(target: self, action: #selector(onTap))
        sceneView.addGestureRecognizer(tapper)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let tool = self.tool else {return}
        tool.onUpdate(renderer, updateAtTime: time)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let tool = self.tool else {return}
        tool.ARRenderer(renderer, didUpdate: node, for: anchor)
    }
    
    @objc func onTap() {
        guard let tool = self.tool else {return}
        tool.onTap()
    }
}
