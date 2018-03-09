//
//  GameParticleSystem.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 09/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import SceneKit

class GameParticleSystem: SCNParticleSystem {
    var scale: CGFloat = 1
    
    private var fullParticleVelocity: CGFloat = 0
    override var particleVelocity: CGFloat {
        get {
            return fullParticleVelocity * scale
        }
        set {
            fullParticleVelocity = newValue
        }
    }
    private var fullParticleVelocityVariation: CGFloat = 0
    override var particleVelocityVariation: CGFloat {
        get {
            return fullParticleVelocityVariation * scale
        }
        set {
            fullParticleVelocityVariation = newValue
        }
    }
    
    /*private var fullAcceleration: SCNVector3
    override var acceleration: SCNVector3 {
        get {
            return fullAcceleration * scale
        }
        set {
            fullAccelereta
        }
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
