//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ArenaVC: ListVC {
    
    var mysTable: ArenasTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "arena"
        dataService = ArenaService.instance
        searchRows = [
            ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入球場名稱關鍵字","text_field":true,"value":""],
            ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":""],
            ["ch":"區域","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":AREA_KEY,"show":"全部","segue":TO_AREA,"sender":0,"value":""],
            ["ch":"空調","atype":UITableViewCell.AccessoryType.none,"key":ARENA_AIR_CONDITION_KEY,"show":"全部","segue":"","sender":0,"switch":true,"value":""],
            ["ch":"盥洗室","atype":UITableViewCell.AccessoryType.none,"key":ARENA_BATHROOM_KEY,"show":"全部","segue":"","sender":0,"switch":true,"value":""],
            ["ch":"停車場","atype":UITableViewCell.AccessoryType.none,"key":ARENA_PARKING_KEY,"show":"全部","segue":"","sender":0,"switch":true,"value":""]
        ]
//        _type = "arena"
//        _titleField = "name"
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "ArenaListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        refresh()
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
            if (page == 1) {
                lists1 = [ArenaTable]()
            }
            lists1 += mysTable!.rows
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
        if tableView == self.tableView {
            if mysTable != nil {
                let myTable = mysTable!.rows[indexPath.row]
                toShowArena(token: myTable.token)
            }
        } else if tableView == searchTableView {
            let row = searchRows[indexPath.row]
            
            var key: String? = nil
            if (row.keyExist(key: "key") && row["key"] != nil) {
                key = row["key"] as? String
            }
            
            let segue: String = row["segue"] as! String
            if (segue == TO_CITY) {
                var selected: String? = nil
                if (row.keyExist(key: "value") && row["value"] != nil) {
                    selected = row["value"] as? String
                }
                toSelectCity(key: key, selected: selected, delegate: self)
            } else if segue == TO_AREA {
                
                //var citys: [Int] = [Int]()
                var city: Int? = nil
                var row = getDefinedRow(CITY_KEY)
                if let value: String = row["value"] as? String {
                    city = Int(value)
//                    if (city != nil) {
//                        citys.append(city!)
//                    }
                }
                
                if (city == nil) {
                    warning("請先選擇縣市")
                } else {
                
                    //取得選擇球館的代號
                    row = getDefinedRow(AREA_KEY)
                    var selected: String? = nil
                    if (row.keyExist(key: "value") && row["value"] != nil) {
                        selected = row["value"] as? String
                    }
                    toSelectArea(key: key, city_id: city, selected: selected, delegate: self)
                }
            } else {
                //performSegue(withIdentifier: segue, sender: indexPath)
            }
        }
    }
    
    override func cellArea(row: Table) {
        if let myTable: ArenaTable = row as? ArenaTable {
            let key: String = AREA_KEY
            let area_id: Int = myTable.area_id
            var row = getDefinedRow(key)
            row["value"] = String(area_id)
            replaceRows(key, row)
            prepareParams()
            refresh()
        } else {
            warning("轉為ArenaTable失敗，請洽管理員")
        }
    }
    
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
