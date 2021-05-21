//
//  CourseVC.swift
//  bm
//
//  Created by ives on 2019/6/18.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class CourseVC: ListVC {
    
    @IBOutlet weak var managerBtn: UIButton!
    
    let _searchRows: [[String: Any]] = [
        ["title":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入課程名稱關鍵字","text_field":true,"value":"","value_type":"String"],
        ["title":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":"","value_type":"Array"],
        ["title":"日期","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int](),"value":"","value_type":"Array"],
        ["title":"開始時間之後","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"],
        ["title":"結束時間之前","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":END_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"]
    ]
    
    var mysTable: CoursesTable?
    
    override func viewDidLoad() {
        
        myTablView = tableView
        able_type = "course"
        dataService = CourseService.instance
        //_type = "course"
        //_titleField = "title"
        searchRows = _searchRows
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "CourseListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: CoursesTable.self)
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? CoursesTable)
            if mysTable != nil {
                let tmps: [CourseTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [CourseTable]()
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? CourseListCell {
                
                cell.cellDelegate = self
                let row = lists1[indexPath.row] as? CourseTable
                if row != nil {
                    row!.filterRow()
                    //row!.printRow()
                    //print(row!.like);
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
                toShowCourse(token: myTable.token)
            }
            
        } else if tableView == searchTableView {
            let row = searchRows[indexPath.row]
            let segue: String = row["segue"] as! String
            if (segue == TO_CITY) {
                var key: String? = nil
                if (row.keyExist(key: "key") && row["key"] != nil) {
                    key = row["key"] as? String
                }
                var selected: String? = nil
                if (row.keyExist(key: "value") && row["value"] != nil) {
                    selected = row["value"] as? String
                }
                toSelectCity(key: key, selected: selected, _delegate: self)
            } else if (segue == TO_SELECT_WEEKDAY) {
                toSelectWeekday()
            } else {
                performSegue(withIdentifier: segue, sender: indexPath)
            }
        }
    }
    
    override func setWeekdaysData(res: [Int], indexPath: IndexPath?) {
        var row = getDefinedRow(WEEKDAY_KEY)
        var texts: [String] = [String]()
        weekdays = res
        if weekdays.count > 0 {
            for weekday in weekdays {
                for gweekday in Global.instance.weekdays {
                    if weekday == gweekday["value"] as! Int {
                        let text = gweekday["simple_text"]
                        texts.append(text! as! String)
                        break
                    }
                }
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(TEAM_WEEKDAYS_KEY, row)
        tableView.reloadData()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == TO_MANAGER_COURSE {
//            let vc: ManagerCourseVC = segue.destination as! ManagerCourseVC
//            vc.manager_token = Member.instance.token
//        } else if segue.identifier == TO_MULTI_SELECT || segue.identifier == TO_SINGLE_SELECT {
//            let indexPath = sender as! IndexPath
//            let row = searchRows[indexPath.row]
//            let title: String = row["title"] as! String
//            let key: String = row["key"] as! String
//            var rows1: [[String: String]] = [[String: String]]()
//
//            var vc: SelectVC?
//            if segue.identifier == TO_MULTI_SELECT {
//                vc = segue.destination as! MultiSelectVC
//                if key == WEEKDAY_KEY {
//                    rows1 = WEEKDAY.makeSelect()
//                    vc!.rows1 = rows1
//                }
//            } else if segue.identifier == TO_SINGLE_SELECT {
//                vc = segue.destination as! SingleSelectVC
//                if key == START_TIME_KEY || key == END_TIME_KEY {
//                    let times = Global.instance.makeTimes()
//                    for time in times {
//                        rows1.append(["title": time, "value": time+":00"])
//                    }
//                    vc!.rows1 = rows1
//                }
//            }
//            if vc != nil {
//                vc!.title = title
//                vc!.key = key
//                vc!.setDelegate(self)
//            }
//        }
//    }
    
    override func layerSubmit(view: UIButton) {
        searchPanelisHidden = true
        unmask()
        prepareParams()
        refresh()
    }
    
    func prepareParams() {
        params1 = [String: Any]()
        for row in searchRows {
            let key: String = row["key"] as! String
            let value: String = row["value"] as! String
            if value.count == 0 {
                continue
            }
            let value_type: String = row["value_type"] as! String
            if value_type == "Array" {
                var values: [String] = [String]()
                if value.contains(",") {
                    values = value.components(separatedBy: ",")
                } else {
                    values.append(value)
                }
                params1![key] = values
            } else {
                params1![key] = value
            }
        }
        //print(params1)
    }

    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            warning("請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER_COURSE, sender: nil)
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

    override func singleSelected(key: String, selected: String) {
        var row = getDefinedRow(key)
        var show = ""
        if key == START_TIME_KEY || key == END_TIME_KEY {
            row["value"] = selected
            show = selected.noSec()
        } else if (key == CITY_KEY) {
            row["value"] = selected
            show = Global.instance.zoneIDToName(Int(selected)!)
        }
        row["show"] = show
        replaceRows(key, row)
        searchTableView.reloadData()
    }
    
    override func multiSelected(key: String, selecteds: [String]) {
        var row = getDefinedRow(key)
        var show = ""
        if key == WEEKDAY_KEY {
            var texts: [String] = [String]()
            for selected in selecteds {
                let text = WEEKDAY.intToString(Int(selected)!)
                texts.append(text)
            }
            show = texts.joined(separator: ",")
        } else if key == CITY_KEY {
            var citys: [[String: String]] = [[String: String]]()
            if session.array(forKey: "citys") != nil {
                citys = (session.array(forKey: "citys") as! [[String: String]])
                //print(citys)
            }
            var texts: [String] = [String]()
            for selected in selecteds {
                for city in citys {
                    if city["value"] == selected {
                        let text = city["title"]!
                        texts.append(text)
                        break
                    }
                }
            }
            show = texts.joined(separator: ",")
        }
        row["show"] = show
        row["value"] = selecteds.joined(separator: ",")
        replaceRows(key, row)
        searchTableView.reloadData()
    }
}

