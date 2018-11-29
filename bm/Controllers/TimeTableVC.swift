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
    
    var token: String = ""
    var source: String = ""
    var timeTable: TimeTable = TimeTable()
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat = 50
    let cellBorderWidth: CGFloat = 1
    
    let startNum: Int = 6
    let endNum: Int = 23
    let columnNum: Int = 8
    
    var v: UIView = UIView(frame: CGRect.zero)
    var eventViews: [UIView] = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if source == "coach" {
            dataService = CoachService.instance
        }
        
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        cellWidth = screenWidth/CGFloat(columnNum)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView!.collectionViewLayout = layout
        
//        v.frame = CGRect(x: cellWidth+cellBorderWidth, y: cellHeight+cellBorderWidth, width: cellWidth-2*cellBorderWidth, height: cellHeight-2*cellBorderWidth)
//        v.backgroundColor = UIColor.red
        collectionView.addSubview(v)
        
        refresh()
    }
    
    func markEvent() {
        for i in 0 ... timeTable.rows.count-1 {
            let row = timeTable.rows[i]
            let x: CGFloat = CGFloat(row.day) * cellWidth + cellBorderWidth
            let y: CGFloat = CGFloat(row._start-startNum) * cellHeight + cellBorderWidth
            let width: CGFloat = cellWidth - 2 * cellBorderWidth
            let gridNum: CGFloat = CGFloat(row._end-row._start)
            let height: CGFloat = gridNum * cellHeight - 2 * cellBorderWidth
            let frame = CGRect(x: x, y: y, width: width, height: height)
            let v: UIView = UIView(frame: frame)
            v.backgroundColor = row._color.toColor()
            v.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickEvent))
            v.addGestureRecognizer(tap)
            
            collectionView.addSubview(v)
            eventViews.append(v)
        }
    }
    
    @objc func clickEvent(sender: UITapGestureRecognizer) {
        guard let a = (sender.view as? UIView) else {return}
        let idx: Int = a.tag
        print(idx)
        //blacklistCellDelegate?.call(position: position)
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        dataService.getTT(token: token, type: source) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                self.timeTable = self.dataService.timeTable
                //self.collectionView.reloadData()
                self.markEvent()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (endNum-startNum)*columnNum
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        return CGSize(width: screen, height: <#T##Double#>)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let startTime: Int = indexPath.row / columnNum + startNum
        let weekday: Int = indexPath.row % columnNum
        
        let contentView = cell.contentView
        contentView.layer.borderWidth = cellBorderWidth
        contentView.layer.borderColor = UIColor.gray.cgColor
//        for row in timeTable.rows {
//            if startTime >= row._start && startTime < row._end && weekday == row.day {
//                contentView.backgroundColor = row._color.toColor()
//            }
//        }
        
        let timeLabel = cell.contentView.subviews[0] as! UILabel
        
        if weekday == 0 {
            timeLabel.text = "\(startTime)-\(startTime+1)"
        } else {
            timeLabel.text = ""
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startTime: Int = indexPath.row / columnNum + startNum
        let weekday: Int = indexPath.row % columnNum
        print("\(weekday)-\(startTime)")
    }
    
    @IBAction func addTimeTableBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}












