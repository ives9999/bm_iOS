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
    
    var teamsTable: TeamsTable? = nil
    internal(set) public var lists1: [Table] = [Table]()
    var params1: [String: Any]?
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = TeamService.instance
        _type = "team"
        _titleField = "name"
        searchRows = _searchRows
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        dataService.getList(t: TeamsTable.self, token: nil, _filter: params1, page: page, perPage: perPage) { (success) in
            if (success) {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            } else {
                Global.instance.removeSpinner(superView: self.view)
                self.warning(self.dataService.msg)
            }
        }
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            let table: Table = dataService.table!
            teamsTable = (table as! TeamsTable)
            //superCourses = CourseService.instance.superCourses
            let tmps: [TeamTable] = teamsTable!.rows
            
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists1 = [TeamsTable]()
            }
            lists1 += tmps
            //print(self.lists)
            page = teamsTable!.page
            if page == 1 {
                totalCount = teamsTable!.totalCount
                perPage = teamsTable!.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(self.totalPage)
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListCell {
                
                cell.cellDelegate = self
                let row = lists1[indexPath.row] as? TeamTable
                if row != nil {
                    row!.filterRow()
                    //row!.printRow()
                    cell.updateTeam(indexPath: indexPath, data: row!)
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
