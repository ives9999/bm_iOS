//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class TeamVC: ListVC {
//class TeamVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let _type:String = "team"
    //internal var listCV: UICollectionView!
    //var frameWidth: CGFloat!
    //var frameHeight: CGFloat!
    //var cellWidth: CGFloat!
    //var deviceType: DeviceType!
    //internal(set) public var lists: [List] = [List]()
//    lazy var cellCount: CGFloat = {
//        let count: Int = self.deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
//        return CGFloat(count)
//    }()
    
    
    override func viewDidLoad() {
        //print("self: \(self)")
        //print("super: \(super)")
        setIden(item:_type)
        super.viewDidLoad()
        //self._init(type: _type)
        //frameWidth = view.bounds.size.width
        //frameHeight = view.bounds.size.height
        //print("frame width: \(frameWidth), height: \(frameHeight)")
        
        //deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
        let l: UILabel = UILabel(frame: CGRect(x: 0, y:100, width: 100, height: 100))
        l.text = "label"
        l.textColor = UIColor.white
        //self.view.addSubview(l)
        
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = CELL_EDGE_MARGIN
//        listCV = UICollectionView(frame: CGRect(x: 0, y: 64, width: 375, height: 800), collectionViewLayout: layout)
//        listCV.register(TeamCell.self, forCellWithReuseIdentifier: "ListCell")
        
//        listCV.delegate = self
//        listCV.dataSource = self
//        self.view.addSubview(listCV)
        
//        var list = List(id: 0, title: "title1", path: "", token: "")
//        list.featured = UIImage(named: "1.png")!
//        lists.append(list)
//        print(lists)
//        listCV.reloadData()
        getData(type: _type, titleField: "name")
        
//        DataService.instance.getList(type: _type, titleField: "name") { (success) in
//            if success {
//                self.lists = DataService.instance.lists
//                print(self.lists)
//                self.listCV.reloadData()
//            }
//            Global.instance.removeSpinner()
//            Global.instance.removeProgressLbl()
//        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let list = lists[indexPath.row]
//        let imageWidth = list.featured.size.width
//        let imageHeight = list.featured.size.height
//        //print("image width: \(imageWidth), height: \(imageHeight)")
//
//        //print("cell count: \(cellCount)")
//        cellWidth = (frameWidth!-(20*(cellCount-1))) / cellCount
//        //print("cell width: \(cellWidth)")
//
//        var cellHeight: CGFloat = TITLE_HEIGHT
//        if imageWidth < cellWidth - CELL_EDGE_MARGIN*2 {
//            cellHeight += imageHeight
//        } else {
//            cellHeight += (imageHeight/imageWidth) * (cellWidth-(CELL_EDGE_MARGIN*2))
//        }
//        cellHeight += CELL_EDGE_MARGIN
//        //print("cell width: \(cellWidth), height: \(cellHeight)")
//        let size = CGSize(width: cellWidth, height: cellHeight)
//        return size
//    }

    /*override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        print("bbb")
        return lists.count
    }*/

    /*override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let list = lists[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? TeamCell {
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
    }*/

    
}
