//
//  CourseVC.swift
//  bm
//
//  Created by ives on 2019/6/18.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class CourseVC: ListVC, SingleSelectDelegate, MultiSelectDelegate, SelectDelegate {
    
    @IBOutlet weak var managerBtn: UIButton!
    
    let _searchRows: [[String: Any]] = [
        ["title":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入課程名稱關鍵字","text_field":true,"value":"","value_type":"String"],
        ["title":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":0,"value":"","value_type":"Array"],
        ["title":"日期","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":[Int](),"value":"","value_type":"Array"],
        ["title":"開始時間之後","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"],
        ["title":"結束時間之前","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":END_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"]
    ]
    
    var superCourses: SuperCourses? = nil
    internal(set) public var lists1: [SuperModel] = [SuperModel]()
    
    let session: UserDefaults = UserDefaults.standard
    var params1: [String: Any]?

    override func viewDidLoad() {
        
        myTablView = tableView
        myTablView.allowsMultipleSelectionDuringEditing = false
        myTablView.isUserInteractionEnabled = true
        dataService = CourseService.instance
        _type = "course"
        _titleField = "title"
        searchRows = _searchRows
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        dataService.getList(t: SuperCourse.self, t1: SuperCourses.self, token: nil, _filter: params1, page: page, perPage: perPage) { (success) in
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
            let superModel: SuperModel = CourseService.instance.superModel
            superCourses = (superModel as! SuperCourses)
            //superCourses = CourseService.instance.superCourses
            let tmps: [SuperCourse] = superCourses!.rows
            
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists1 = [SuperCourse]()
            }
            lists1 += tmps
            //print(self.lists)
            page = superCourses!.page
            if page == 1 {
                totalCount = superCourses!.totalCount
                perPage = superCourses!.perPage
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
                let row = lists1[indexPath.row] as! SuperCourse
                //row.printRow()
                cell.updateCourseViews(indexPath: indexPath, data: row)
                
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
            if superCourses != nil {
                let superCourse = superCourses!.rows[indexPath.row]
                performSegue(withIdentifier: TO_SHOW_COURSE, sender: superCourse)
            }
            
        } else if tableView == searchTableView {
            let row = searchRows[indexPath.row]
            let segue: String = row["segue"] as! String
            performSegue(withIdentifier: segue, sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == TO_SHOW_COURSE {
            let superCourse = sender as! SuperCourse
            let vc: ShowCourseVC = segue.destination as! ShowCourseVC
            vc.title = superCourse.title
            vc.course_token = superCourse.token
        } else if segue.identifier == TO_MANAGER_COURSE {
            let vc: ManagerCourseVC = segue.destination as! ManagerCourseVC
            vc.manager_token = Member.instance.token
        } else if segue.identifier == TO_MULTI_SELECT || segue.identifier == TO_SINGLE_SELECT {
            let indexPath = sender as! IndexPath
            let row = searchRows[indexPath.row]
            let title: String = row["title"] as! String
            let key: String = row["key"] as! String
            var rows1: [[String: String]] = [[String: String]]()
            
            var vc: SelectVC?
            if segue.identifier == TO_MULTI_SELECT {
                vc = segue.destination as! MultiSelectVC
                if key == WEEKDAY_KEY {
                    rows1 = WEEKDAY.makeSelect()
                    vc!.rows1 = rows1
                }
            } else if segue.identifier == TO_SINGLE_SELECT {
                vc = segue.destination as! SingleSelectVC
                if key == START_TIME_KEY || key == END_TIME_KEY {
                    let times = Global.instance.makeTimes()
                    for time in times {
                        rows1.append(["title": time, "value": time+":00"])
                    }
                    vc!.rows1 = rows1
                }
            }
            if vc != nil {
                vc!.title = title
                vc!.key = key
                vc!.setDelegate(self)
            }
        }
    }
    
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
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
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

    func singleSelected(key: String, selected: String) {
        var row = getDefinedRow(key)
        var show = ""
        if key == START_TIME_KEY || key == END_TIME_KEY {
            row["value"] = selected
            show = selected.noSec()
        }
        row["show"] = show
        replaceRows(key, row)
        searchTableView.reloadData()
    }
    
    func multiSelected(key: String, selecteds: [String]) {
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

