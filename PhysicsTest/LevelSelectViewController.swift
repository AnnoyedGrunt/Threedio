//
//  LevelSelectViewController.swift
//  JapanIceTea
//
//  Created by Antonio Terrano on 07/02/18.
//  Copyright © 2018 Antonio Terrano. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    final let cellSpacing: CGFloat = 10
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //to play audio
    let avPlayer = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //CollectionView FlowLayout
        let collectionViewFlowLayot = UICollectionViewFlowLayout()
        collectionViewFlowLayot.scrollDirection = .vertical
        collectionViewFlowLayot.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
        collectionViewFlowLayot.minimumInteritemSpacing = 10
        collectionViewFlowLayot.minimumLineSpacing = 80
        collectionViewFlowLayot.headerReferenceSize = CGSize(width: 30, height: 50)
        collectionViewFlowLayot.footerReferenceSize = CGSize(width: 30, height: 50)
        
        collectionView.setCollectionViewLayout(collectionViewFlowLayot, animated: true)
        self.view.backgroundColor = WorldsDataManager.shared.colorBackground
        self.collectionView.backgroundColor = WorldsDataManager.shared.colorBackground
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
        
        if !avPlayer.isPlaying {
            //plays music menu
            self.avPlayer.playSound(file: "menuMusic", ext: "wav")
        }
    }
    
    //Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorldsDataManager.shared.worlds.count + 1
    }
    
    //Size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width / 4, height: screenSize.height / 3)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "levelToSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.collectionView!.indexPathsForSelectedItems![0] as NSIndexPath
        let settingsVC = segue.destination as! SettingsViewController
        
        if indexPath.item == 0 {
            settingsVC.isInitial = true
        }
        settingsVC.selectedWorld = indexPath.item - 1
    }
}
