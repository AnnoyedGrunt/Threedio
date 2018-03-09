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
            path = Bundle.main.path(forResource: "3dioIphone", ofType: "m4v")!
        }
        let movieurl: NSURL = NSURL.fileURL(withPath: path) as NSURL
        
        showsPlaybackControls = false
        self.player = AVPlayer(url: movieurl as URL)
        player!.play()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        self.performSegue(withIdentifier: "menu", sender: self)
    }
    
    
//    func riconosciDevice(){
    
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 1136:
//                print("iPhone 5 or 5S or 5C")
//            case 1334:
//                print("iPhone 6/6S/7/8")
//            case 2208:
//                print("iPhone 6+/6S+/7+/8+")
//            case 2436:
//                print("iPhone X")
//            default:
//                print("unkno")
//            }
//        }
        
//        if UIDevice().userInterfaceIdiom == .pad {
//            switch UIScreen.main.nativeBounds.height{
//            case 2732:
//                print("Ipad 12,pro")
//            case 2224:
//                print("Ipad 10, pro")
//            default:
//                print("Niente")
//            }
//        }
        
//        if UIDevice().userInterfaceIdiom == .pad{
//            if UIScreen.main.nativeBounds.height == 2732 || UIScreen.main.nativeBounds.height == 2224 || UIScreen.main.nativeBounds.height == 2048 {
//                print("CIAO")
//            }
//        }
        
//        if UIDevice().userInterfaceIdiom == .pad {
//            print("IPAD")
//        }else {
//            print("Iphone")
//        }
//
//    }
}
