//
//  ViewController.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 02/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController, ARSessionDelegate {
/*
    
    //@IBOutlet weak var sceneView: ARSCNView!
    var tapGesture = UITapGestureRecognizer()
    var controller : Builder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.session.delegate = self
        //sceneView.debugOptions.update(with: ARSCNDebugOptions.showWorldOrigin)
        //sceneView.debugOptions.update(with: ARSCNDebugOptions.showFeaturePoints)
        sceneView.debugOptions.update(with: .showPhysicsShapes)
        //sceneView.debugOptions.update(with: .renderAsWireframe)
        sceneView.debugOptions.update(with: .showBoundingBoxes)
        
        sceneView.isUserInteractionEnabled = true
        sceneView.showsStatistics = true
        
        //sceneView.scene = SCNScene(named: "mys.scn")!
        controller = Builder(targetView: sceneView)
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
    
    @IBAction func onSelection(_ sender: UISegmentedControl) {
        let name = sender.titleForSegment(at: sender.selectedSegmentIndex)!.lowercased()
        controller.setGeometry(name: name)
    }
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        if sender.isOn {
            //controller.mode = .delete
        } else {
            //controller.mode = .place
        }
    }*/
}

