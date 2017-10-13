//
//  ViewController.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var homeCV: UICollectionView!
    
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    
    private(set) public var homes: Dictionary<String, [Home]> = Dictionary<String, [Home]>()
    var deviceType: DeviceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        //print(deviceType)
        
        homeCV.delegate = self
        homeCV.dataSource = self
        
        DataService.instance.getHomes { (success) in
            if success {
                self.homes = DataService.instance.homes
                self.homeCV.reloadData()
            }
            self.removeSpinner()
            self.removeProgressLbl()
        }
        addSpinner()
        addProgressLbl()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print(frameWidth)
        let cellCount: Int = deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        let cellWidth: CGFloat = (frameWidth! / CGFloat(cellCount)) - CGFloat(CELL_EDGE_MARGIN*2)
        //let cellWidth: CGFloat = (frameWidth! / CGFloat(cellCount))
        //let cellHeight:CGFloat = CGFloat(deviceType == .iPhone7 ? (TITLE_HEIGHT+FEATURED_HEIGHT+CELL_EDGE_MARGIN) : (TITLE_HEIGHT+FEATURED_HEIGHT*2+CELL_EDGE_MARGIN))
        let cellHeight: CGFloat = cellWidth * 0.75
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return homes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 30.0, right: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = indexToKey(index: section).key
        let number: Int = homes[key]!.count
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionHeaderView", for: indexPath) as? HomeCollectionHeaderView {
                let headerTitle = indexToKey(index: indexPath.section).chTitle
                headerView.titleLbl.text = headerTitle
                return headerView
            } else {
                return UICollectionReusableView()
            }
        default:
            assert(false, "collection header failed")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("cellForItemAt section: \(indexPath.section) row: \(indexPath.row)")
        let key = indexToKey(index: indexPath.section).key
        let home = homes[key]![indexPath.row]
        if home.vimeo.count > 0 || home.youtube.count > 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoCell", for: indexPath) as? HomeVideoCell {
                cell.updateViews(home: home)
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCell", for: indexPath) as? HomeImageCell {
                cell.updateViews(home: home)
                
                return cell
            }
        }
        return HomeImageCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("will display section: \(indexPath.section) row: \(indexPath.row)")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("end display section: \(indexPath.section) row: \(indexPath.row)")
//    }
    
    
    func indexToKey(index: Int) -> (key: String, chTitle: String) {
        var key: String
        var chTitle: String
        switch index {
        case 0:
            key = "courses"
            chTitle = "課程"
            break
        case 1:
            key = "news"
            chTitle = "新聞"
            break
        case 2:
            key = "arenas"
            chTitle = "球館"
            break
        default:
            key = "courses"
            chTitle = "課程"
        }
        
        return (key, chTitle)
    }
    

    func addSpinner() {
        spinner = UIActivityIndicatorView()
        //spinner?.center = CGPoint(x: (homeCV.bounds.width / 2) - ((spinner?.bounds.width)! / 2), y: homeCV.bounds.height / 2)
        spinner?.center = self.view.center
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
        spinner?.startAnimating()
        homeCV.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLbl() {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: self.view.center.x - 100, y: self.view.center.y + 20, width: 200, height: 40)
        progressLbl?.font = UIFont(name: "Avenir Next", size: 18)
        progressLbl?.textColor = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
        progressLbl?.textAlignment = .center
        progressLbl?.text = "努力加載中..."
        homeCV.addSubview(progressLbl!)
    }

    func removeProgressLbl() {
        if progressLbl != nil {
            progressLbl?.removeFromSuperview()
        }
    }

}

