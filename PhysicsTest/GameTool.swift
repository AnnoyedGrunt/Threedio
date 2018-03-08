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

protocol GameTool: AnyObject {
    var sceneView: ARSCNView! {get set}
    
    init(sceneView: ARSCNView)
    
    /**
        called once every frame.
    */
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    
    /**
        called whenever the user taps or when an already selected tool is selected again.
     */
    func onTap()
    
    /**
        Called by newly selected tools.
     */
    func onEnter()
    
    /**
        Called when a tool is switched out for another.
    */
    func onExit()
    
    /**
        An interfacing function. Look at each specific GameTool's documentation to see what actions they allow and what values they take.
     
     + Parameter type: the action you want to execute.
     + Parameter value: the value you want to execute it with. Not all actions take a value.
    */
    func action(type: String, value: Any?)
}
