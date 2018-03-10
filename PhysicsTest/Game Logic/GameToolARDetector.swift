//
//  GameToolIdentifier.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 07/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

/**
 Handles everything that has to do with the initial phase of the game: plane detection
 */

class GameToolARDetector: NSObject, GameTool {
    
    var sceneView: ARSCNView!
    var listeners = GameToolListenerList()
    var playfloor: SCNNode?
    var origin: SCNNode?
    var plane: SCNNode!
    
    //for handling different anchors and different planes
    var globalAnchor: ARPlaneAnchor?
    
    //plane dimensions (1 = 1 metro)
    let globalWidth: CGFloat = 2.0
    let globalHeight: CGFloat = 2.0
    
    //grid dimensions, initialized in viewDidLoad() function
    var globalScaleX: Float?
    var globalScaleY: Float?
    
    var planeDetected = false
    
    required init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
        
        plane = SCNNode()
        let planeGeometry = SCNPlane(width: globalWidth, height: globalHeight)
        planeGeometry.materials = [createGridMaterial(plane: planeGeometry)]
        
        plane.geometry = planeGeometry
        sceneView.scene.rootNode.addChildNode(plane)
        plane.eulerAngles.x = -.pi / 2
    }
    
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let point = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        if let hit =  sceneView.hitTest(point, types: .existingPlaneUsingExtent).first {
            let camera = sceneView.pointOfView!
            let position = camera.convertPosition(SCNVector3(0,0, -hit.distance), to: sceneView.scene.rootNode)
            playfloor?.position = position
            origin?.position = position
            plane.position = position + SCNVector3(0, 0.01, 0)
            planeDetected = true
        }
    }
    
    func onEnter() {
        playfloor = sceneView.scene.rootNode.childNode(withName: "Playfloor", recursively: true)!
        origin = sceneView.scene.rootNode.childNode(withName: "Origin", recursively: true)!
    }
    
    func onExit() {
    }
    
    func action(type: String, value: Any?) {
        
    }
    
    func onTap() {
        if planeDetected {
            listeners.invokeOnTap(sender: self, param: true)
        } else {
            listeners.invokeOnTap(sender: self, param: false)
        }
    }
    
    //MARK: RENDERER
    
    func ARRenderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    }
    
    func createGridMaterial(plane: SCNPlane) -> SCNMaterial {
        
        let cellSize: CGFloat = 0.1
        let wRepeat = Float(plane.width / cellSize)
        let hRepeat = Float(plane.height / cellSize)
        
        let image = UIImage(named: "grid.png")
        
        let material = SCNMaterial()
        material.diffuse.contents = image
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(wRepeat, hRepeat, 0)
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        return material
    }
}
