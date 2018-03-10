//
//  VideoController.swift
//  PhysicsTest
//
//  Created by Raffaele Tontaro on 23/02/18.
//  Copyright © 2018 Raffaele Tontaro. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoController: AVPlayerViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var path: String
        
        if UIDevice().userInterfaceIdiom == .pad {
            path = Bundle.main.path(forResource: "3dio", ofType: "m4v")!
        }else{
            path = Bundle.main.path(forResource: "3dio", ofType: "m4v")!
        }
        let movieurl: NSURL = NSURL.fileURL(withPath: path) as NSURL
        
        showsPlaybackControls = false
        self.player = AVPlayer(url: movieurl as URL)
        player!.play()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        self.performSegue(withIdentifier: "start", sender: self)
    }
}
