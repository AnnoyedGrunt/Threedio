//
//  UICustomScrollView.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 23/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UICustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderThickness: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderThickness
        }
    }
    
    @IBInspectable var borderColor: CGColor = UIColor.clear.cgColor {
        didSet {
            layer.borderColor = borderColor
        }
    }
}
