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
        //initializing grid dimensions
        self.globalScaleX = (Float(globalWidth)  / 0.1).rounded()
        self.globalScaleY = (Float(globalHeight) / 0.1).rounded()
    }
    
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        /*let point = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        if let hit =  sceneView.hitTest(point, types: .existingPlaneUsingExtent).first {
            let camera = sceneView.pointOfView!
            let position = camera.convertPosition(SCNVector3(0,0, -hit.distance), to: sceneView.scene.rootNode)
            playfloor?.position = position
            origin?.position = position
        }*/
        print("existin'")
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
        if let plane = sceneView.scene.rootNode.childNode(withName: "piano", recursively: true) {
            planeDetected = true
            //let playfloor = sceneView.scene.rootNode.childNode(withName: "Playfloor", recursively: true)!
            //let origin = sceneView.scene.rootNode.childNode(withName: "Origin", recursively: true)!
            let position = plane.convertPosition(plane.position, to: sceneView.scene.rootNode)
            playfloor?.position.y = position.y
            origin?.position.y = position.y
            playfloor?.geometry?.firstMaterial = plane.geometry!.firstMaterial
            plane.removeFromParentNode()
            listeners.invokeOnTap(sender: self, param: true)
        } else {
            listeners.invokeOnTap(sender: self, param: false)
        }
    }
    
    //MARK: RENDERER
    
    func ARRenderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        //unwrapping anchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        if planeAnchor != self.globalAnchor && !self.planeDetected {
            if globalAnchor != nil {
                sceneView.session.remove(anchor: self.globalAnchor!)
            }
            self.globalAnchor = planeAnchor
        }
        
        if !self.planeDetected {
            //Remove existing plane nodes
            node.enumerateChildNodes {
                (childNode, _) in
                childNode.removeFromParentNode()
            }
            
            let planeNode = self.createPlaneNode(anchor: self.globalAnchor!)
            node.addChildNode(planeNode)
        }
    }
    
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        
        //plane dimensions
        let planeWidth = self.globalWidth
        let planeHeight = self.globalHeight
        
        //extensible plane
        //        let planeWidth = CGFloat(anchor.extent.x)
        //        let planeHeight = CGFloat(anchor.extent.z)
        
        //setting plane with dimensions
        let plane = SCNPlane(width: planeWidth, height: planeHeight)
        
        //setting plane material
        let planeMaterial = SCNMaterial()
        let gridImage = UIImage(named: "grid.png")
        planeMaterial.diffuse.contents = gridImage
        let scaleX = self.globalScaleX
        let scaleY = self.globalScaleY
        planeMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(scaleX!, scaleY!, 0)
        planeMaterial.diffuse.wrapS = .repeat
        planeMaterial.diffuse.wrapT = .repeat
        
        plane.firstMaterial = planeMaterial
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "piano"
        
        let x = CGFloat(anchor.center.x)
        let y = CGFloat(anchor.center.y)
        let z = CGFloat(anchor.center.z)
        
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        planeNode.physicsBody = SCNPhysicsBody.static()
        
        return planeNode
    }
}
