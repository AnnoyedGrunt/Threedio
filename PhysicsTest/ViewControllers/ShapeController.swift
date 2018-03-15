//
//  ShapeController.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 23/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import UIKit

var azzurro = UIColor(red: 122/255, green: 176/255, blue: 240/255, alpha: 1.0)

class ShapeController: UIViewController {
    @IBOutlet weak var shapeStack: UIStackView!
    
    let selectionThickness: CGFloat = 3
    let selectionColor: CGColor = azzurro.cgColor
    
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
