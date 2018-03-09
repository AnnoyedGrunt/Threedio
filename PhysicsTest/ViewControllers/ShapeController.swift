//
//  ShapeController.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 23/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import UIKit

class ShapeController: UIViewController {
    @IBOutlet weak var shapeStack: UIStackView!
    let selectionThickness: CGFloat = 4
    let selectionColor: CGColor = UIColor.red.cgColor
    
    @IBAction func selectColor(_ sender: UIColorButton) {
        for container in shapeStack.subviews {
            for case let button as UIColorButton in container.subviews {
                button.borderThickness = 0
            }
            
        }
        
        if let main = parent as? ViewController {
            sender.borderThickness = selectionThickness
            sender.borderColor = selectionColor
            main.selectShape(sender)
        }
    }
}
