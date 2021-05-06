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

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, EditCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
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
    var textHeight: CGFloat = TITLE_HEIGHT
    internal(set) public var lists: [SuperData] = [SuperData]()
    lazy var cellCount: CGFloat = {
        let count: Int = self.deviceType == .iPhone7 ? IPHONE_CELL_ON_ROW : IPAD_CELL_ON_ROW
        return CGFloat(count)
    }()
    var testLabel: UILabel = UILabel(frame: CGRect.zero)
    //var spinner: UIActivityIndicatorView?
    //var progressLbl: UILabel?
    
    var refreshControl: UIRefreshControl!
    var dataService: DataService = DataService.instance1
    
    let maskView = UIView()
    var newY: CGFloat = 0
    let padding: CGFloat = 20
    let headerHeight: CGFloat = 84
    var tableViewBoundHeight: CGFloat = 0
    var layerHeight: CGFloat = 0
    let containerView = UIView(frame: .zero)
    let searchTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    let searchSubmitBtn: SubmitButton = SubmitButton()
    var searchRows: [[String: Any]] = [[String: Any]]()
    var params: [String: Any] = [String: Any]()
    
    var keyword: String = ""
    
    var searchPanelisHidden = true
    
    override func viewDidLoad() {
        //print("super: \(self)")
        super.viewDidLoad()
        
        frameWidth = view.bounds.size.width
        //print("frame width: \(frameWidth)")
        frameHeight = view.bounds.size.height
        deviceType = Global.instance.deviceType(frameWidth: frameWidth!)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        collectionView!.collectionViewLayout = layout
        //layout.minimumInteritemSpacing = CELL_EDGE_MARGIN
        //collectionView = UICollectionView(frame: CGRect(x: 0, y: 84, width: frameWidth, height: frameHeight), collectionViewLayout: layout)
        //print(listCV)
        //collectionView.register(CollectionCell1.self, forCellWithReuseIdentifier: iden+"ImageCell")
        //collectionView.register(VideoCell.self, forCellWithReuseIdentifier: iden+"VideoCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
        
        self.view.addSubview(collectionView)
        
        let myFont: UIFont! = UIFont(name: FONT_NAME, size: CGFloat(FONT_SIZE_TITLE))
        textHeight = "測試".height(font: myFont)
        
        //print("cell count: \(cellCount)")
        cellWidth = (frameWidth!-(CELL_EDGE_MARGIN*2*(cellCount-1))) / cellCount
        testLabelReset()
        testLabel.numberOfLines = 0
        //print("cell width: \(cellWidth!)")
        
        let cellNibName = UINib(nibName: "CollectionCell", bundle: nil)
        collectionView.register(cellNibName, forCellWithReuseIdentifier: "CollectionCell")
//        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowlayout.estimatedItemSize = CGSize(width: cellWidth, height: 1)
//        }
        
        tableViewBoundHeight = view.bounds.height - 64
        layerHeight = tableViewBoundHeight - 100
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        let editCellNib = UINib(nibName: "EditCell", bundle: nil)
        searchTableView.register(editCellNib, forCellReuseIdentifier: "search_cell")
    }
    
    func setIden(item: String, titleField: String) {
        self.iden = item
        self.titleField = titleField
    }
    
    func prepareParams(city_type: String="simple") {
        params["k"] = keyword
    }
    
    func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
//        dataService.getList(type: iden, titleField: titleField, params:params, page: page, perPage: perPage, filter: nil) { (success) in
//            if (success) {
//                self.getDataEnd(success: success)
//                Global.instance.removeSpinner(superView: self.view)
//            }
//        }
    }
    func getDataEnd(success: Bool) {
        if success {
            let tmps: [SuperData] = dataService.dataLists
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists = [SuperData]()
            }
            lists += tmps
            //print(self.lists)
            page = dataService.page
            if page == 1 {
                totalCount = dataService.totalCount
                perPage = dataService.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(self.totalPage)
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            collectionView.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //print(lists.count)
        return lists.count
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var size: CGSize!
//        let data = lists[indexPath.row]
//        
//        testLabelReset()
//        testLabel.text = data.title
//        testLabel.sizeToFit()
//        let lineCount = getTestLabelLineCount(textCount: data.title.count)
//        //let lineNum: Int = Int((testLabel.frame.size.height / textHeight).rounded(FloatingPointRoundingRule.up))
//        
////        print("3.\(indexPath.row):\(lineCount)")
////        print("3.\(indexPath.row):\(textHeight)")
////        print("3.\(indexPath.row):\(testLabel.frame.size.height)")
//        let titleLblHeight = textHeight * CGFloat(lineCount)
//        
//        let featured = data.featured
//        let w = featured.size.width
//        let h = featured.size.height
//        let aspect = w / h
//        let featuredViewHeight = cellWidth / aspect
//        
//        var cellHeight: CGFloat
//        cellHeight = titleLblHeight + featuredViewHeight + textHeight + 4*CELL_EDGE_MARGIN
//        //print("\(indexPath.row).\(cellHeight)")
//        size = CGSize(width: cellWidth, height: cellHeight)
//        //print("3.\(indexPath.row):\(titleLblHeight)")
//        //print("3.\(indexPath.row):\(featuredViewHeight)")
//        //print("3.\(indexPath.row):\(cellHeight)")
//        
////        if list.vimeo.count == 0 && list.youtube.count == 0 {
////            let imageWidth = list.featured.size.width
////            let imageHeight = list.featured.size.height
////            //print("image width: \(imageWidth), height: \(imageHeight)")
////
////            cellHeight = TITLE_HEIGHT
////            if imageWidth < cellWidth - CELL_EDGE_MARGIN*2 {
////                cellHeight += imageHeight
////            } else {
////                cellHeight += (imageHeight/imageWidth) * (cellWidth-(CELL_EDGE_MARGIN*2))
////            }
////            //cellHeight += cellWidth * 0.75
////            cellHeight += CELL_EDGE_MARGIN
////            //print("cell width: \(cellWidth), height: \(cellHeight)")
////            size = CGSize(width: cellWidth, height: cellHeight)
////        } else {
////            cellHeight = (cellWidth - CELL_EDGE_MARGIN * 2) * 0.75 + CELL_EDGE_MARGIN * 2
////            size = CGSize(width: cellWidth, height: cellHeight)
////            //print("cell_width: \(cellWidth), cell_height: \(cellHeight)")
////        }
//        //print("cell width: \(cellWidth!), height: \(cellHeight)")
//        return size
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 30.0, right: 5.0)
//    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = lists[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell {
//            let image = data.featured
//            let imageWidth: CGFloat = image.size.width
//            let imageHeight: CGFloat = image.size.height
//
//            let width: CGFloat = cellWidth! - CELL_EDGE_MARGIN*2
//            var height: CGFloat!
//            if imageWidth < width {
//                height = imageHeight
//            } else {
//                height = (imageHeight/imageWidth) * (cellWidth-CELL_EDGE_MARGIN*2)
//            }
//
//            let frame: CGRect = cell.featuredView.frame
//            //print("featured frame: \(frame)")
//            cell.featuredView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
            //cell.updateViews(data: data, idx: indexPath.row)
            //print("4.\(indexPath.row):\(cell.frame.size.height)")
            
            return cell
        }
//        if data.vimeo.count > 0 || data.youtube.count > 0 {
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iden+"VideoCell", for: indexPath) as? VideoCell {
//                cell.updateViews(list: data)
//
//                return cell
//            }
//        } else {
//
//        }
        return CollectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list: SuperData = lists[indexPath.row]
        if list.vimeo.count == 0 && list.youtube.count == 0 {
            performSegue(withIdentifier: TO_SHOW, sender: list)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let showVC: ShowVC = segue.destination as? ShowVC {
//            assert(sender as? SuperData != nil)
//            let data: SuperData = sender as! SuperData
//            let show_in: Show_IN = Show_IN(type: iden, id: data.id, token: data.token, title: data.title)
//            showVC.initShowVC(sin: show_in)
//        }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if tableView == searchTableView {
            height = 30
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as? EditCell {
            cell.editCellDelegate = self
            let searchRow = searchRows[indexPath.row]
            //print(searchRow)
            cell.forRow(indexPath: indexPath, row: searchRow)
            return cell
        }
        return UITableViewCell()
    }
    
    func showSearchPanel() {
        collectionView.isScrollEnabled = false
        mask(superView: collectionView)
        addLayer()
        animation()
    }
    
    func mask(superView: UIView) {
        maskView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        superView.addSubview(maskView)
        
        maskView.frame = CGRect(x: 0, y: newY, width: superView.frame.width, height: tableViewBoundHeight)
        maskView.alpha = 0
    }
    
    func addLayer() {
        collectionView.addSubview(containerView)
        containerView.frame = CGRect(x:padding, y:tableViewBoundHeight + newY, width:view.frame.width-(2*padding), height:layerHeight)
        containerView.backgroundColor = UIColor.black
        
        searchTableView.backgroundColor = UIColor.clear
        containerView.addSubview(self.searchTableView)
        
        containerView.addSubview(searchSubmitBtn)
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: searchSubmitBtn, attribute: .top, relatedBy: .equal, toItem: searchTableView, attribute: .bottom, multiplier: 1, constant: 24)
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: searchSubmitBtn, attribute: .centerX, relatedBy: .equal, toItem: searchSubmitBtn.superview, attribute: .centerX, multiplier: 1, constant: 0)
        searchSubmitBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([c1,c2])
        searchSubmitBtn.addTarget(self, action: #selector(submit(view:)), for: .touchUpInside)
        self.searchTableView.isHidden = false
        self.searchSubmitBtn.isHidden = false
    }
    
    func animation() {
        let y = newY + 100
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
            self.containerView.frame = CGRect(x: self.padding, y: y, width: self.containerView.frame.width, height: self.layerHeight)
        }, completion: { (finished) in
            if finished {
                let frame = self.containerView.frame
                self.searchTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 400)
                
            }
        })
    }
    
    @objc func unmask() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.searchTableView.isHidden = true
            self.searchSubmitBtn.isHidden = true
            self.containerView.frame = CGRect(x:self.padding, y:self.newY+self.tableViewBoundHeight, width:self.containerView.frame.width, height:0)
        }
        collectionView.isScrollEnabled = true
    }
    
    @objc func submit(view: UIButton) {
        searchPanelisHidden = true
        unmask()
        prepareParams()
        refresh()
    }
    
    func setSwitch(indexPath: IndexPath, value: Bool) {
    }
    
    func setTextField(iden: String, value: String) {
        //print(value)
        keyword = value
    }
    
    func clear(indexPath: IndexPath) {
        
    }
    
    public func testLabelReset() {
        testLabel.frame = CGRect.zero
        testLabel.frame.size.width = cellWidth-(2*CELL_EDGE_MARGIN)
    }
    
    public func getTestLabelLineCount(textCount: Int = 0)-> Int {
        let textSize = CGSize(width: CGFloat(testLabel.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(testLabel.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(testLabel.font.pointSize))
        var count: Int = rHeight / charSize
        if textCount > 0 {
            let tmp = CGFloat(textCount) / CGFloat(20)
            let count1: Int = Int(tmp.rounded(FloatingPointRoundingRule.up))
            if count1 > count {
                count = count1
            }
        }
        return count
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        newY = scrollView.contentOffset.y
        if newY < 0 { newY = 0 }
        //print(newY)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        newY = scrollView.contentOffset.y
        if newY < 0 { newY = 0 }
        //print(scrollView.contentOffset.y)
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


