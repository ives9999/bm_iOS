//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ArenaVC: MyTableVC {
    
    @IBOutlet var prevBtn: UIButton!
    
    var mysTable: ArenasTable?
    var isShowPrev: Bool = false
        
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "arena"
        dataService = ArenaService.instance
        
        oneSections = initSectionRows()
        super.viewDidLoad()
        
        prevBtn.isHidden = !isShowPrev
        
        let cellNibName = UINib(nibName: "ArenaListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        // this page show search icon in top
        searchBtn.visibility = .visible
        
        refresh()
    }
    
    override func initSectionRows()-> [OneSection] {

        var sections: [OneSection] = [OneSection]()

        sections.append(makeSectionRow())

        return sections
    }
    
    override func makeSectionRow(_ isExpanded: Bool=true)-> OneSection {
        var rows: [OneRow] = [OneRow]()
        let r1: OneRow = OneRow(title: "關鍵字", key: KEYWORD_KEY, cell: "textField")
        rows.append(r1)
        let r2: OneRow = OneRow(title: "縣市", show: "全部", key: CITY_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r2)
        let r3: OneRow = OneRow(title: "區域", show: "全部", key: AREA_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r3)
        let r4: OneRow = OneRow(title: "空調", value: "0", show: "全部", key: ARENA_AIR_CONDITION_KEY, cell: "switch")
        rows.append(r4)
        let r5: OneRow = OneRow(title: "盥洗室", value: "0", show: "全部", key: ARENA_BATHROOM_KEY, cell: "switch")
        rows.append(r5)
        let r6: OneRow = OneRow(title: "停車場", value: "0", show: "全部", key: ARENA_PARKING_KEY, cell: "switch")
        rows.append(r6)

        let s: OneSection = OneSection(title: "一般", key: "general", isExpanded: isExpanded)
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
                mysTable = try JSONDecoder().decode(ArenasTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if mysTable!.rows.count > 0 {
                if (page == 1) {
                    lists1 = [ArenaTable]()
                }
                lists1 += mysTable!.rows
            } else {
                view.setInfo(info: "目前暫無球館", topAnchor: topView)
            }
        }
    }
    
//    override func getDataEnd(success: Bool) {
//        if success {
//
//            mysTable = (tables as? ArenasTable)
//            if mysTable != nil {
//                let tmps: [ArenaTable] = mysTable!.rows
//
//                if page == 1 {
//                    lists1 = [ArenaTable]()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ArenaListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as? ArenaTable
            if row != nil {
                row!.filterRow()
                //row!.printRow()
                cell.updateViews(row!)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mysTable != nil {
            let myTable = mysTable!.rows[indexPath.row]
            toShowArena(token: myTable.token)
        }
    }
    
    override func cellArea(row: Table) {
        if let myTable: ArenaTable = row as? ArenaTable {
            let key: String = AREA_KEY
            let area_id: Int = myTable.area_id
            let row = getOneRowFromKey(key)
            row.value = String(area_id)
            //replaceRows(key, row)
            prepareParams()
            refresh()
        } else {
            warning("轉為ArenaTable失敗，請洽管理員")
        }
    }
    
//    override func showMap(indexPath: IndexPath) {
//        let row = lists1[indexPath.row]
//        let address = row.address
//        let title = row.title
//        let sender: [String: String] = [
//            "title": title,
//            "address": address
//        ]
//        performSegue(withIdentifier: TO_MAP, sender: sender)
//    }
}
