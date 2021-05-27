//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift
import SCLAlertView

class TeamVC: ListVC {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var managerBtn: UIButton!
        
    var mysTable: TeamsTable?
        
    override func viewDidLoad() {
        
        myTablView = tableView
        dataService = TeamService.instance
        able_type = "team"
        //_type = "team"
        //_titleField = "name"
        searchRows = [
            ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true,"value":""],
            ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":""],
            ["ch":"球館","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int](),"value":""],
            ["ch":"星期幾","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int](),"value":""],
            ["ch":"時段","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any](),"value":""],
            ["ch":"程度","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String](),"value":""]
            ]
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "TeamListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: TeamsTable.self)
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? TeamsTable)
            if mysTable != nil {
                let tmps: [TeamTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [TeamTable]()
                }
                lists1 += tmps
                
                myTablView.reloadData()
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? TeamListCell {
                
                cell.cellDelegate = self
                let row = lists1[indexPath.row] as? TeamTable
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
                toShowTeam(token: myTable.token)
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
            } else if (segue == TO_SELECT_WEEKDAY) {
                
                let selecteds: [Int] = valueToArray(t: Int.self, row: row)
                toSelectWeekday(key: key, selecteds: selecteds, delegate: self)
            } else if (segue == TO_SELECT_TIME) {
                
                var type: SELECT_TIME_TYPE = SELECT_TIME_TYPE.play_start
                if (key == END_TIME_KEY) {
                    type = SELECT_TIME_TYPE.play_end
                }
                
                let selecteds: [String] = valueToArray(t: String.self, row: row)
                toSelectTime(key: key, selecteds: selecteds, input: ["type": type], delegate: self)
            } else if segue == TO_ARENA {
    
                var citys: [Int] = [Int]()
                var city: Int? = nil
                var row = getDefinedRow(CITY_KEY)
                if let value: String = row["value"] as? String {
                    city = Int(value)
                    if (city != nil) {
                        citys.append(city!)
                    }
                }
                
                if (city == nil) {
                    warning("請先選擇縣市")
                } else {
                
                    //取得選擇球館的代號
                    row = getDefinedRow(ARENA_KEY)
                    let selecteds: [Int] = valueToArray(t: Int.self, row: row)
                    toSelectArena(selecteds: selecteds, citys: citys, delegate: self)
                }
            } else if (segue == TO_SELECT_DEGREE) {
                
                let tmps: [String] = valueToArray(t: String.self, row: row)
                var selecteds: [DEGREE] = [DEGREE]()
                for tmp in tmps {
                    selecteds.append(DEGREE.enumFromString(string: tmp))
                }
                toSelectDegree(selecteds: selecteds, delegate: self)
            } else {
                //performSegue(withIdentifier: segue, sender: indexPath)
            }
        }
    }
    
    override func cellArena(row: Table) {
        if let myTable: TeamTable = row as? TeamTable {
            let key: String = ARENA_KEY
            let arena_id: Int = myTable.arena_id
            var row = getDefinedRow(key)
            row["value"] = String(arena_id)
            replaceRows(key, row)
            prepareParams()
            refresh()
        } else {
            warning("轉為TeamTable失敗，請洽管理員")
        }
    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER, sender: nil)
        }
    }
}
