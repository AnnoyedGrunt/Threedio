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
import ReplayKit

class ViewController: UIViewController, GameToolListener, ARSessionDelegate, RPPreviewViewControllerDelegate{
    @IBOutlet public weak var sceneView: ARSCNView!
    @IBOutlet weak var shapeSelector: UIView!
    @IBOutlet weak var colorPicker: UIView!
    @IBOutlet weak var shapeView: UICustomView!
    @IBOutlet weak var colorView: UICustomView!
    @IBOutlet weak var selectorSwitcher: UIButton!
    @IBOutlet weak var deleterButton: UIButton!
    @IBOutlet weak var placerButton: UIButton!
    @IBOutlet weak var manipulatorButton: UIButton!
    @IBOutlet weak var MenuView: UICustomView!
    @IBOutlet weak var tutorialView: UIImageView!
    
    
    @IBOutlet weak var menuButton2: UIButton!
    
    
    @IBAction func menu2(_ sender: Any) {
        MenuView.isHidden = !MenuView.isHidden
        if MenuView.isHidden {
            menuButton2.setImage(#imageLiteral(resourceName: "Path 2"), for: .normal)
        } else {
            menuButton2.setImage(#imageLiteral(resourceName: "Path 3"), for: .normal)
        }
        
    }
    
    
    
    var controller: GameController?
    var builderTool: GameToolBuilder!
    var destroyerTool: GameToolDestroyer!
    var manipulatorTool: GameToolManipulator!
    var detectorTool: GameToolARDetector!
    
    var showARTutorial: Bool = true
    var showPlacementTutorial: Bool = true
    var showDestructionTutorial: Bool = true
    var showManipulationTutorial: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.debugOptions.update(with: ARSCNDebugOptions.showWorldOrigin)
        //sceneView.debugOptions.update(with: ARSCNDebugOptions.showFeaturePoints)
        sceneView.debugOptions.update(with: .showPhysicsShapes)
        //sceneView.debugOptions.update(with: .renderAsWireframe)
        //sceneView.debugOptions.update(with: .showBoundingBoxes)
        
        sceneView.isUserInteractionEnabled = true
        //sceneView.showsStatistics = true
        
        sceneView.scene = SCNScene(named: "mys.scn")!
        sceneView.session.delegate = self
        
        generateColors()
        
        
        builderTool = GameToolBuilder(sceneView: sceneView)
        builderTool.listeners.add(self)
        
        destroyerTool = GameToolDestroyer(sceneView: sceneView)
        destroyerTool.listeners.add(self)
        
        manipulatorTool = GameToolManipulator(sceneView: sceneView)
        manipulatorTool.listeners.add(self)
        
        detectorTool = GameToolARDetector(sceneView: sceneView)
        detectorTool.listeners.add(self)
        
        controller = GameController(targetView: sceneView)
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
    
    
    func showTools(_ show: Bool?) {
        let value = show ?? placerButton.isHidden
        deleterButton.isHidden = !value
        placerButton.isHidden = !value
        manipulatorButton.isHidden = !value
        // menuButton2.isHidden = !value
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
        tool.action?(type: "setMaterial", value: sender.title(for: .normal)!)
    }
    
    @IBAction func selectShape(_ sender: UIButton) {
        guard let tool = self.controller?.tool else {return}
        tool.action?(type: "setGamePiece", value: sender.title(for: .normal)!)
    }
    
    func onTap(sender: GameTool, param: Any?) {
        if sender is GameToolARDetector {
            let hasFound = param as! Bool
            if hasFound {
                showSelectors(true)
                showTools(true)
                controller?.tool = builderTool
            }
        }
    }
    
    func onEnter(sender: GameTool, param: Any?) {
        if sender is GameToolARDetector && showARTutorial {
            tutorialView.isHidden = false
            tutorialView.image = #imageLiteral(resourceName: "Floor")
            showARTutorial = false
            controller?.toolIsEnabled = false
            print("Showing AR Tutorial")
        } else if sender is GameToolBuilder && showPlacementTutorial {
            tutorialView.isHidden = false
            tutorialView.image = #imageLiteral(resourceName: "First Block")
            showPlacementTutorial = false
            controller?.toolIsEnabled = false
            print("Showing Placement Tutorial")
        } else if sender is GameToolDestroyer && showDestructionTutorial {
            tutorialView.isHidden = false
            tutorialView.image = #imageLiteral(resourceName: "HammerTutorial")
            showDestructionTutorial = false
            controller?.toolIsEnabled = false
            print("Showing Destruction Tutorial")
        } else if sender is GameToolManipulator && showManipulationTutorial {
            tutorialView.isHidden = false
            tutorialView.image = #imageLiteral(resourceName: "HandTutorial")
            showManipulationTutorial = false
            controller?.toolIsEnabled = false
            print("Showing Manipulation Tutorial")
        }
    }
    
    func onExit(sender: GameTool, param: Any?) {
        
    }
    
    @IBAction func onUserTap(_ sender: UITapGestureRecognizer) {
        tutorialView.isHidden = true
        if sender.state == .ended {
            controller?.toolIsEnabled = true
        }
    }
}
