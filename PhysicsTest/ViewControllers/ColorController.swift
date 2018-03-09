//
//  ColorController.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 23/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import UIKit

class ColorController: UIViewController {
    
    @IBOutlet weak var ColorStack: UIStackView!
    let selectionThickness: CGFloat = 4
    
    @IBAction func selectColor(_ sender: UIColorButton) {
        func invertColor(_ color: UIColor) -> UIColor {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            return UIColor(red: 1 - r, green: 1 - b, blue: 1 - g, alpha: a)
        }
        
        for case let button as UIColorButton in ColorStack.subviews {
            button.borderThickness = 0
        }
        
        if let main = parent as? ViewController {
            sender.borderThickness = selectionThickness
            sender.borderColor = invertColor(sender.backgroundColor!).cgColor
            main.selectColor(sender)
        }
    }
}
