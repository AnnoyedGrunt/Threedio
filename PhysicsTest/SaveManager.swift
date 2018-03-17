//
//  SaveManager.swift
//  core data test
//
//  Created by Antonio Caiazzo on 06/03/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SceneKit


final class SaveManager {
    
    //singleton form
    private init() {}
    static let shared = SaveManager()
    
    //array to store levels from Core Data
    var levels: [NSManagedObject] = []
    
    //setting fileManager to save/load scenes files
    let fileManager = FileManager.default
    
    //name of the actual level
    var actualLevel: String?
    
    
    
    //function to save a level in core data
    func saveLevel(name: String, img: Int) -> Bool {
        
        for l in self.levels {
            if l.value(forKey: "name") as! String == name {
                print("name already exists, choose another name!")
                return false
            }
        }
                
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Level", in: managedContext)!
        let level = NSManagedObject(entity: entity, insertInto: managedContext)
        level.setValuesForKeys(["name" : name, "icon" : img])
        
        do {
            self.levels.insert(level, at: 0)
            try managedContext.save()
            print("Saved!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    
    
    //function to save scene file
    func saveSceneFile(name: String, scene: SCNScene) {
        if scene.write(to: self.getSceneUrl(levelName: name), options: nil, delegate: nil, progressHandler: nil) {
            print("Scene saved on file!")
        } else {
            print("Scene not saved on file!")
        }
    }
    
    
    
    //function to load all levels from core data
    func loadLevels() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest < NSManagedObject > (entityName: "Level")
        var levelsTemp: [NSManagedObject] = []
        
        do {
            levelsTemp = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.levels = []
        for l in levelsTemp {
            self.levels.insert(l, at: 0)
        }
    }
    
    
    
    //function to update a level (both core data and scene file)
    func updateLevel(oldName: String, newName: String, newIcon: Int) -> Bool {
        
        if oldName != newName {
            for l in self.levels {
                if l.value(forKey: "name") as! String == newName {
                    print("name already exists, choose another name!")
                    return false
                }
            }
        }
            
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        
//            for (index, element) in self.levels.enumerated() {
//                if element.value(forKey: "name") as? String == oldName {
//                    let l = element
//                    l.setValue(newName, forKey: "name")
//                    l.setValue(newIcon, forKey: "icon")
//                    self.levels.remove(at: index)
//                    self.levels.insert(l, at: 0)
//                    break
//                }
//            }
        
        for l in self.levels {
            if l.value(forKey: "name") as? String == oldName {
                self.deleteLevel(name: oldName, forUpdate: true)
                let _ = self.saveLevel(name: newName, img: newIcon)
            }
        }
        
            do {
                try managedContext.save()
                print("Updated on core data!")
            } catch let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
                return false
            }
            
        //updating scene file
        if oldName != newName {
            do {
                let oldUrl = self.getSceneUrl(levelName: oldName)
                let newUrl = self.getSceneUrl(levelName: newName)
                try fileManager.moveItem(at: oldUrl, to: newUrl)
            } catch let error as NSError {
                print("Could not update file name or delete old file. \(error), \(error.userInfo)")
                return false
            }
        }
        
        return true
    }
    
    
    //function to delete a level (both core data and scene file)
    func deleteLevel(name: String, forUpdate: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for (index, element) in self.levels.enumerated() {
            if element.value(forKey: "name") as? String == name {
                managedContext.delete(element)
                self.levels.remove(at: index)
                break
            }
        }
        
        do {
            try managedContext.save()
            print("Deleted from core data!")
        } catch let error as NSError {
            print("Could not delete from core data. \(error), \(error.userInfo)")
        }
        
        
        if !forUpdate {
            //deleting scene file
            let fileUrl = self.getSceneUrl(levelName: name)
            do {
                try self.fileManager.removeItem(at: fileUrl)
                print("Scene file deleted!")
            } catch let error as NSError {
                print("Error deleting scene file. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    //delete all levels
    func deleteAllLevels() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for l in self.levels {
            let index = self.levels.index(of: l)
            self.levels.remove(at: index!)
            managedContext.delete(l)
        }
        
        do {
            try managedContext.save()
            print("Deleted all levels from core data!")
        } catch let error as NSError {
            print("Could not delete all levels from core data. \(error), \(error.userInfo)")
        }
    }
    
    
    //function to get scene file url
    func getSceneUrl(levelName: String) -> URL {
        let documentDirUrl = try! self.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirUrl.appendingPathComponent("\(levelName).scn")
        return fileUrl
    }
    
    
    //function to print all levels
    func printLevels() {
        if self.levels == [] {
            print("empty list")
        } else {
            print("number of levels: \(levels.count)")
            for l in self.levels {
                print("name: \(l.value(forKey: "name")!) icon: \(l.value(forKey: "icon")!)")
            }
        }
    }
}
