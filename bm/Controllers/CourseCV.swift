//
//  CourseCV.swift
//  bm
//
//  Created by ives on 2017/10/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class CourseCV: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        super.viewDidLoad()
        
        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CELL_EDGE_MARGIN
        listCV = UICollectionView(frame: CGRect(x: 0, y: 64, width: 375, height: 800), collectionViewLayout: layout)
        //print(listCV)
        listCV.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
        listCV.register(HomeVideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        listCV.delegate = self
        listCV.dataSource = self
        self.view.addSubview(listCV)
        Global.instance.addSpinner(center: self.view.center, superView: listCV)
        Global.instance.addProgressLbl(center: self.view.center, superView: listCV)
        DataService.instance.getList(type: "course", titleField: "title") { (success) in
            if success {
                self.lists = DataService.instance.lists
                //print(self.lists)
                self.listCV.reloadData()
            } else {
                let l: UILabel = UILabel(frame: CGRect(x: 30, y:100, width: 500, height: 100))
                l.text = "取得資料錯誤"
                l.textColor = UIColor.white
                self.view.addSubview(l)
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
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let list = lists[indexPath.row]
        if list.vimeo.count > 0 || list.youtube.count > 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? HomeVideoCell {
                cell.updateViews1(list: list)
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell {
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
        }
        return HomeImageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list: List = lists[indexPath.row]
        if list.vimeo.count == 0 && list.youtube.count == 0 {
            performSegue(withIdentifier: "ListShowSegue", sender: list)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showVC: ShowVC = segue.destination as? ShowVC {
            assert(sender as? List != nil)
            let list: List = sender as! List
            let show_in: Show_IN = Show_IN(type: "course", id: list.id, token: list.token)
            showVC.initShowVC(sin: show_in)
        }
    }
}
