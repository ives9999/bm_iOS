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
    
    var mysTable: TeachesTable?
            
    override func viewDidLoad() {
        myTablView = tableView
        dataService = TeachService.instance
        searchRows = _searchRows
        //_type = "teach"
        //_titleField = "title"
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "TeachCell", bundle: nil)
        myTablView.register(cellNibName, forCellReuseIdentifier: "listcell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: TeachesTable.self)
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? TeachesTable)
            if mysTable != nil {
                let tmps: [TeachTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [TeachTable]()
                }
                lists1 += tmps
                myTablView.reloadData()
            } else {
                warning("轉換Table出錯，請洽管理員")
            }
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? TeachCell {
                
                //cell.cellDelegate = self
                let row = lists1[indexPath.row] as? TeachTable
                if row != nil {
                    row!.filterRow()
                    //row!.printRow()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SHOW {
            if let showVC: ShowVC = segue.destination as? ShowVC {
                let table = sender as! TeachTable
                let show_in: Show_IN = Show_IN(type: "teach", id: table.id, token: table.token, title: table.title)
                showVC.initShowVC(sin: show_in)
            }
        }
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
