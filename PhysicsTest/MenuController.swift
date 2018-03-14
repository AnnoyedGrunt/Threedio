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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //to play audio
    let avPlayer = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var start: UIButton!
   
        @IBAction func stopButto(_ sender: Any) {
        stopRecording()
        stop.isHidden = !stop.isHidden
        start.isHidden = !start.isHidden
       
    }
    
    //save scene and exit
    @IBAction func backButton(_ sender: Any) {
        
        if let load = SaveManager.shared.actualLevel {
            let sceneViewController = self.parent as! ViewController
            SaveManager.shared.saveSceneFile(name: load, scene: sceneViewController.sceneView.scene)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startButto(_ sender: Any) {
               startRecording()
        stop.isHidden = !stop.isHidden
        start.isHidden = !start.isHidden
        
    }
    
    @IBAction func screenButton(_ sender: Any) {
        if let main = parent as? ViewController{
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

    
  
    
}


