//
//  ListVC.swift
//  bm
//
//  Created by ives on 2017/10/19.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift
import UIColor_Hex_Swift

internal let reuseIdentifier = "Cell"

class ListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    internal var listCV: UICollectionView!
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    var cellWidth: CGFloat!
    var deviceType: DeviceType!
    var iden: String!
    var titleField: String!
    var page: Int = 1
    var perPage: Int = PERPAGE
    var totalCount: Int = 100000
    var totalPage: Int = 1
    internal(set) public var lists: [List] = [List]()
    lazy var cellCount: CGFloat = {
        let count: Int = self.deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        return CGFloat(count)
    }()
    //var spinner: UIActivityIndicatorView?
    //var progressLbl: UILabel?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        //print("super: \(self)")
        super.viewDidLoad()
        
        frameWidth = view.bounds.size.width
        //print("frame width: \(frameWidth)")
        frameHeight = view.bounds.size.height
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CELL_EDGE_MARGIN
        listCV = UICollectionView(frame: CGRect(x: 0, y: 84, width: frameWidth, height: frameHeight), collectionViewLayout: layout)
        //print(listCV)
        listCV.register(ListCellBK.self, forCellWithReuseIdentifier: iden+"ImageCell")
        listCV.register(VideoCell.self, forCellWithReuseIdentifier: iden+"VideoCell")
        listCV.delegate = self
        listCV.dataSource = self

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        listCV.addSubview(refreshControl)
        
        self.view.addSubview(listCV)
        
        //var list = List(id: 0, title: "title1", path: "", token: "")
        //list.featured = UIImage(named: "1.png")!
        //lists.append(list)
        //print(lists)
        //listCV.reloadData()
    }
    
    func setIden(item: String, titleField: String) {
        self.iden = item
        self.titleField = titleField
    }
    
    func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.getList(type: iden, titleField: titleField, page: page, perPage: perPage, filter: nil) { (success) in
            if (success) {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    func getDataEnd(success: Bool) {
        if success {
            let tmps: [List] = TeamService.instance.dataLists
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists = [List]()
            }
            lists += tmps
            //print(self.lists)
            page = TeamService.instance.page
            if page == 1 {
                totalCount = TeamService.instance.totalCount
                perPage = TeamService.instance.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(self.totalPage)
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            listCV.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize!
        let list = lists[indexPath.row]
        
        //print("cell count: \(cellCount)")
        cellWidth = (frameWidth!-(CELL_EDGE_MARGIN*2*(cellCount-1))) / cellCount
        //print("cell width: \(cellWidth!)")
        var cellHeight: CGFloat
        
        if list.vimeo.count == 0 && list.youtube.count == 0 {
            let imageWidth = list.featured.size.width
            let imageHeight = list.featured.size.height
            //print("image width: \(imageWidth), height: \(imageHeight)")
            
            cellHeight = TITLE_HEIGHT
            if imageWidth < cellWidth - CELL_EDGE_MARGIN*2 {
                cellHeight += imageHeight
            } else {
                cellHeight += (imageHeight/imageWidth) * (cellWidth-(CELL_EDGE_MARGIN*2))
            }
            //cellHeight += cellWidth * 0.75
            cellHeight += CELL_EDGE_MARGIN
            //print("cell width: \(cellWidth), height: \(cellHeight)")
            size = CGSize(width: cellWidth, height: cellHeight)
        } else {
            cellHeight = (cellWidth - CELL_EDGE_MARGIN * 2) * 0.75 + CELL_EDGE_MARGIN * 2
            size = CGSize(width: cellWidth, height: cellHeight)
            //print("cell_width: \(cellWidth), cell_height: \(cellHeight)")
        }
        //print("cell width: \(cellWidth!), height: \(cellHeight)")
        return size
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 30.0, right: 5.0)
//    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //print(lists.count)
        return lists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let list = lists[indexPath.row]
        if list.vimeo.count > 0 || list.youtube.count > 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iden+"VideoCell", for: indexPath) as? VideoCell {
                cell.updateViews(list: list)
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iden+"ImageCell", for: indexPath) as? ListCellBK {
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
            let show_in: Show_IN = Show_IN(type: iden, id: list.id, token: list.token)
            showVC.initShowVC(sin: show_in)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("will display section: \(indexPath.section) row: \(indexPath.row)")
        if indexPath.row == page * PERPAGE - 2 {
            page += 1
            //print("current page: \(page)")
            if page <= totalPage {
                getDataStart(page: page, perPage: PERPAGE)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("end display section: \(indexPath.section) row: \(indexPath.row)")
    }
    
    @objc func refresh() {
        self.page = 1
        getDataStart()
    }
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.size.height {
//            numberOfItemsPerSection += 6
//            self.collectionView.reloadData()
//        }
//    }

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


