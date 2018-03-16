//
//  Worlds.swift
//  JapanIceTea
//
//  Created by Antonio Terrano on 19/02/18.
//  Copyright © 2018 Antonio Terrano. All rights reserved.
//

import Foundation
import UIKit

final class WorldsDataManager {
    
    private init(){}
    
    static let shared = WorldsDataManager()
    
    let icons = [#imageLiteral(resourceName: "Earth"), #imageLiteral(resourceName: "Jupiter"), #imageLiteral(resourceName: "Mars"), #imageLiteral(resourceName: "Mercury"), #imageLiteral(resourceName: "Neptune"), #imageLiteral(resourceName: "Pluton"), #imageLiteral(resourceName: "Sun"), #imageLiteral(resourceName: "Venus")]
    let colorBackground = UIColor(red: 193/255, green: 203/255, blue: 245/255, alpha: 1)
//    let colorCell = UIColor(red: 59/255, green: 178/255, blue: 115/255, alpha: 1)
    let colorCell = UIColor.white
    var worldCreated: Int = 1

}




