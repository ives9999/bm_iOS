//
//  ViewController.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var homeCV: UICollectionView!
    
    private(set) public var homes = [Home]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCV.delegate = self
        homeCV.dataSource = self
        
        homes = DataService.instance.getHomes()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return homes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell {
            let home = homes[indexPath.row]
            cell.updateViews(home: home)
            
            return cell
        }
        
        return HomeCell()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

