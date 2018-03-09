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
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playOrAddButton: UIButton!
    @IBOutlet weak var nameWorldTextField: UITextField! {
        didSet {
            nameWorldTextField.delegate = self
        }
    }
    @IBOutlet weak var icoButton: UIButton!
    @IBOutlet weak var modifyButton: UIButton!
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
            modifyButton.isHidden = true
            self.icoButton.setBackgroundImage(WorldsDataManager.shared.icons[0], for: .normal)
            self.nameWorldTextField.text = "New World \(WorldsDataManager.shared.worldCreated)"
        }
        else {
            self.icoButton.setBackgroundImage(WorldsDataManager.shared.icons[WorldsDataManager.shared.worlds[selectedWorld!].icoWorld!], for: .normal)
            self.view.backgroundColor = WorldsDataManager.shared.colorBackground
            self.nameWorldTextField.text = WorldsDataManager.shared.worlds[selectedWorld!].nameWorld
        }
        
        self.view.backgroundColor = WorldsDataManager.shared.colorBackground
        self.backView.layer.cornerRadius = 50
        self.backView.backgroundColor = .white
        
    
//        self.playOrAddButton.translatesAutoresizingMaskIntoConstraints = false
//        self.playOrAddButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//        self.playOrAddButton.frame.size = CGSize(width: Int(self.view.bounds.width / 10), height: Int(self.view.bounds.height / 7))
//        self.playOrAddButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
//        self.playOrAddButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75).isActive = true
//
//        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
//        self.deleteButton.currentBackgroundImage.contentMode = UIViewContentMode.scaleAspectFit
//        self.deleteButton.frame.size = CGSize(width: Int(50), height: Int(75))
//        self.deleteButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
//        self.deleteButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75).isActive = true
//
//        self.modifyButton.translatesAutoresizingMaskIntoConstraints = false
//        self.modifyButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//        self.modifyButton.frame.size = CGSize(width: Int(self.view.bounds.width / 10), height: Int(self.view.bounds.height / 7))
//        self.modifyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
//        self.modifyButton.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 300).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn (_ texField: UITextField) -> Bool {
        self.nameWorldTextField.resignFirstResponder()
        return true
    }

    //Button for add a new world or play
    @IBAction func playOrAddWorld(_ sender: Any) {
        
        if isInitial {
            WorldsDataManager.shared.addWorld(name: nameWorldTextField.text!, ico: WorldsDataManager.shared.icons.index(of: self.icoButton.currentBackgroundImage!)!)
            WorldsDataManager.shared.worldCreated += 1
            
//            self.performSegue(withIdentifier: "game", sender: self)
        }
//        else {
//            self.performSegue(withIdentifier: "game", sender: self)
//        }
        
        if avPlayer.isPlaying {
            self.avPlayer.stopMusic()
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
        WorldsDataManager.shared.worlds.remove(at: selectedWorld!)
        navigationController?.popViewController(animated: true)
    }
    
    //Modify a world
    @IBAction func modifyWorld(_ sender: Any) {
        WorldsDataManager.shared.worlds[selectedWorld!].icoWorld = WorldsDataManager.shared.icons.index(of: self.icoButton.currentBackgroundImage!)
        WorldsDataManager.shared.worlds[selectedWorld!].nameWorld = nameWorldTextField.text!
        navigationController?.popViewController(animated: true)
    }
    
}
