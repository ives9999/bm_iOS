//
//  CourseCalendarVC.swift
//  bm
//
//  Created by ives on 2019/11/16.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class CourseCalendarVC: ListVC {
    
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
    
    var year: Int = Date().getY()
    var month: Int = Date().getm()
    var monthLastDay: Int = 31
    
    var course_width: Int = 100
    var course_height: Int = 300
    
    var dateCourses: [[String: Any]] = [[String: Any]]()

    override func viewDidLoad() {
        
        myTablView = tableView
        dataService = CourseService.instance
        _type = "course"
        _titleField = "title"
        searchRows = _searchRows
        Global.instance.setupTabbar(self)
        Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()

        monthLastDay = Global.instance.getMonthLastDay(year: year, month: month)
        
        let cellNibName = UINib(nibName: "CalendarSignupCell", bundle: nil)
        myTablView.register(cellNibName, forCellReuseIdentifier: "calendar_signup_cell")
        //myTablView.rowHeight = UITableViewAutomaticDimension
        //myTablView.estimatedRowHeight = 400
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
            makeCourseArr()
            print(dateCourses)
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lists1.count > 0 {
            return monthLastDay
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let d: [String: Any] = dateCourses[indexPath.row]
        guard let courses: [SuperCourse] = d["rows"] as? [SuperCourse] else { return 44}
        if courses.count > 0 {
            let height: Int = course_height * courses.count + ((courses.count-1)*10) + 50
            return CGFloat(height)
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == myTablView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "calendar_signup_cell", for: indexPath) as? CalendarSignupCell {
                
                for view in cell.courseContainer.subviews {
                    view.removeFromSuperview()
                }
                let day: Int = indexPath.row + 1
                let date: String = String(format: "%4d-%02d-%02d", year, month, day)
                //print(date)
                
                course_width = Int(view.frame.width - 24)
                cell.update(date: date, superModels: lists1, course_width: course_width, course_height: course_height)
                return cell
            } else {
                return CalendarSignupCell()
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
    
    func makeCourseArr() {
        for day in 1...monthLastDay {
            var course: [String: Any] = [String: Any]()
            let date: String = String(format: "%4d-%02d-%02d", year, month, day)
            course["date"] = date
            let d: Date = date.toDate()
            let weekday_i: Int = d.dateToWeekday()
            let weekday_c: String = d.dateToWeekdayForChinese()
            course["weekday_i"] = weekday_i
            course["weekday_c"] = weekday_c
            
            var rows: [SuperCourse] = [SuperCourse]()
            for superModel in lists1 {
                if let superCourse = superModel as? SuperCourse {
                    //superCourse.printRow()
                    for weekday in superCourse.weekday_arr {
                        if weekday == weekday_i {
                            rows.append(superCourse)
                        }
                    }
                }
            }
            course["rows"] = rows
            
            dateCourses.append(course)
        }
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
