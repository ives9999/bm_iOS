//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ArenaVC: ListVC {
    
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入球場名稱關鍵字","text_field":true],
        ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
        ["ch":"區域","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":AREA_KEY,"show":"全部","segue":TO_AREA,"sender":0],
        ["ch":"空調","atype":UITableViewCell.AccessoryType.none,"key":ARENA_AIR_CONDITION_KEY,"show":"全部","segue":"","sender":0,"switch":true],
        ["ch":"盥洗室","atype":UITableViewCell.AccessoryType.none,"key":ARENA_BATHROOM_KEY,"show":"全部","segue":"","sender":0,"switch":true],
        ["ch":"停車場","atype":UITableViewCell.AccessoryType.none,"key":ARENA_PARKING_KEY,"show":"全部","segue":"","sender":0,"switch":true]
    ]
    
    var mysTable: ArenasTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "arena"
        dataService = ArenaService.instance
        searchRows = _searchRows
//        _type = "arena"
//        _titleField = "name"
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "ArenaListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: ArenasTable.self)
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? ArenasTable)
            if mysTable != nil {
                let tmps: [ArenaTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [ArenaTable]()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mysTable != nil {
            let myTable = mysTable!.rows[indexPath.row]
            toShowArena(token: myTable.token)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == TO_SHOW {
//            if let showVC: ShowVC = segue.destination as? ShowVC {
//                let table = sender as! ArenaTable
//                let show_in: Show_IN = Show_IN(type: iden, id: table.id, token: table.token, title: table.name)
//                showVC.initShowVC(sin: show_in)
//            }
//        }
//    }
    
    override func showMap(indexPath: IndexPath) {
        let row = lists1[indexPath.row]
        let address = row.address
        let title = row.title
        let sender: [String: String] = [
            "title": title,
            "address": address
        ]
        performSegue(withIdentifier: TO_MAP, sender: sender)
    }
}
