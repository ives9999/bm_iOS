//
//  ListVC.swift
//  bm
//
//  Created by ives on 2017/10/19.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

internal let reuseIdentifier = "Cell"

class ListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    internal var listCV: UICollectionView!
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    var cellWidth: CGFloat!
    var deviceType: DeviceType!
    internal(set) public var lists: [List] = [List]()
    lazy var cellCount: CGFloat = {
        let count: Int = self.deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        return CGFloat(count)
    }()
    override func viewDidLoad() {
        print("super: \(self)")
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("aaa")
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension ListVC {
    func _init(type: String) {
        print("_init self: \(self)")
        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        //print("frame width: \(frameWidth), height: \(frameHeight)")
        
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        //print(deviceType)
        
        //        let cellCount: Int = deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        //        let cellWidth: CGFloat = frameWidth! / CGFloat(cellCount)
        //        print(cellWidth)
        
        //let frame = teamCV.frame
        //print(frame)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CELL_EDGE_MARGIN
        listCV = UICollectionView(frame: CGRect(x: 0, y: 64, width: frameWidth, height: frameHeight-64), collectionViewLayout: layout)
        listCV.register(TeamCell.self, forCellWithReuseIdentifier: "ListCell")
        
        listCV.delegate = self
        listCV.dataSource = self
        self.view.addSubview(listCV)
        Global.instance.addSpinner(center: self.view.center, superView: listCV)
        Global.instance.addProgressLbl(center: self.view.center, superView: listCV)
        DataService.instance.getList(type: type, titleField: "name") { (success) in
            if success {
                self.lists = DataService.instance.lists
                //print(self.lists)
                self.listCV.reloadData()
            }
            //Global.instance.removeSpinner()
            //Global.instance.removeProgressLbl()
        }
    }
}
