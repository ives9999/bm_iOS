//
//  CourseCalendarVC.swift
//  bm
//
//  Created by ives on 2019/11/16.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SelectionDialog

class CourseCalendarVC: ListVC {
    
    @IBOutlet weak var managerBtn: UIButton!
    @IBOutlet weak var yearTxt: UILabel!
    @IBOutlet weak var monthTxt: UILabel!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var nextMonthTxt: UILabel!
    @IBOutlet weak var prevMonthTxt: UILabel!
    @IBOutlet weak var nowMonthTxt: UILabel!
    @IBOutlet weak var selectedYearTxt: UILabel!
    @IBOutlet weak var selectedMonthTxt: UILabel!
    
    @IBOutlet weak var dateSelectView: UIView!
    @IBOutlet weak var preNextMonthView: UIView!
    
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
    var params1: [String: Any] = [String: Any]()
    
    var y: Int = Date().getY()
    var m: Int = Date().getm()
    //var monthLastDay: Int = 31
    
    var thisYear: Int = Date().getY()
    var thisMonth: Int = Date().getm()
    
    var course_width: Int = 100
    var course_height: Int = 300
    var course_gap: Int = 10
    
    var dateCourses: [[String: Any]] = [[String: Any]]()
    
    var calendarParams: [String: Any] = [String: Any]()

    override func viewDidLoad() {
        
        myTablView = tableView
        //dataService = MemberService.instance
        _type = "course"
        _titleField = "title"
        searchRows = _searchRows
        //Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        
        calendarParams = makeCalendar(y, m)
        let cellNibName = UINib(nibName: "CalendarSignupCell", bundle: nil)
        myTablView.register(cellNibName, forCellReuseIdentifier: "calendar_signup_cell")
        //myTablView.rowHeight = UITableViewAutomaticDimension
        //myTablView.estimatedRowHeight = 400
        course_width = Int(view.frame.width - 24)
        
        yearTxt.text = String(y)
        let yearLap = UITapGestureRecognizer(target: self, action: #selector(yearPressed))
        yearView.addGestureRecognizer(yearLap)
        
        yearView.layer.borderWidth = 1.0
        yearView.layer.borderColor = UIColor.white.cgColor
        
        monthTxt.text = String(m)
        let monthLap = UITapGestureRecognizer(target: self, action: #selector(monthPressed))
        monthView.addGestureRecognizer(monthLap)
        
        monthView.layer.borderWidth = 1.0
        monthView.layer.borderColor = UIColor.white.cgColor
        
        let nextMonthLap = UITapGestureRecognizer(target: self, action: #selector(nextMonthPressed))
        nextMonthTxt.addGestureRecognizer(nextMonthLap)
        
        let prevMonthLap = UITapGestureRecognizer(target: self, action: #selector(prevMonthPressed))
        prevMonthTxt.addGestureRecognizer(prevMonthLap)
        
        let nowMonthLap = UITapGestureRecognizer(target: self, action: #selector(nowMonthPressed))
        nowMonthTxt.addGestureRecognizer(nowMonthLap)
        
//        dateSelectView.layer.borderWidth = 2.0
//        dateSelectView.layer.borderColor = UIColor.red.cgColor
//        preNextMonthView.layer.borderWidth = 2.0
//        preNextMonthView.layer.borderColor = UIColor.blue.cgColor
        
    }
    
    @objc func yearPressed() {
        //print("year")
        let dialog = SelectionDialog(title: "選擇年", closeButtonTitle: "關閉")
        for i in y...y+5 {
            dialog.addItem(item: String(i)) {
                //print(i)
                self.yearTxt.text = String(i)
                self.y = i
                self.m = Int(self.monthTxt.text!)!
                dialog.close()
                self.refresh()
            }
        }
        dialog.show()
    }
    
    @objc func monthPressed() {
        //print("year")
        let dialog = SelectionDialog(title: "選擇月", closeButtonTitle: "關閉")
        for i in 1...12 {
            dialog.addItem(item: String(i)) {
                //print(i)
                self.monthTxt.text = String(i)
                self.m = i
                self.y = Int(self.yearTxt.text!)!
                dialog.close()
                self.refresh()
            }
        }
        dialog.show()
    }
    
    @objc func nextMonthPressed() {
        m = m + 1
        if m > 12 {
            y = y + 1
            m = 1
        }
        refresh()
    }
    
    @objc func prevMonthPressed() {
        m = m - 1
        if m < 0 {
            y = y - 1
            m = 12
        }
        refresh()
    }
    
    @objc func nowMonthPressed() {
        y = thisYear
        m = thisMonth
        refresh()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        params1.merge(["member_token": Member.instance.token])
        params1.merge(["y": y])
        params1.merge(["m": m])
        //monthLastDay = Global.instance.getMonthLastDay(year: year, month: month)
        selectedYearTxt.text = String(y)
        selectedMonthTxt.text = String(m)
        let res = MemberService.instance.memberSignupCalendar(year: y, month: m) { (success) in
            if (success) {
                self.getDataEnd(success: success)
            } else {
                self.warning(self.dataService.msg)
            }
            Global.instance.removeSpinner(superView: self.view)
        }
        if !res.success {
            Global.instance.removeSpinner(superView: self.view)
            warning(res.msg)
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

            makeCourseArr()
            //print(dateCourses)
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lists1.count > 0 {
            let d: Int = calendarParams["monthLastDay"] as? Int ?? 0
            return d
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let d: [String: Any] = dateCourses[indexPath.row]
        guard let courses: [SuperCourse] = d["rows"] as? [SuperCourse] else { return 44}
        if courses.count > 0 {
            let height: Int = course_height * courses.count + ((courses.count-1)*10) + 80
            return CGFloat(height)
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == myTablView {
//            let cell = CalendarSignupCell(style: .default, reuseIdentifier: "cell")
//            let dateCourse = dateCourses[indexPath.row]
//            cell.update(dateCourse, course_width: course_width, course_height: course_height, course_gap: course_gap)
//            return cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "calendar_signup_cell", for: indexPath) as? CalendarSignupCell {

                for view in cell.courseContainer.subviews {
                    view.removeFromSuperview()
                }
                //cell.dateTxt.text = ""
                let dateCourse = dateCourses[indexPath.row]
                cell.update(dateCourse, course_width: course_width, course_height: course_height, course_gap: course_gap)

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func makeCourseArr() {
        dateCourses.removeAll()
        if let d: Int = calendarParams["monthLastDay"] as? Int {
            for day in 1...d {
                var course: [String: Any] = [String: Any]()
                let date: String = String(format: "%4d-%02d-%02d", y, m, day)
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
            //print(dateCourses)
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
