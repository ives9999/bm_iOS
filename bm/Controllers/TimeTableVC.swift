//
//  TimeTableVC.swift
//  bm
//
//  Created by ives on 2018/11/24.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class TimeTableVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    let startNum: Int = 6
    let endNum: Int = 23
    let column: Int = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: screenWidth/CGFloat(column), height: screenWidth/CGFloat(column))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (endNum-startNum)*column
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        return CGSize(width: screen, height: <#T##Double#>)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let contentView = cell.contentView
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        
        let timeLabel = cell.contentView.subviews[0] as! UILabel
        
        let rowNum: Int = indexPath.row / column
        if indexPath.row % column == 0 {
            let first = startNum + rowNum
            let second = first + 1
            timeLabel.text = "\(first)-\(second)"
        } else {
            timeLabel.text = ""
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startTime: Int = indexPath.row / column + startNum
        let weekday: Int = indexPath.row % column
        //print("\(weekday)-\(startTime)")
    }
    
    @IBAction func addTimeTableBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}












