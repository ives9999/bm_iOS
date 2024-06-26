//
//  CourseCalendarVC.swift
//  bm
//
//  Created by ives on 2019/11/16.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SCLAlertView
//import SelectionDialog

class CourseCalendarVC: MyTableVC {
    
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
        ["title":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入課程名稱關鍵字","text_field":true,"value":"","value_type":"String"],
        ["title":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":0,"value":"","value_type":"Array"],
        ["title":"日期","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":[Int](),"value":"","value_type":"Array"],
        ["title":"開始時間之後","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"],
        ["title":"結束時間之前","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":END_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"]
    ]
    
    var mysTable: CoursesTable? = nil
    internal(set) public var lists2: [SuperModel] = [SuperModel]()
    
    //let session: UserDefaults = UserDefaults.standard
    var params2: [String: Any] = [String: Any]()
    
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
        //_type = "course"
        //_titleField = "title"
        //searchRows = _searchRows
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
    
//    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
//        //print(page)
//        Global.instance.addSpinner(superView: self.view)
//        
//        params2.merge(["member_token": Member.instance.token])
//        params2.merge(["y": y])
//        params2.merge(["m": m])
//        //monthLastDay = Global.instance.getMonthLastDay(year: year, month: month)
//        selectedYearTxt.text = String(y)
//        selectedMonthTxt.text = String(m)
//        let res = MemberService.instance.memberSignupCalendar(year: y, month: m) { (success) in
//            if (success) {
//                self.getDataEnd(success: success)
//            } else {
//                self.warning(self.dataService.msg)
//            }
//            Global.instance.removeSpinner(superView: self.view)
//        }
//        if !res.success {
//            Global.instance.removeSpinner(superView: self.view)
//            warning(res.msg)
//        }
//    }
    
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
        if lists1.count > 0 {
            let d: Int = calendarParams["monthLastDay"] as? Int ?? 0
            return d
        } else {
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let d: [String: Any] = dateCourses[indexPath.row]
//        guard let courses: [Course] = d["rows"] as? [SuperCourse] else { return 44}
//        if courses.count > 0 {
//            let height: Int = course_height * courses.count + ((courses.count-1)*10) + 80
//            return CGFloat(height)
//        } else {
//            return 44
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    }
    
    func makeCourseArr() {
        dateCourses.removeAll()
        if let d: Int = calendarParams["monthLastDay"] as? Int {
            for day in 1...d {
                var course: [String: Any] = [String: Any]()
                let date: String = String(format: "%4d-%02d-%02d", y, m, day)
                course["date"] = date
                if let d: Date? = date.toDateTime(format: "yyyy-MM-dd") {
                    let weekday_i: Int = d!.dateToWeekday()
                    let weekday_c: String = d!.dateToWeekdayForChinese()
                    course["weekday_i"] = weekday_i
                    course["weekday_c"] = weekday_c
                    
                    let rows: [CourseTable] = [CourseTable]()
                    for superModel in lists1 {
                        if let courseTable = superModel as? CourseTable {
                            //superCourse.printRow()
    //                        for weekday in courseTable.weekday_arr {
    //                            if weekday == weekday_i {
    //                                rows.append(superCourse)
    //                            }
    //                        }
                        }
                    }
                    course["rows"] = rows
                }
                
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

//    override func singleSelected(key: String, selected: String, show: String?=nil) {
//        var row = getDefinedRow(key)
//        var show = ""
//        if key == START_TIME_KEY || key == END_TIME_KEY {
//            row["value"] = selected
//            show = selected.noSec()
//        }
//        row["show"] = show
//        replaceRows(key, row)
//        searchTableView.reloadData()
//    }
    
//    override func multiSelected(key: String, selecteds: [String]) {
//        var row = getDefinedRow(key)
//        var show = ""
//        if key == WEEKDAY_KEY {
//            var texts: [String] = [String]()
//            for selected in selecteds {
//                let text = WEEKDAY.intToString(Int(selected)!)
//                texts.append(text)
//            }
//            show = texts.joined(separator: ",")
//        } else if key == CITY_KEY {
//            var citys: [[String: String]] = [[String: String]]()
//            if session.array(forKey: "citys") != nil {
//                citys = (session.array(forKey: "citys") as! [[String: String]])
//                //print(citys)
//            }
//            var texts: [String] = [String]()
//            for selected in selecteds {
//                for city in citys {
//                    if city["value"] == selected {
//                        let text = city["title"]!
//                        texts.append(text)
//                        break
//                    }
//                }
//            }
//            show = texts.joined(separator: ",")
//        }
//        row["show"] = show
//        row["value"] = selecteds.joined(separator: ",")
//        replaceRows(key, row)
//        searchTableView.reloadData()
//    }
}
