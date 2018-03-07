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

protocol GameTool: AnyObject {
    var sceneView: ARSCNView! {get set}
    
    init(sceneView: ARSCNView)
    
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    func onTap()
    func onEnter()
    func onExit()
    func action(type: String, value: Any?)
}
