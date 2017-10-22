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
    var iden: String!
    internal(set) public var lists: [List] = [List]()
    lazy var cellCount: CGFloat = {
        let count: Int = self.deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        return CGFloat(count)
    }()
    override func viewDidLoad() {
        //print("super: \(self)")
        super.viewDidLoad()
        
        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CELL_EDGE_MARGIN
        listCV = UICollectionView(frame: CGRect(x: 0, y: 64, width: 375, height: 800), collectionViewLayout: layout)
        //print(listCV)
        listCV.register(TeamCell.self, forCellWithReuseIdentifier: iden+"Cell")
        listCV.delegate = self
        listCV.dataSource = self
        self.view.addSubview(listCV)
        Global.instance.addSpinner(center: self.view.center, superView: listCV)
        Global.instance.addProgressLbl(center: self.view.center, superView: listCV)
        
        //var list = List(id: 0, title: "title1", path: "", token: "")
        //list.featured = UIImage(named: "1.png")!
        //lists.append(list)
        //print(lists)
        //listCV.reloadData()
    }
    
    func setIden(item: String) {
        iden = item
    }
    
    func getData(type: String, titleField: String) {
        DataService.instance.getList(type: type, titleField: titleField) { (success) in
            if success {
                self.lists = DataService.instance.lists
                //print(self.lists)
                self.listCV.reloadData()
            }
            Global.instance.removeSpinner()
            Global.instance.removeProgressLbl()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let list = lists[indexPath.row]
        let imageWidth = list.featured.size.width
        let imageHeight = list.featured.size.height
        //print("image width: \(imageWidth), height: \(imageHeight)")
        
        //print("cell count: \(cellCount)")
        cellWidth = (frameWidth!-(20*(cellCount-1))) / cellCount
        //print("cell width: \(cellWidth)")
        
        var cellHeight: CGFloat = TITLE_HEIGHT
        if imageWidth < cellWidth - CELL_EDGE_MARGIN*2 {
            cellHeight += imageHeight
        } else {
            cellHeight += (imageHeight/imageWidth) * (cellWidth-(CELL_EDGE_MARGIN*2))
        }
        cellHeight += CELL_EDGE_MARGIN
        //print("cell width: \(cellWidth), height: \(cellHeight)")
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //print("aaa")
        return lists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let list = lists[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iden+"Cell", for: indexPath) as? TeamCell {
//            if indexPath.row == 0 {
//                print(list)
//            }
            let image = list.featured
            let imageWidth: CGFloat = image.size.width
            let imageHeight: CGFloat = image.size.height
            
            let width: CGFloat = cellWidth! - CELL_EDGE_MARGIN*2
            var height: CGFloat!
            if imageWidth < width {
                height = imageHeight
            } else {
                height = (imageHeight/imageWidth) * (cellWidth-CELL_EDGE_MARGIN*2)
            }
            
            let frame: CGRect = cell.featured.frame
            //print("featured frame: \(frame)")
            cell.featured.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
            cell.updateViews(list: list)
            
            return cell
        }
        return HomeImageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list: List = lists[indexPath.row]
        performSegue(withIdentifier: "ListShowSegue", sender: list)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showVC: ShowVC = segue.destination as? ShowVC {
            assert(sender as? List != nil)
            let list: List = sender as! List
            let show_in: Show_IN = Show_IN(type: iden, id: list.id, token: list.token)
            showVC.initShowVC(sin: show_in)
        }
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
        /*print("_init self: \(self)")
        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        //print("frame width: \(frameWidth), height: \(frameHeight)")
        
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CELL_EDGE_MARGIN
        listCV = UICollectionView(frame: CGRect(x: 0, y: 64, width: frameWidth, height: frameHeight-64), collectionViewLayout: layout)
        listCV.register(TeamCell.self, forCellWithReuseIdentifier: "ListCell")
        
        listCV.delegate = self
        listCV.dataSource = self
        self.view.addSubview(listCV)*/
//        Global.instance.addSpinner(center: self.view.center, superView: listCV)
//        Global.instance.addProgressLbl(center: self.view.center, superView: listCV)
//        DataService.instance.getList(type: type, titleField: "name") { (success) in
//            if success {
//                self.lists = DataService.instance.lists
//                //print(self.lists)
//                self.listCV.reloadData()
//            }
//            //Global.instance.removeSpinner()
//            //Global.instance.removeProgressLbl()
//        }
    }
}
