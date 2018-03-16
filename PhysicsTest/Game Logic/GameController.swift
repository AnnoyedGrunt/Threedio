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
    var tapper: UITapGestureRecognizer!
    var panner: UIPanGestureRecognizer!
    
    var toolIsEnabled: Bool = true
    var tool: GameTool? {
        willSet(newTool) {
            guard let oldTool = tool, toolIsEnabled else {return}
            if newTool != nil && oldTool !== newTool! {
                oldTool.listeners.invokeOnExit(sender: oldTool, param: oldTool.onExit?())
            }
        }
        didSet(oldTool) {
            guard let newTool = tool, toolIsEnabled else {return}
            if oldTool != nil && newTool === oldTool! {
                newTool.onReselect?()
            } else {
                newTool.listeners.invokeOnEnter(sender: newTool, param: newTool.onEnter?())
            }
        }
    }
    
    
    init(targetView: ARSCNView) {
        self.sceneView = targetView
        super.init()
        self.sceneView.delegate = self
        
        var tapGesture: UITapGestureRecognizer?
        for recognizer in sceneView.gestureRecognizers!.reversed() {
            if recognizer is UITapGestureRecognizer {
                tapGesture = recognizer as? UITapGestureRecognizer
                break
            }
        }
        if tapGesture != nil {
            tapper = tapGesture
        } else {
            tapper = UITapGestureRecognizer()
            sceneView.addGestureRecognizer(tapper)
        }
        tapper.addTarget(self, action: #selector(onTap))

        var panGesture: UIPanGestureRecognizer?
        for recognizer in sceneView.gestureRecognizers!.reversed() {
            if recognizer is UIPanGestureRecognizer {
                panGesture = recognizer as! UIPanGestureRecognizer
                print("finding recognizer")
                break
            }
        }
        if panGesture != nil {
            panner = panGesture
        } else {
            print("creating pan recogznier")
            panner = UIPanGestureRecognizer()
            sceneView.addGestureRecognizer(panner)
        }
        panner.addTarget(self, action: #selector(onPan))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let tool = self.tool, toolIsEnabled else {return}
        tool.listeners.invokeOnUpdate(sender: tool, param: tool.onUpdate?(renderer, updateAtTime: time))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let tool = self.tool, toolIsEnabled else {return}
        tool.ARRenderer?(renderer, didUpdate: node, for: anchor)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard let tool = self.tool, toolIsEnabled else {return}
        tool.listeners.invokeOnTap(sender: tool, param: tool.onTap?(sender))
    }
    
    @objc func onPan(_ sender: UIPanGestureRecognizer ) {
        guard let tool = self.tool, toolIsEnabled else {return}
        tool.onPan?(sender)
        print("hello")
    }
}
