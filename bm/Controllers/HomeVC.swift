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
    
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    
    private(set) public var homes: Dictionary<String, [Home]> = Dictionary<String, [Home]>()
    var deviceType: DeviceType!
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner = UIActivityIndicatorView()
        progressLbl = UILabel()

        frameWidth = view.bounds.size.width
        frameHeight = view.bounds.size.height
        
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        //print(deviceType)
        
        homeCV.delegate = self
        homeCV.dataSource = self
        
        TeamService.instance.getHomes { (success) in
            if success {
                self.homes = TeamService.instance.homes
                self.homeCV.reloadData()
            }
            Global.instance.removeSpinner(superView: self.view)
        }
        Global.instance.addSpinner(superView: self.view)
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
        let key: String = TeamService.instance.sectionToKey(section: section).key
        let number: Int = homes[key]!.count
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionHeaderView", for: indexPath) as? HomeCollectionHeaderView {
                let headerTitle = TeamService.instance.sectionToKey(section: indexPath.section).chTitle
                headerView.titleLbl.text = headerTitle
                return headerView
            } else {
                return UICollectionReusableView()
            }
        default:
            assert(false, "collection header failed")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("cellForItemAt section: \(indexPath.section) row: \(indexPath.row)")
        let home = TeamService.instance.getHomeItem(indexPath: indexPath)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let home: Home = TeamService.instance.getHomeItem(indexPath: indexPath)
            //print(home)
            performSegue(withIdentifier: "ShowSegue", sender: home)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showVC: ShowVC = segue.destination as? ShowVC {
            assert(sender as? Home != nil)
            let home: Home = sender as! Home
            let show_in: Show_IN = Show_IN(type: home.type, id: home.id, token: home.token)
            showVC.initShowVC(sin: show_in)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("will display section: \(indexPath.section) row: \(indexPath.row)")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("end display section: \(indexPath.section) row: \(indexPath.row)")
//    }   

}

