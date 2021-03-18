//
//  CourseCV.swift
//  bm
//
//  Created by ives on 2017/10/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeachCV: ListVC {
        
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入教學名稱關鍵字","text_field":true]
        ]
    
    var teachesTable: TeachesTable? = nil
    internal(set) public var lists1: [Table] = [Table]()
    
    var params1: [String: Any]?
        
    override func viewDidLoad() {
        myTablView = tableView
        dataService = TeachService.instance
        searchRows = _searchRows
        _type = "teach"
        _titleField = "title"
        super.viewDidLoad()
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
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return lists1.count
        } else {
            return searchRows.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListCell {
                
                cell.cellDelegate = self
                let row = lists1[indexPath.row] as? TeachTable
                if row != nil {
                    row!.filterRow()
                    row!.printRow()
                    cell.updateTeachViews(indexPath: indexPath, data: row!)
                }
                
                return cell
            } else {
                return ListCell()
            }
        } else if tableView == searchTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as? EditCell {
                cell.editCellDelegate = self
                let searchRow = searchRows[indexPath.row]
                //print(searchRow)
                cell.forRow(indexPath: indexPath, row: searchRow, isClear: true)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        //print(lists.count)
//        return lists1.count
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var size: CGSize!
//        let data: TeachTable = lists1[indexPath.row] as! TeachTable
//        data.filterRow()
//        
//        testLabelReset()
//        testLabel.text = data.title
//        testLabel.sizeToFit()
//        let lineCount = getTestLabelLineCount(textCount: data.title.count)
//        
//        let titleLblHeight = textHeight * CGFloat(lineCount)
//        
//        var f: UIImageView = UIImageView()
//        f.downloaded(from: data.featured_path)
//        let featured = f.image!
//        let w = featured.size.width
//        let h = featured.size.height
//        let aspect = w / h
//        let featuredViewHeight = cellWidth / aspect
//        
//        var cellHeight: CGFloat
//        cellHeight = titleLblHeight + featuredViewHeight + textHeight + 4*CELL_EDGE_MARGIN
//        //print("\(indexPath.row).\(cellHeight)")
//        size = CGSize(width: cellWidth, height: cellHeight)
//        
//        return size
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell {
//
//            let row = lists1[indexPath.row] as? TeachTable
//            if row != nil {
//                row!.filterRow()
//                //row!.printRow()
//                cell.updateTeach(data: row!, idx: indexPath.row)
//            }
//
//            return cell
//        }
//
//        return CollectionCell()
//    }
    
//    @IBAction func prevBtnPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchPanelisHidden {
            showSearchPanel()
        } else {
            searchPanelisHidden = true
            unmask()
        }
    }
}
