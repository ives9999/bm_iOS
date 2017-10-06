//
//  ViewController.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var homeCV: UICollectionView!
    
    private(set) public var homes = [Home]()
    private(set) public var frameWidth: CGFloat!
    var deviceType: DeviceType!
    let iPhoneCellOnRow: Int = 1
    let iPadCellOnRow:Int = 2
    let cellEdgeMargin: Int = 5
    let titleHeight: Int = 60
    let featuredHeight: Int = 180
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameWidth = view.frame.width
        
        //print(UIDevice.current.userInterfaceIdiom)
        
        deviceType = UIDevice.current.deviceType
        if (deviceType == .simulator) {
            deviceType = (frameWidth >= 500) ? .iPad : .iPhone7
        } else {
            //let tmp: String = UIDevice.current.deviceType.displayName
        }
        print(deviceType)
        
        homeCV.delegate = self
        homeCV.dataSource = self
        
        homes = DataService.instance.getHomes()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print(frameWidth)
        let cellCount: Int = deviceType == .iPhone7 ? iPhoneCellOnRow : iPadCellOnRow
        let cellWidth: CGFloat = (frameWidth / CGFloat(cellCount)) - CGFloat(cellEdgeMargin*2)
        let cellHeight:CGFloat = CGFloat(deviceType == .iPhone7 ? (titleHeight+featuredHeight+cellEdgeMargin) : (titleHeight+featuredHeight*2+cellEdgeMargin))
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

