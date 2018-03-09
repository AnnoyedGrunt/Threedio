//
//  ViewController.swift
//  sceneview
//
//  Created by Sofia Passarelli on 16/02/18.
//  Copyright © 2018 Sofia Passarelli. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, GameToolListener, ARSessionDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var shapeSelector: UIView!
    @IBOutlet weak var colorPicker: UIView!
    @IBOutlet weak var shapeView: UICustomView!
    @IBOutlet weak var colorView: UICustomView!
    @IBOutlet weak var selectorSwitcher: UIButton!
    @IBOutlet weak var throwButton: UIButton!
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var deleterButton: UIButton!
    @IBOutlet weak var placerButton: UIButton!
    @IBOutlet weak var manipulatorButton: UIButton!
    
    @IBOutlet weak var MenuView: UIView!
    
    @IBAction func menu(_ sender: Any) {
       MenuView.isHidden = !MenuView.isHidden
    }
    
    var controller: GameController?
    var builderTool: GameToolBuilder!
    var destroyerTool: GameToolDestroyer!
    var manipulatorTool: GameToolManipulator!
    var detectorTool: GameToolARDetector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.debugOptions.update(with: ARSCNDebugOptions.showWorldOrigin)
        //sceneView.debugOptions.update(with: ARSCNDebugOptions.showFeaturePoints)
        //sceneView.debugOptions.update(with: .showPhysicsShapes)
        //sceneView.debugOptions.update(with: .renderAsWireframe)
        //sceneView.debugOptions.update(with: .showBoundingBoxes)
        
        sceneView.isUserInteractionEnabled = true
        //sceneView.showsStatistics = true
        
        sceneView.scene = SCNScene(named: "mys.scn")!
        sceneView.session.delegate = self
        
        generateColors()
        
        controller = GameController(targetView: sceneView)
        builderTool = GameToolBuilder(sceneView: sceneView)
        destroyerTool = GameToolDestroyer(sceneView: sceneView)
        manipulatorTool = GameToolManipulator(sceneView: sceneView)
        detectorTool = GameToolARDetector(sceneView: sceneView)
        detectorTool.listeners.add(self)
        
        controller?.tool = detectorTool
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        sceneView.session.pause()
    }
    
    func showSelectors(_ show: Bool?) {
        let value = show ?? shapeSelector.isHidden
        shapeView.isHidden = !value
        colorView.isHidden = true
        selectorSwitcher.isHidden = !value
    }
    
    func showManipulators(_ show: Bool?) {
        let value = show ?? throwButton.isHidden
        throwButton.isHidden = !value
        dropButton.isHidden = !value
    }
    
    func showTools(_ show: Bool?) {
        let value = show ?? placerButton.isHidden
        deleterButton.isHidden = !value
        placerButton.isHidden = !value
        manipulatorButton.isHidden = !value
    }
    
    @IBAction func onDeleterTap(_ sender: UIButton) {
        guard let controller = self.controller else {return}
        showSelectors(false)
        controller.tool = destroyerTool
    }
    
    @IBAction func onPlacerTap(_ sender: UIButton) {
        guard let controller = self.controller else {return}
        showSelectors(true)
        controller.tool = builderTool
        
    }
    
    @IBAction func onManipulatortap(_ sender: UIButton) {
        guard let controller = self.controller else {return}
        showSelectors(false)
        controller.tool = manipulatorTool
    }

    @IBAction func onThrowTap(_ sender: Any) {
        guard let tool = self.controller?.tool else {return}
        tool.action(type: "throwObject", value: nil)
    }
    
    
    @IBAction func onDropTap(_ sender: Any) {
        guard let tool = self.controller?.tool else {return}
        tool.action(type: "dropObject", value: nil)
    }
    
    @IBAction func switchSelectors(_ sender: UIButton) {
        shapeView.isHidden = !shapeView.isHidden
        colorView.isHidden = !colorView.isHidden
        if !shapeView.isHidden {
            selectorSwitcher.setImage(#imageLiteral(resourceName: "ColorWheel"), for: .normal)
        } else {
            selectorSwitcher.setImage(#imageLiteral(resourceName: "all"), for: .normal)
        }
    }
    
    func generateColors() {
        for child in colorPicker.subviews {
            let childButton = child as! UIButton
            GameMaterial.newMaterial(color: childButton.backgroundColor!, withName: childButton.title(for: .normal)!)
        }
    }
    
    @IBAction func selectColor(_ sender: UIButton) {
        guard let tool = self.controller?.tool else {return}
        tool.action(type: "setMaterial", value: sender.title(for: .normal)!)
    }
    
    @IBAction func selectShape(_ sender: UIButton) {
        guard let tool = self.controller?.tool else {return}
        tool.action(type: "setGamePiece", value: sender.title(for: .normal)!)
    }
    
    func onTap(sender: GameTool, param: Any?) {
        if sender is GameToolARDetector {
            let hasSetPlane = param as! Bool
            if hasSetPlane {
                controller?.tool = builderTool
                showSelectors(true)
                showTools(true)
            }
        }
    }
    
    func onEnter(sender: GameTool, param: Any?) {
        
    }
    
    func onExit(sender: GameTool, param: Any?) {
        
    }
}
