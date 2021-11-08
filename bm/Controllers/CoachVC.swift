//
//  CoachVC.swift
//  bm
//
//  Created by ives on 2017/10/19.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class CoachVC: MyTableVC {
    
    var mysTable: CoachesTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "coach"
        dataService = CoachService.instance
        //_type = "coach"
        //_titleField = "name"
//        searchRows = [
//            ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入教練名稱關鍵字","text_field":true,"value":""],
//            ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":""]
//        ]
        
        searchSections = initSectionRows()
        //Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "CoachListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        // this page show search icon in top
        searchBtn.visibility = .visible
        
        refresh()
    }
    
    override func initSectionRows()-> [SearchSection] {

        var sections: [SearchSection] = [SearchSection]()

        sections.append(makeSection0Row())
        //sections.append(makeSection1Row(false))

        return sections
    }
    
    override func makeSection0Row(_ isExpanded: Bool=true)-> SearchSection {
        var rows: [SearchRow] = [SearchRow]()
        let r1: SearchRow = SearchRow(title: "關鍵字", key: KEYWORD_KEY, cell: "textField")
        rows.append(r1)
        let r2: SearchRow = SearchRow(title: "縣市", show: "全部", key: CITY_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r2)

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
                mysTable = try JSONDecoder().decode(CoachesTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if (page == 1) {
                lists1 = [CoachTable]()
            }
            lists1 += mysTable!.rows
        }
    }
    
//    override func getDataEnd(success: Bool) {
//        if success {
//            
//            mysTable = (tables as? CoachesTable)
//            if mysTable != nil {
//                let tmps: [CoachTable] = mysTable!.rows
//                
//                if page == 1 {
//                    lists1 = [CoachTable]()
//                }
//                lists1 += tmps
//                
//                myTablView.reloadData()
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? CoachListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as? CoachTable
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
        let row = lists1[indexPath.row]
        toShowCoach(token: row.token)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == TO_SHOW_COACh {
//            if let showCoachVC: ShowCoachVC = segue.destination as? ShowCoachVC {
//                let table = sender as! CoachTable
//                let show_in: Show_IN = Show_IN(type: iden, id: table.id, token: table.token, title: table.name)
//                showCoachVC.initShowVC(sin: show_in)
//                showCoachVC.backDelegate = self
//            }
//        }
//    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER, sender: nil)
        }
    }
}
