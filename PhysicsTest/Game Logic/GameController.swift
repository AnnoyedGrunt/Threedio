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
class GameController: NSObject, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    var sceneView : ARSCNView!
    var tapper : UITapGestureRecognizer!
    var panner: UIPanGestureRecognizer!
    
    var tool: GameTool? {
        willSet(newTool) {
            guard let oldTool = tool else {return}
            if newTool != nil && oldTool !== newTool! {
               oldTool.onExit?()
            }
        }
        didSet(oldTool) {
            guard let newTool = tool else {return}
            if oldTool != nil && newTool === oldTool! {
                newTool.onReselect?()
            } else {
                newTool.onEnter?()
            }
        }
    }
    
    init(targetView: ARSCNView) {
        super.init()
        
        sceneView = targetView
        sceneView.delegate = self
        tapper = UITapGestureRecognizer(target: self, action: #selector(onTap))
        panner = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        sceneView.addGestureRecognizer(tapper)
        sceneView.addGestureRecognizer(panner)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let tool = self.tool else {return}
        tool.onUpdate?(renderer, updateAtTime: time)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let tool = self.tool else {return}
        tool.ARRenderer?(renderer, didUpdate: node, for: anchor)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard let tool = self.tool else {return}
        tool.onTap?(sender)
    }
    
    @objc func onPan(_ sender: UIPanGestureRecognizer ) {
        guard let tool = self.tool else {return}
        tool.onPan?(sender)
    }
}
