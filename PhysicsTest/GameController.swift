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

class GameController: NSObject, ARSCNViewDelegate {
    
    var view : ARSCNView!
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
        
        self.view = targetView
        self.view.delegate = self
        tapper = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapper)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let tool = self.tool else {return}
        tool.onUpdate(renderer, updateAtTime: time)
    }
    
    @objc func onTap() {
        guard let tool = self.tool else {return}
        tool.onTap()
    }
}
