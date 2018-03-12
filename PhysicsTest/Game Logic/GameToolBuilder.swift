//
//  GameToolBuilder.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 07/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

/**
    Handles everything that has to do with the placement of GamePieces within the game world and thus it is arguably the most important out of all tools.
 
 Like all GameTools, it is 'selected' by assigning an instance of it to the *tool* property of a GameController.
 
 It allows for the following actions:
 
 * "setGamePiece": takes a string, the name of a GamePiece.
 * "setGameMaterial": takes a string, the name of the GameMaterial.
 
 - Author: Raffaele Tontaro
 */
class GameToolBuilder: GameTool {
    
    var sceneView: ARSCNView!
    var listeners = GameToolListenerList()
    
    let blockSize : Float = 0.1
    let cgBlockSize : CGFloat = 0.1
    var blockPreview : SCNNode?
    var previewMaterial = GameMaterial()
    let previewAlpha: CGFloat = 0.2
    var playfloor: SCNNode!
    var root: SCNNode!
    var origin: SCNNode!
    var lastPositions: [SCNVector3] = []
    let positionCacheCount = 5
    
    var audioPlayer = UIApplication.shared.delegate as! AppDelegate
    
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
    
    required init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        root = sceneView.scene.rootNode
        playfloor = root.childNode(withName: "Playfloor", recursively: true)
        origin = root.childNode(withName: "Origin", recursively: true)
        
        setGamePiece(named: "Block")
    }
    
    func onUpdate(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let hit = raycast(filter: .hittable) {
            if blockPreview == nil {
                createPreview()
            }
            lastPositions.append(root.convertPosition(hit.worldCoordinates, to: origin))
            lastPositions = Array(lastPositions.suffix(positionCacheCount))
            let position = lastPositions.reduce(SCNVector3(0,0,0), {$0 + $1}) / Float(lastPositions.count)
            let direction = root.convertVector(hit.localNormal, to: origin)
            updatePreview(at: position, from: sceneView.pointOfView!.position, withDirection: direction, withScale: blockSize)
        }
    }
    
    func onTap(_ sender: UITapGestureRecognizer) {
        placeBlock()
    }
    
    func onReselect() {
        placeBlock()
    }
    
    
    func onExit() {
        deletePreview()
    }
    
    func action(type: String, value: Any? = nil) {
        if type == "setGamePiece" {
            guard let pieceName = value as? String else {return}
            setGamePiece(named: pieceName)
        } else if type == "setMaterial" {
            guard let materialName = value as? String else {return}
            setMaterial(named: materialName)
        }
    }
}

//MARK: - PRIVATE EXTENSION
private extension GameToolBuilder {
    //MARK: - PLACEMENT
    
    func placeBlock() {
        solidifyPreview()
        audioPlayer.playSound(file: "create", ext: "mp3")
    }
    
    //MARK: - ACTIONS

    func setGamePiece(named name: String) {
        piece = GamePiece.withName(name)
        deletePreview()
    }
    
    func setMaterial(named name: String) {
        material = GameMaterial.withName(name)
        deletePreview()
    }
    
    //MARK: - NODE MANAGEMENT
    func createNode() -> SCNNode {
        let node = duplicateNode(piece.node)
        return node
    }
    
    func duplicateNode(_ node: SCNNode) -> SCNNode {
        func duplicateGeometry(_ node: SCNNode) {
            if node.geometry != nil {
                node.geometry = node.geometry!.copy() as? SCNGeometry
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
    
    //MARK: - Preview
    
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
            piece.onSolidify.logic(preview, sceneView.scene)
            preview.geometry?.firstMaterial = material
            blockPreview = nil
        }
    }
    
    //MARK: - UTILITY
    func raycast(filter mask: GamePieceSetting?) -> SCNHitTestResult? {
        let point = CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2)
        var options : [SCNHitTestOption: Any] = [SCNHitTestOption.boundingBoxOnly: true, SCNHitTestOption.firstFoundOnly : true]
        if mask != nil {
            options[SCNHitTestOption.categoryBitMask] = mask!.rawValue
        }
        let hits = sceneView.hitTest(point, options: options)
        if !hits.isEmpty {
            return hits.first
        }
        return nil
    }
}
