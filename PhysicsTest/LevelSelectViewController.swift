//
//  LevelSelectViewController.swift
//  JapanIceTea
//
//  Created by Antonio Terrano on 07/02/18.
//  Copyright © 2018 Antonio Terrano. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // spazio minimo tra le celle
    final let cellSpacing: CGFloat = 20
    var isIphone: Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //to play audio
    let avPlayer = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.view.backgroundColor = WorldsDataManager.shared.colorBackground
        self.collectionView.backgroundColor = WorldsDataManager.shared.colorBackground
        
        //Size Check se è un iphone o è un ipad!
        if self.view.bounds.width < 1000 {
            self.isIphone = true
        }
        
        //CollectionView FlowLayout
        let collectionViewFlowLayot = UICollectionViewFlowLayout()
        collectionViewFlowLayot.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
        collectionViewFlowLayot.minimumLineSpacing = 50
        collectionViewFlowLayot.headerReferenceSize = CGSize(width: 50, height: 50)
        collectionViewFlowLayot.footerReferenceSize = CGSize(width: 50, height: 50)
        if isIphone {
            collectionViewFlowLayot.scrollDirection = .horizontal
            
        } else {
            collectionViewFlowLayot.scrollDirection = .vertical
        }
        
        self.collectionView.setCollectionViewLayout(collectionViewFlowLayot, animated: true)
        
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
        
        //hides the navigation controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if !avPlayer.isPlaying {
            //plays music menu
            self.avPlayer.playMusic(file: "menuMusic", ext: "wav")
        }
    }
    
    //Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorldsDataManager.shared.worlds.count + 1
    }
    
    //Size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        if isIphone {
            
            //return CGSize(width: screenSize.width / 3, height: screenSize.height / 2 + 50)
            return CGSize(width: 300, height: 300)
        } else {
            return CGSize(width: 300, height: 300)
        //     return CGSize(width: screenSize.width / 4, height: screenSize.height / 3)
        }
    }
    
    //Cells settings
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorldCell", for: indexPath) as! WorldCollectionViewCell
    
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 35
        
        cell.labelCell.textColor = .black
        cell.backgroundColor = WorldsDataManager.shared.colorCell
        
        cell.icoCell.contentMode = UIViewContentMode.scaleAspectFill
        
        if indexPath.item == 0 {
            //AddNewWorld cell
            cell.icoCell.image = #imageLiteral(resourceName: "add")
            cell.labelCell.text = "Add"
            
        }
        else {
            //World cell
            cell.labelCell.text = WorldsDataManager.shared.worlds[indexPath.item - 1].nameWorld
            cell.icoCell.image = WorldsDataManager.shared.icons[WorldsDataManager.shared.worlds[indexPath.item - 1].icoWorld!]
        }
        
        return cell
    }
    
    
    //Segue to SettingsCollectionView
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "levelToSettings", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.collectionView!.indexPathsForSelectedItems![0] as NSIndexPath
        let settingsVC = segue.destination as! SettingsViewController
        
        if indexPath.item == 0 {
            settingsVC.isInitial = true
        }
        settingsVC.selectedWorld = indexPath.item - 1
    }
}
