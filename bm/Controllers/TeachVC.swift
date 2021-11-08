//
//  CourseCV.swift
//  bm
//
//  Created by ives on 2017/10/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeachVC: MyTableVC {
        
    var mysTable: TeachesTable?
            
    override func viewDidLoad() {
        myTablView = tableView
        dataService = TeachService.instance
//        searchRows = [
//            ["ch":"標題關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入教學名稱關鍵字","text_field":true,"value":""]
//            ]
        
        searchSections = initSectionRows()
        //_type = "teach"
        //_titleField = "title"
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "TeachListCell", bundle: nil)
        myTablView.register(cellNibName, forCellReuseIdentifier: "listcell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        
        // this page show search icon in top
        searchBtn.visibility = .visible
        
        refresh()
    }
    
    override func initSectionRows()-> [SearchSection] {

        var sections: [SearchSection] = [SearchSection]()

        sections.append(makeSection0Row())

        return sections
    }
    
    override func makeSection0Row(_ isExpanded: Bool=true)-> SearchSection {
        var rows: [SearchRow] = [SearchRow]()
        let r1: SearchRow = SearchRow(title: "關鍵字", key: KEYWORD_KEY, cell: "textField")
        rows.append(r1)

        let s: SearchSection = SearchSection(title: "一般", isExpanded: isExpanded)
        s.items.append(contentsOf: rows)
        return s
    }
    
//    override func refresh() {
//        page = 1
//        getDataStart(page: page, perPage: PERPAGE)
//    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(TeachesTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if (page == 1) {
                lists1 = [TeachTable]()
            }
            lists1 += mysTable!.rows
        }
    }
    
//    override func getDataEnd(success: Bool) {
//        if success {
//
//            mysTable = (tables as? TeachesTable)
//            if mysTable != nil {
//                let tmps: [TeachTable] = mysTable!.rows
//
//                if page == 1 {
//                    lists1 = [TeachTable]()
//                }
//                lists1 += tmps
//                myTablView.reloadData()
//            } else {
//                warning("轉換Table出錯，請洽管理員")
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? TeachListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as? TeachTable
            if row != nil {
                row!.filterRow()
                //row!.printRow()
                cell.updateViews(row!)
            }
            
            return cell
        } else {
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = lists1[indexPath.row] as! TeachTable
        //toShowTeach(token: row.token)
        toYoutubePlayer(token: row.youtube)
        
        //performSegue(withIdentifier: "showTeach", sender: row)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showTeach" {
//            if let showTeachVC: ShowTeachVC = segue.destination as? ShowTeachVC {
//                let table = sender as! TeachTable
//                let show_in: Show_IN = Show_IN(type: "teach", id: table.id, token: table.token, title: table.title)
//                showVC.initShowVC(sin: show_in)
//            }
//        }
//    }
    
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
}
