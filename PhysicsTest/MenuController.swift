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


class MenuController : UIViewController ,RPPreviewViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 
   
    @IBAction func screenButton(_ sender: Any) {
        if let main = parent as? ViewController{
            print ("done")
            var image = main.sceneView.snapshot()
            print ("done3")
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print ("fattoo")
        }
        
    }

        
    
  
    
    
}
