//
//  MenuController.swift
//  PhysicsTest
//
//  Created by Sofia Passarelli on 08/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ReplayKit
import ARKit


class MenuController : UIViewController , RPPreviewViewControllerDelegate {
    
    //for bomb button
    var timer = Timer()
    var isExploding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //to play audio
    let avPlayer = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var bombOutlet: UIButton!
    
    
    //save scene and exit
    @IBAction func backButton(_ sender: Any) {
        
        if let load = SaveManager.shared.actualLevel {
            let sceneViewController = self.parent as! ViewController
            sceneViewController.builderTool.action(type: "deletePreview")
            SaveManager.shared.saveSceneFile(name: load, scene: sceneViewController.sceneView.scene)
        }
        self.avPlayer.stopSound()
        self.timer.invalidate()
        navigationController?.popToRootViewController(animated: true)
    }
    
    //start recording
    @IBAction func startButto(_ sender: Any) {
        startRecording()
        stop.isHidden = !stop.isHidden
        start.isHidden = !start.isHidden
    }
    
    //stop recording
    @IBAction func stopButto(_ sender: Any) {
        stopRecording()
        stop.isHidden = !stop.isHidden
        start.isHidden = !start.isHidden
    }
    
    @IBAction func screenButton(_ sender: Any) {
        if let main = parent as? ViewController {
            let image = main.sceneView.snapshot()
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.avPlayer.playSound(file: "camera", ext: "wav")
        }
    }
        
        //  Funzione di start recordig
       @objc func startRecording() {
            let recorder = RPScreenRecorder.shared()
            
            recorder.startRecording{ [unowned self] (error) in
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                } else {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(self.stopRecording))
                }
            }
        }
        
        //    Funzione di stop recording
      @objc func stopRecording() {
            let recorder = RPScreenRecorder.shared()
            
            recorder.stopRecording { [unowned self] (preview, error) in
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(self.startRecording))
                
                if let unwrappedPreview = preview {
                    unwrappedPreview.previewControllerDelegate = self
                    self.present(unwrappedPreview, animated: true)
                }
            }
        }
        
       
        func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
            dismiss(animated: true)
        }
        //    ..... a qui

    
    
    @IBAction func bombButton(_ sender: UIButton) {
        if !self.isExploding {
            self.isExploding = true
            self.runTimer()
            self.avPlayer.playSound(file: "countdown", ext: "wav")
            self.bombOutlet.setImage(#imageLiteral(resourceName: "bombfired2"), for: .normal)
        } else {
            self.isExploding = false
            self.timer.invalidate()
//            self.avPlayer.stopSound()
            self.avPlayer.playSound(file: "abort", ext: "wav")
            self.bombOutlet.setImage(#imageLiteral(resourceName: "bomb"), for: .normal)
        }
    }

    
    //starts timer
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(MenuController.cleanLevel)), userInfo: nil, repeats: false)
    }
    
    //delete everything except the plane
    @objc func cleanLevel() {
        let sceneViewController = self.parent as! ViewController
        let origin = sceneViewController.sceneView.scene.rootNode.childNode(withName: "Origin", recursively: false)
        origin?.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode() }
        self.avPlayer.playSound(file: "bomb", ext: "wav")
        self.bombOutlet.setImage(#imageLiteral(resourceName: "bomb"), for: .normal)
        self.isExploding = false
    }

}


