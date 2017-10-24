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
        setIden(item:_type, titleField: "name")
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
        getData()
        
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
    
}
