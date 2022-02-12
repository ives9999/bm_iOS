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

class TeamVC: MyTableVC {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var managerBtn: UIButton!
        
    //var mysTable: TeamsTable?
        
    override func viewDidLoad() {
        
        myTablView = tableView
        dataService = TeamService.instance
        able_type = "team"
        //_type = "team"
        //_titleField = "name"
//        searchRows = [
//            ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true,"value":""],
//            ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":""],
//            ["ch":"球館","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int](),"value":""],
//            ["ch":"星期幾","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int](),"value":""],
//            ["ch":"時段","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any](),"value":""],
//            ["ch":"程度","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String](),"value":""]
//            ]
        
        oneSections = initSectionRows()
        //Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "TeamListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        params.merge(["status":"online"])
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
        let r3: OneRow = OneRow(title: "球館", show: "全部", key: ARENA_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r3)
        let r4: OneRow = OneRow(title: "星期幾", show: "全部", key: WEEKDAY_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r4)
        let r5: OneRow = OneRow(title: "時段", show: "全部", key: START_TIME_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r5)
        let r6: OneRow = OneRow(title: "程度", show: "全部", key: DEGREE_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r6)

        let s: OneSection = OneSection(title: "一般", isExpanded: isExpanded)
        s.items.append(contentsOf: rows)
        return s
    }
    
//    override func refresh() {
//        page = 1
//        getDataStart(page: page, perPage: PERPAGE)
//    }
    
//    override func getDataStart(page: Int = 1, perPage: Int = PERPAGE) {
//
//        super.getDataStart(t: TeamsTable.self, page: page, perPage: PERPAGE)
//    }
    
//    override func genericTable() {
//
//        do {
//            if (jsonData != nil) {
//                mysTable = try JSONDecoder().decode(TeamsTable.self, from: jsonData!)
//            } else {
//                warning("無法從伺服器取得正確的json資料，請洽管理員")
//            }
//        } catch {
//            msg = "解析JSON字串時，得到空值，請洽管理員"
//        }
//        if (mysTable != nil) {
//            tables = mysTable!
//            if (page == 1) {
//                lists1 = [TeamTable]()
//            }
//
//            lists1 += mysTable!.rows
//        }
//    }
//
//    override func getDataEnd(success: Bool) {
//        if success {
//
//            if (jsonData != nil) {
//                genericTable()
//            }
//
//            if tables != nil {
//
//                if page == 1 {
//                    totalCount = tables!.totalCount
//                    perPage = tables!.perPage
//                    let _pageCount: Int = totalCount / perPage
//                    totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
//                    //print(totalPage)
//                }
//
//                if refreshControl.isRefreshing {
//                    refreshControl.endRefreshing()
//                }
//
//                myTablView.reloadData()
//            }
//        }
//        Global.instance.removeSpinner(superView: view)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = lists1[indexPath.row]
        toShowTeam(token: row.token)
    }
    
    override func cellArena(row: Table) {
        if let myTable: TeamTable = row as? TeamTable {
            let key: String = ARENA_KEY
            let arena_id: Int = myTable.arena_id
            let row = getOneRowFromKey(key)
            row.value = String(arena_id)
            //replaceRows(key, row)
            prepareParams()
            refresh()
        } else {
            warning("轉為TeamTable失敗，請洽管理員")
        }
    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            warning("請先登入為會員")
            //SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER, sender: nil)
        }
    }
}
