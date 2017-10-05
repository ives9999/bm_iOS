//
//  ViewController.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var homeCV: UICollectionView!
    
    private(set) public var homes = [Home]()
    private(set) public var frameWidth: CGFloat?
    //var deviceType: DeviceType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameWidth = view.frame.width
        
//        switch UIDevice.current.userInterfaceIdiom {
//        case .phone:
//            type = "phone"
//        case .pad:
//            type = "pad"
//        case .unspecified:
//            type = "phone"
//        }
        
        homeCV.delegate = self
        homeCV.dataSource = self
        
        homes = DataService.instance.getHomes()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print(frameWidth)
        let cellCount = (CGFloat)(UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2)
        let cellWidth = frameWidth! / cellCount - 10
        let cellHeight = (CGFloat)(UIDevice.current.userInterfaceIdiom == .phone ? 245 : 425)
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
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

