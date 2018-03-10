//
//  landscape.swift
//  PhysicsTest
//
//  Created by Francesco Castelluccio on 09/03/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation

import AVKit

class LandscapeAVPlayerController: AVPlayerViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
}
