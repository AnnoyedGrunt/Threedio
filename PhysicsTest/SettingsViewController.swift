//
//  SettingsViewController.swift
//  JapanIceTea
//
//  Created by Antonio Terrano on 16/02/18.
//  Copyright © 2018 Antonio Terrano. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    //to play audio
    let avPlayer = UIApplication.shared.delegate as! AppDelegate
    let secondPlayer = UIApplication.shared.delegate as! AppDelegate

    var oldName: String?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playOrAddButton: UIButton!
    @IBOutlet weak var nameWorldTextField: UITextField! {
        didSet {
            nameWorldTextField.delegate = self
        }
    }
    
    @IBOutlet weak var icoButton: UIButton!
    @IBOutlet weak var backView: UIView!
    var isInitial = false
    var selectedWorld: Int?
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !avPlayer.isPlaying {
            //plays music menu
            self.avPlayer.playMusic(file: "menuMusic", ext: "wav")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isInitial {
            deleteButton.isHidden = true
            self.icoButton.setBackgroundImage(WorldsDataManager.shared.icons[0], for: .normal)
            self.nameWorldTextField.text = "New World \(SaveManager.shared.levels.count + 1)"
        } else {
            self.icoButton.setBackgroundImage(WorldsDataManager.shared.icons[SaveManager.shared.levels[selectedWorld!].value(forKey: "icon") as! Int], for: .normal)
            self.view.backgroundColor = WorldsDataManager.shared.colorBackground
            self.nameWorldTextField.text = SaveManager.shared.levels[selectedWorld!].value(forKey: "name") as? String
            self.oldName = self.nameWorldTextField.text!
        }
        
        self.view.backgroundColor = WorldsDataManager.shared.colorBackground
        self.backView.layer.cornerRadius = 50
        self.backView.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //show keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard
    func textFieldShouldReturn (_ texField: UITextField) -> Bool {
        self.nameWorldTextField.resignFirstResponder()
        return true
    }

    //Button for add a new world or play
    @IBAction func playOrAddWorld(_ sender: Any) {
        if isInitial {
            SaveManager.shared.actualLevel = self.nameWorldTextField.text
            if SaveManager.shared.saveLevel(name: nameWorldTextField.text!, img: WorldsDataManager.shared.icons.index(of: icoButton.currentBackgroundImage!)!) {
                self.performSegue(withIdentifier: "toAction", sender: self)
                self.avPlayer.stopMusic()
            } else {
                self.secondPlayer.playSound(file: "quack", ext: "wav")
            }
        } else {
            SaveManager.shared.actualLevel = self.nameWorldTextField.text
            if SaveManager.shared.updateLevel(oldName: self.oldName!, newName: self.nameWorldTextField.text!, newIcon: WorldsDataManager.shared.icons.index(of: icoButton.currentBackgroundImage!)!) {
                self.performSegue(withIdentifier: "toAction", sender: self)
                self.avPlayer.stopMusic()
            } else {
                self.secondPlayer.playSound(file: "quack", ext: "wav")
            }
        }
        
    }
    
    //Change the world's ico
    @IBAction func changeIco(_ sender: Any) {
        let img = self.icoButton.currentBackgroundImage
        let numWorld = WorldsDataManager.shared.icons.index(of: img!)!
        
        if numWorld == WorldsDataManager.shared.icons.count - 1 {
            self.icoButton.setBackgroundImage(WorldsDataManager.shared.icons[0], for: .normal)
        }
        else {
            self.icoButton.setBackgroundImage(WorldsDataManager.shared.icons[numWorld + 1], for: .normal)
        }
    }
    
    //Delete a world
    @IBAction func deleteWorld(_ sender: Any) {
        SaveManager.shared.deleteLevel(name: nameWorldTextField.text!)
        navigationController?.popViewController(animated: true)
    }
    
    //back Button
    @IBAction func backAction(_ sender: Any) {
        if !isInitial {
            if SaveManager.shared.updateLevel(oldName: self.oldName!, newName: self.nameWorldTextField.text!, newIcon: WorldsDataManager.shared.icons.index(of: icoButton.currentBackgroundImage!)!) {
                navigationController?.popViewController(animated: true)
            } else {
                self.avPlayer.playSound(file: "quack", ext: "wav")
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainViewController = segue.destination as! ViewController
        if self.isInitial {
            mainViewController.isInitial = true
        }
    }

    
}
