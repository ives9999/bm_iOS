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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._init(type: _type)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return lists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
