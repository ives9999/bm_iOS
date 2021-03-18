//
//  CourseCV.swift
//  bm
//
//  Created by ives on 2017/10/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeachCV: CollectionVC {
    
    let _type:String = "teach"
    
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入教學名稱關鍵字","text_field":true]
        ]
    
    var teachesTable: TeachesTable? = nil
    internal(set) public var lists1: [Table] = [Table]()
    
    var params1: [String: Any]?
        
    override func viewDidLoad() {
        dataService = TeachService.instance
        searchRows = _searchRows
        setIden(item:_type, titleField: "title")
        super.viewDidLoad()
        refresh()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        dataService.getList(t: TeachesTable.self, token: nil, _filter: params1, page: page, perPage: perPage) { (success) in
            if (success) {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            } else {
                Global.instance.removeSpinner(superView: self.view)
                //self.warning(self.dataService.msg)
            }
        }
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            let table: Table = dataService.table!
            teachesTable = (table as! TeachesTable)
            //superCourses = CourseService.instance.superCourses
            let tmps: [TeachTable] = teachesTable!.rows
            
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists1 = [TeachTable]()
            }
            lists1 += tmps
            //print(self.lists)
            page = teachesTable!.page
            if page == 1 {
                totalCount = teachesTable!.totalCount
                perPage = teachesTable!.perPage
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //print(lists.count)
        return lists1.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize!
        let data: TeachTable = lists1[indexPath.row] as! TeachTable
        
        testLabelReset()
        testLabel.text = data.title
        testLabel.sizeToFit()
        let lineCount = getTestLabelLineCount(textCount: data.title.count)
        
        let titleLblHeight = textHeight * CGFloat(lineCount)
        
        let featured = data.featured
        let w = featured.size.width
        let h = featured.size.height
        let aspect = w / h
        let featuredViewHeight = cellWidth / aspect
        
        var cellHeight: CGFloat
        cellHeight = titleLblHeight + featuredViewHeight + textHeight + 4*CELL_EDGE_MARGIN
        //print("\(indexPath.row).\(cellHeight)")
        size = CGSize(width: cellWidth, height: cellHeight)
        
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = lists[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell {

            let row = lists1[indexPath.row] as? TeachTable
            if row != nil {
                row!.filterRow()
                //row!.printRow()
                cell.updateTeach(data: row!, idx: indexPath.row)
            }
            
            return cell
        }

        return CollectionCell()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchPanelisHidden {
            showSearchPanel()
        } else {
            searchPanelisHidden = true
            unmask()
        }
    }
}
