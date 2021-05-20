//
//  CoachVC.swift
//  bm
//
//  Created by ives on 2017/10/19.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class CoachVC: ListVC {
    
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入教練名稱關鍵字","text_field":true],
        ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0]
    ]
    
    var mysTable: CoachesTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "coach"
        dataService = CoachService.instance
        //_type = "coach"
        //_titleField = "name"
        searchRows = _searchRows
        //Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "CoachListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: CoachesTable.self)
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? CoachesTable)
            if mysTable != nil {
                let tmps: [CoachTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [CoachTable]()
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
            toShowCoach(token: myTable.token)
        }
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
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchPanelisHidden {
            showSearchPanel()
        } else {
            searchPanelisHidden = true
            unmask()
        }
    }
}
