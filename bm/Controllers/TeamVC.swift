//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class TeamVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //@IBOutlet weak var teamCV: UICollectionView!
    var listCV: UICollectionView!
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    var cellWidth: CGFloat!
    var deviceType: DeviceType!
    private(set) public var lists: [List] = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        //print("frame width: \(frameWidth), height: \(frameHeight)")
        
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
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
        
        DataService.instance.getList(type: "team", titleField: "name") { (success) in
            if success {
                self.lists = DataService.instance.lists
                //print(self.teams)
                self.listCV.reloadData()
            }
            Global.instance.removeSpinner()
            Global.instance.removeProgressLbl()
        }
        Global.instance.addSpinner(center: self.view.center, superView: listCV)
        Global.instance.addProgressLbl(center: self.view.center, superView: listCV)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let list = lists[indexPath.row]
        let imageWidth = list.featured.size.width
        let imageHeight = list.featured.size.height
        //print("image width: \(imageWidth), height: \(imageHeight)")
        //print(frameWidth)
        let cellCount: Int = deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        cellWidth = frameWidth! / CGFloat(cellCount)
        //let cellWidth: CGFloat = (frameWidth! / CGFloat(cellCount))
        //let cellHeight:CGFloat = CGFloat(deviceType == .iPhone7 ? (TITLE_HEIGHT+FEATURED_HEIGHT+CELL_EDGE_MARGIN) : (TITLE_HEIGHT+FEATURED_HEIGHT*2+CELL_EDGE_MARGIN))
        //let cellHeight: CGFloat = cellWidth * 0.75
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let list = lists[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? TeamCell {
            let image = list.featured
            let imageWidth: CGFloat = image.size.width
            let imageHeight: CGFloat = image.size.height
            
            var height: CGFloat!
            if imageWidth < cellWidth - CELL_EDGE_MARGIN*2 {
                height = imageHeight
            } else {
                height = (imageHeight/imageWidth) * (cellWidth-CELL_EDGE_MARGIN*2)
            }
            
            let frame: CGRect = cell.featured.frame
            cell.featured.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
            cell.updateViews(list: list)
                
            return cell
        }
        return HomeImageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list: List = lists[indexPath.row]
        performSegue(withIdentifier: "TeamShowSegue", sender: list)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showVC: ShowVC = segue.destination as? ShowVC {
            assert(sender as? List != nil)
            let list: List = sender as! List
            let show_in: Show_IN = Show_IN(type: "team", id: list.id, token: list.token)
            showVC.initShowVC(sin: show_in)
        }
    }
}
