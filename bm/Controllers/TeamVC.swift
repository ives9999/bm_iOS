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
    
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true],
        ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
        ["ch":"球館","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int]()],
        ["ch":"日期","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":TEAM_WEEKDAYS_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int]()],
        ["ch":"時段","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":TEAM_PLAY_START_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()],
        ["ch":"程度","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":TEAM_DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String]()]
        ]
    
    var mysTable: TeamsTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        dataService = TeamService.instance
        able_type = "team"
        //_type = "team"
        //_titleField = "name"
        searchRows = _searchRows
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
        if mysTable != nil {
            let myTable = mysTable!.rows[indexPath.row]
            toShowTeam(token: myTable.token)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == TO_SHOW {
//            if let showVC: ShowVC = segue.destination as? ShowVC {
//                let table = sender as! TeamTable
//                let show_in: Show_IN = Show_IN(type: iden, id: table.id, token: table.token, title: table.name)
//                showVC.initShowVC(sin: show_in)
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
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchPanelisHidden {
            showSearchPanel()
        } else {
            searchPanelisHidden = true
            unmask()
        }
    }
}
