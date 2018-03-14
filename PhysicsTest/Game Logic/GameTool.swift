//
//  GameTool.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 06/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

/**
    The GameTool protocol contains a number of events that are called by the GameController.
 
 - Author: Raffaele Tontaro
*/

@objc protocol GameTool: AnyObject {
    var sceneView: ARSCNView! {get set}
    var listeners: GameToolListenerList {get set}
    
    init(sceneView: ARSCNView)
    
    /**
        called once every frame.
    */
    @objc optional func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    
    @objc optional func ARRenderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
    
    /**
        called whenever the user taps
     */
    @objc optional func onTap(_ sender: UITapGestureRecognizer) -> Any?
    
    @objc optional func onPan(_ sender: UIPanGestureRecognizer)
    /**
        Called by newly selected tools.
     */
    @objc optional func onEnter() -> Any?
    
    /**
        Called when a tool is switched out for another.
    */
    @objc optional func onExit() -> Any?
    
    @objc optional func onReselect()
    
    /**
        An interfacing function. Look at each specific GameTool's documentation to see what actions they allow and what values they take.
     
     + Parameter type: the action you want to execute.
     + Parameter value: the value you want to execute it with. Not all actions take a value.
    */
    @objc optional func action(type: String, value: Any?)
}
