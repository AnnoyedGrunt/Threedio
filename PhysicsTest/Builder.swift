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

class Builder : NSObject, ARSCNViewDelegate {
    
    enum BuilderMode {
        case none
        case place
        case manipulate
        case delete
    }
    
    let blockSize : Float = 0.1
    let cgBlockSize : CGFloat = 0.1
    var recentTargetingPositions :[SCNVector3] = []
    var tapper : UITapGestureRecognizer!
    var view : ARSCNView!
    
    var blockPreview : SCNNode?
    
    var heldObject: SCNNode?
    let throwingStrength: Float = 2
    let holdingDistance: Float = 0.8
    var mode : BuilderMode = .place {
        didSet {
            if mode != .place {
                deletePreview()
            }
            if mode != .manipulate {
                dropObject()
            }
            if oldValue == mode {
                if mode == .place {
                    place()
                } else if mode == .delete {
                    delete()
                } else if mode == .manipulate {
                    if heldObject == nil {
                        manipulate()
                    } else {
                        throwObject()
                    }
                }
            }
        }
    }
    
    var piece: GamePiece! {
        didSet {
            deletePreview()
        }
    }
    
    var material = GameMaterial() {
        didSet {
            deletePreview()
        }
    }
    
    var previewMaterial = GameMaterial()
    let previewAlpha: CGFloat = 0.2
    
    var playfloor: SCNNode!
    var root: SCNNode!
    var origin: SCNNode!
    
    init(targetView: ARSCNView) {
        super.init()
        
        self.view = targetView
        self.view.delegate = self
        tapper = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapper)
        
        piece = GamePiece.withName("")
        material = GameMaterial.withName("")
        
        root = view.scene.rootNode
        playfloor = root.childNode(withName: "Playfloor", recursively: true)
        origin = root.childNode(withName: "Origin", recursively: true)
    }
    
    //MARK: Outside modificiation
    func setGeometry(name: String) {
        piece = GamePiece.withName(name)
        deletePreview()
    }
    
    func setMaterial(name: String) {
        material = GameMaterial.withName(name)
        deletePreview()
    }
    
    //MARK: Builder Functionality
    @objc func onTap() {
        switch mode {
        case .manipulate:
            manipulate()
        case .delete:
            delete()
        default:
            place()
        }
    }
    
    func place() {
        solidifyPreview()
    }
    
    func delete() {
        if let hit = raycast(filter: .deletable ) {
            hit.node.removeFromParentNode()
        }
    }
    
    func manipulate() {
        if let hit = raycast(filter: .dynamic) {
            dropObject()
            heldObject = hit.node
            view.pointOfView!.addChildNode(hit.node)
            hit.node.position = SCNVector3(0, 0, -holdingDistance)
            hit.node.physicsBody?.clearAllForces()
            hit.node.physicsBody?.velocity = SCNVector3(0,0,0)
            hit.node.physicsBody?.isAffectedByGravity = false
        }
    }
    func raycast(filter mask: GamePieceSetting?) -> SCNHitTestResult? {
        let point = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        var options : [SCNHitTestOption: Any] = [SCNHitTestOption.boundingBoxOnly: true, SCNHitTestOption.firstFoundOnly : true]
        if mask != nil {
            options[SCNHitTestOption.categoryBitMask] = mask!.rawValue
        }
        let hits = view.hitTest(point, options: options)
        if !hits.isEmpty {
            return hits.first
            
        }
        return nil
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        update()
    }
    
    func update() {
        if mode == .place {
            if let hit = raycast(filter: .hittable) {
                if blockPreview == nil {
                    createPreview()
                }
                recentTargetingPositions.append(root.convertPosition(hit.worldCoordinates, to: origin))
                recentTargetingPositions = Array(recentTargetingPositions.suffix(5))
                let position = recentTargetingPositions.reduce(SCNVector3(0,0,0), {$0 + $1}) / Float(recentTargetingPositions.count)
                let direction = hit.localNormal
                updatePreview(at: position, from: view.pointOfView!.position, withDirection: direction, withScale: blockSize)
            }
        }
    }
    
    //MARK: Node Management
    
    func createNode() -> SCNNode {
        let node = duplicateNode(piece.node)
        return node
    }
    
    func duplicateNode(_ node: SCNNode) -> SCNNode {
        func duplicateGeometry(_ node: SCNNode) {
            if node.geometry != nil {
                node.geometry = node.geometry!.copy() as! SCNGeometry
            }
            for childNode in node.childNodes {
                duplicateGeometry(childNode)
            }
        }
        
        let newNode = node.clone()
        duplicateGeometry(newNode)
        return newNode
    }
    
    func updateNodePosition(node: SCNNode, at position: SCNVector3, from origin: SCNVector3, withDirection direction: SCNVector3, withScale scale: Float) {
        
        func toGrid(_ coord: Float, withOffset: Float) -> Float {
            let offset = round(withOffset) * (scale * 0.5)
            let gridCoord = floor((coord + offset)/scale)
            return (scale/2) + (gridCoord) * scale
        }
        
        let x = toGrid(position.x, withOffset: direction.x)
        let y = toGrid(position.y, withOffset: direction.y)
        let z = toGrid(position.z, withOffset: direction.z)
        
        node.position = SCNVector3(x: x, y: y, z: z)
        node.scale = SCNVector3(x: scale, y: scale, z: scale)
        
        if piece.orientation == .vertical {
            node.eulerAngles.x = Float.pi * 0.5 * round(direction.z)
            node.eulerAngles.z = Float.pi * -0.5 * round(direction.x)
        } else if piece.orientation == .horizontal {
            if direction.z < 0 {
                node.eulerAngles.y = Float.pi
            } else {
                node.eulerAngles.y = Float.pi * 0.5 * sign(round(direction.x))
            }
        } else if piece.orientation == .fullHorizontal {
            let dir: SCNVector3 = position - origin
            let angle = atan2(dir.x, dir.z)
            node.eulerAngles.y = angle//+ Float.pi/2
        }
    }
    
    func setNodeMaterial(_ node: SCNNode, material: SCNMaterial) {
        node.geometry?.firstMaterial = material
        for childNode in node.childNodes {
            setNodeMaterial(childNode, material: material)
        }
    }
    
    func setNodeSettings(_ node: SCNNode, settings: GamePieceSetting) {
        node.categoryBitMask = settings.rawValue
        for childNode in node.childNodes {
            setNodeSettings(childNode, settings: settings)
        }
    }
    //MARK: Preview
    
    func createPreview() {
        blockPreview = createNode()
        if let color = material.diffuse.contents as? UIColor {
            previewMaterial.diffuse.contents = color.withAlphaComponent(previewAlpha)
        }
        setNodeMaterial(blockPreview!, material: previewMaterial)
        origin.addChildNode(blockPreview!)
    }
    
    func updatePreview(at position: SCNVector3, from origin: SCNVector3, withDirection direction: SCNVector3, withScale scale: Float) {
        updateNodePosition(node: blockPreview!, at: position , from: origin, withDirection: direction, withScale: scale)
        
        if piece.settings.contains(.dynamic) {
            let extraSpace: Float = 0.01
            let (min, max) = blockPreview!.geometry!.boundingBox
            let height = (max.y - min.y) * blockSize
            
            if height > blockSize {
                blockPreview!.position.y += height * blockPreview!.scale.y
            }
            blockPreview!.position.y += extraSpace
        }
    }
    
    func deletePreview() {
        if let preview = blockPreview {
            preview.removeFromParentNode()
            blockPreview = nil
        }
    }
    
    func solidifyPreview() {
        if let preview = blockPreview {
            setNodeSettings(preview, settings: piece.settings)
            setNodeMaterial(preview, material: material)
            if let solidificationEvent = piece.onSolidification {
                solidificationEvent(preview, view.scene)
            }
            preview.geometry?.firstMaterial = material
            blockPreview = nil
        }
    }
    
    //MARK: Manipulation
    
    func dropObject() {
        if let object = heldObject {
            let newTransform = view.pointOfView!.convertTransform(object.transform, to: origin)
            object.transform = newTransform
            origin.addChildNode(object)
            object.physicsBody?.isAffectedByGravity = true
            heldObject = nil
        }
    }
    
    func throwObject() {
        if let object = heldObject {
            let newTransform = view.pointOfView!.convertTransform(object.transform, to: origin)
            let localForce = SCNVector3(0,0, -throwingStrength)
            let globalForce = view.pointOfView!.convertVector(localForce, to: origin)
            origin.addChildNode(object)
            object.transform = newTransform
            object.physicsBody?.applyForce(globalForce, asImpulse: true)
            object.physicsBody?.isAffectedByGravity = true
            heldObject = nil
        }
    }
}
