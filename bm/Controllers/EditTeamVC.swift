//
//  EditTeamVC.swift
//  bm
//
//  Created by ives on 2021/11/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class EditTeamVC: EditVC {
    
    var myTable: TeamTable? = nil
    
//    var testData: [String: String] = [
//        TITLE_KEY: "測試與球隊",
//        CITY_KEY: "218",
//        ARENA_KEY: "6",
//        WEEKDAY_KEY: "3",
//        START_TIME_KEY: "19:00",
//        END_TIME_KEY: "21:00",
//        DEGREE_KEY: "high,soso",
//        TEAM_BALL_KEY: "RSL4號",
//        TEAM_TEMP_FEE_M_KEY: "300",
//        TEAM_TEMP_FEE_F_KEY: "200",
//        TEAM_LEADER_KEY: "2",
//        LINE_KEY: "rich@gmail.com",
//        MOBILE_KEY: "0920123456",
//        EMAIL_KEY: "john@housetube.tw",
//        YOUTUBE_KEY: "youtube",
//        FB_KEY: "fb",
//        CHARGE_KEY: "收費詳細說明",
//        CONTENT_KEY: "這是內容說明"
//    ]
    
    override func viewDidLoad() {
        
        myTablView = tableView
        dataService = TeamService.instance
        if title == nil {
            title = "課程"
        }
        
        super.viewDidLoad()
        
        if token != nil && token!.count > 0 {
            refresh()
        } else {
            myTable = TeamTable()
            myTable!.name = "測試與球隊"
            myTable!.city_id = 218
            myTable!.arena_id = 6
            let arena: ArenaTable = ArenaTable()
            arena.name = "艾婕"
            myTable!.arena = arena
            let weekdays1: Team_WeekdaysTable = Team_WeekdaysTable()
            weekdays1.weekday = 2
            let weekdays2: Team_WeekdaysTable = Team_WeekdaysTable()
            weekdays2.weekday = 4
            myTable!.weekdays = [weekdays1, weekdays2]
            myTable!.play_start = "19:00:00"
            myTable!.play_end = "21:00:00"
            myTable!.degree = "high,soso"
            myTable!.ball = "RSL4號"
            myTable!.temp_fee_M = 300
            myTable!.temp_fee_F = 200
            myTable!.manager_id = 1
            myTable!.manager_nickname = "xxx"
            myTable!.line = "rich@gmail.com"
            myTable!.mobile = "0920123456"
            myTable!.email = "john@housetube.tw"
            myTable!.youtube = "youtube"
            myTable!.fb = "fb"
            myTable!.charge = "收費詳細說明"
            myTable!.content = "這是內容說明"
            myTable!.filterRow()
            
            initData()
        }
    }
    
    override func refresh() {
        
        Global.instance.addSpinner(superView: view)
        let params: [String: String] = ["token": token!]
        dataService.getOne(params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                let jsonData: Data = self.dataService.jsonData!
                do {
                    self.myTable = try JSONDecoder().decode(TeamTable.self, from: jsonData)
                    if (self.myTable != nil) {
                        self.myTable!.filterRow()
                        self.initData()
                        //self.putValue()
                        self.titleLbl.text = self.myTable!.name
                        self.tableView.reloadData()
                    }
                } catch {
                    self.warning(error.localizedDescription)
                }
                
                
//                let table: Table = CourseService.instance.table!
//                self.courseTable = table as? CourseTable
//                self.putValue()
//                self.titleLbl.text = table.title
//                self.tableView.reloadData()
            } else {
                self.warning(TeamService.instance.msg)
            }
            self.endRefresh()
        }
    }
    
    func initData() {
        
        if myTable == nil {
            myTable = TeamTable()
        }
        
        var rows: [OneRow] = [OneRow]()
        var row: OneRow = OneRow(title: "名稱", value: myTable!.name, show: myTable!.name, key: NAME_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "羽球密碼羽球隊", isRequired: true)
        row.msg = "球隊名稱沒有填寫"
        rows.append(row)
        row = OneRow(title: "縣市", value: String(myTable!.city_id), show: myTable!.city_show, key: CITY_KEY, cell: "more", keyboard: KEYBOARD.default, placeholder: "", isRequired: true)
        row.msg = "沒有選擇縣市"
        rows.append(row)
        row = OneRow(title: "球館", value: String(myTable!.arena_id), show: myTable!.arena!.name, key: "arena_id", cell: "more", keyboard: KEYBOARD.default, placeholder: "", isRequired: true)
        row.msg = "沒有選擇球館"
        rows.append(row)
        
        var section: OneSection = makeSectionRow(title: "基本資料", key: "general", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "球隊狀態", value: myTable!.status, show: myTable!.status_show, key: STATUS_KEY, cell: "switch")
        rows.append(row)
        var weekdays: Int = 0
        for weekday in myTable!.weekdays {
            let n: Int = (pow(2, weekday.weekday) as NSDecimalNumber).intValue
            weekdays = weekdays | n
        }
        row = OneRow(title: "星期幾", value: String(weekdays), show: myTable!.weekdays_show, key: WEEKDAY_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇星期幾"
        rows.append(row)
        row = OneRow(title: "開始時間", value: myTable!.play_start, show: myTable!.play_start_show, key: TEAM_PLAY_START_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇開始時間"
        rows.append(row)
        row = OneRow(title: "結束時間", value: myTable!.play_end, show: myTable!.play_end_show, key: TEAM_PLAY_END_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇結束時間"
        rows.append(row)
        row = OneRow(title: "程度", value: myTable!.degree, show: myTable!.degree_show, key: DEGREE_KEY, cell: "more")
        rows.append(row)
        row = OneRow(title: "球種", value: myTable!.ball, show: myTable!.ball, key: TEAM_BALL_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "RSL4號球")
        rows.append(row)
        section = makeSectionRow(title: "打球資料", key: "charge", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "臨打狀態", value: myTable!.temp_status, show: myTable!.temp_status_show, key: TEAM_TEMP_STATUS_KEY, cell: "switch")
        rows.append(row)
        row = OneRow(title: "臨打日期", value: myTable!.last_signup_date, show: myTable!.last_signup_date, key: TEAM_TEMP_DATE_KEY, cell: "more")
        rows.append(row)
        row = OneRow(title: "臨打名額", value: String(myTable!.people_limit), show: String(myTable!.people_limit), key: PEOPLE_LIMIT_KEY, cell: "textField")
        rows.append(row)
        row = OneRow(title: "臨打費用-男", value: String(myTable!.temp_fee_M), show: String(myTable!.temp_fee_M), key: TEAM_TEMP_FEE_M_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "300")
        rows.append(row)
        row = OneRow(title: "臨打費用-女", value: String(myTable!.temp_fee_F), show: String(myTable!.temp_fee_F), key: TEAM_TEMP_FEE_F_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "200")
        rows.append(row)
        row = OneRow(title: "臨打說明", value: myTable!.temp_content, show: myTable!.temp_content, key: TEAM_TEMP_CONTENT_KEY, cell: "more")
        rows.append(row)
        section = makeSectionRow(title: "臨打資料", key: "tempplay", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "隊長", value: String(myTable!.manager_id), show: myTable!.manager_nickname, key: MANAGER_ID_KEY, cell: "more", isRequired: false)
        row.token = myTable!.manager_token
        rows.append(row)
        row = OneRow(title: "line", value: myTable!.line, show: myTable!.line, key: LINE_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "david221")
        rows.append(row)
        row = OneRow(title: "行動電話", value: myTable!.mobile, show: myTable!.mobile, key: MOBILE_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "0939123456")
        rows.append(row)
        row = OneRow(title: "EMail", value: myTable!.email, show: myTable!.email, key: EMAIL_KEY, cell: "textField", keyboard: KEYBOARD.emailAddress, placeholder: "service@bm.com")
        rows.append(row)
        row = OneRow(title: "youtube代碼", value: myTable!.youtube, show: myTable!.youtube, key: YOUTUBE_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "請輸入youtube代碼", isRequired: false)
        rows.append(row)
        row = OneRow(title: "FB", value: myTable!.fb, show: myTable!.fb, key: FB_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "請輸入FB網址", isRequired: false)
        rows.append(row)
        
        
        section = makeSectionRow(title: "聯絡資料", key: "course", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "收費詳細說明", value: myTable!.charge, show: myTable!.charge, key: CHARGE_KEY, cell: "more")
        rows.append(row)
        row = OneRow(title: "更多詳細說明", value: myTable!.content, show: myTable!.content, key: CONTENT_KEY, cell: "more")
        rows.append(row)
        
        section = makeSectionRow(title: "詳細說明", key: "content", rows: rows)
        oneSections.append(section)
        
        if myTable!.featured_path.count > 0 {
            featuredView.setPickedImage(url: myTable!.featured_path)
        }
    }
    
    @IBAction override func submit(_ sender: Any) {
        
        params.removeAll()
        params["cat_id"] = String(21)
        super.submit(sender)
    }
    
    override func submitValidate() {
        
        let row: OneRow = getOneRowFromKey(TEAM_TEMP_DATE_KEY)
        let temp_date_string: String = row.value
        if let temp_date = temp_date_string.toDateTime(format: "yyyy-MM-dd") {
            //print(temp_date)
            if temp_date.isSmallerThan(Date()) {
                msg = "臨打日期必須在明天之後\n"
            }
        }
    }
    
//    func putValue() {
//        if courseTable != nil {
//            
//            let mirror: Mirror = Mirror(reflecting: courseTable!)
//            let propertys: [[String: Any]] = mirror.toDictionary()
//            
//            for formItem in form.formItems {
//                
//                for property in propertys {
//                    
//                    if ((property["label"] as! String) == formItem.name) {
//                        var type: String = property["type"] as! String
//                        type = type.getTypeOfProperty()!
//                        //print("label=>\(property["label"]):value=>\(property["value"]):type=>\(type)")
//                        var content: String = ""
//                        if type == "Int" {
//                            content = String(property["value"] as! Int)
//                        } else if type == "Bool" {
//                            content = String(property["value"] as! Bool)
//                        } else if type == "String" {
//                            content = property["value"] as! String
//                        }
//                        formItem.value = content
//                        formItem.make()
//                        break
//                    }
//                }
//            }
//            
//            let featured_path = courseTable!.featured_path
//            if featured_path.count > 0 {
//                //print(featured_path)
//                featuredView.setPickedImage(url: featured_path)
//            }
//            //featuredView.setPickedImage(image: superCourse!.featured)
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return oneSections.count
//    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count: Int = 0
//        if !oneSections[section].isExpanded {
//            count = 0
//        } else {
//            count = oneSections[section].items.count
//        }
//        
//        return count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let row = getOneRowFromIdx(indexPath.section, indexPath.row)
//        let cell_type: String = row.cell
//
//        if (cell_type == "textField") {
//            if let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as? TextFieldCell {
//
//                //let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
//                cell.cellDelegate = self
//                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
//
//                return cell
//            }
//        } else if (row.cell == "more") {
//            if let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as? MoreCell {
//
//                cell.cellDelegate = self
//                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
//
//                return cell
//            }
//        }
//
//        return UITableViewCell()
//    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
//
//        if (row.cell == "more") {
//            moreClickForOne(key: row.key, row: row, delegate: self)
//        }
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let indexPath = sender as! IndexPath
//        let item = getFormItemFromIdx(indexPath)
//        if item != nil {
//            var rows: [[String: String]]? = nil
//            if segue.identifier == TO_SINGLE_SELECT {
//
//                let vc: SingleSelectVC = segue.destination as! SingleSelectVC
//
//                if item!.name == PRICE_UNIT_KEY {
//                    rows = PRICE_UNIT.makeSelect()
//                } else if item!.name == CYCLE_UNIT_KEY {
//                    rows = CYCLE_UNIT.makeSelect()
//                } else if item!.name == COURSE_KIND_KEY {
//                    rows = COURSE_KIND.makeSelect()
//                } else if item!.name == START_TIME_KEY || item!.name == END_TIME_KEY {
//                    let times = Global.instance.makeTimes()
//                    rows = [[String: String]]()
//                    for time in times {
//                        rows!.append(["title": time, "value": time+":00"])
//                    }
//                }
//                if rows != nil {
//                    vc.rows1 = rows
//                }
//
//                vc.key = item!.name
//                vc.title = item!.title
//                vc.delegate = self
//            } else if segue.identifier == TO_MULTI_SELECT {
//                let vc: MultiSelectVC = segue.destination as! MultiSelectVC
//
//                if item!.name == WEEKDAY_KEY {
//                    rows = WEEKDAY.makeSelect()
//                    //print(rows)
//                    if item!.sender != nil {
//                        let selecteds = item!.sender as! [String]
//                        //print(selecteds)
//                        vc.selecteds = selecteds
//                    }
//                }
//
//                if rows != nil {
//                    vc.rows1 = rows
//                }
//
//                vc.key = item!.name
//                vc.title = item!.title
//                vc.delegate = self
//            } else if segue.identifier == TO_CONTENT_EDIT {
//                let vc: ContentEditVC = segue.destination as! ContentEditVC
//                if item!.name == CONTENT_KEY {
//                    if item!.sender != nil {
//                        let content = item!.sender as! String
//                        vc.content = content
//                    }
//                }
//                vc.key = item!.name
//                vc.title = item!.title
//                vc.delegate = self
//            } else if segue.identifier == TO_SELECT_DATE {
//                let vc: DateSelectVC = segue.destination as! DateSelectVC
//                vc.key = item!.name
//                vc.selected = item!.value!
//                vc.title = item!.title
//                vc.delegate = self
//            }
//
//        }
//    }
    
//    func textFieldTextChanged(formItem: FormItem, text: String) {
//        formItem.value = text
//        //print(text)
//    }
    
//    @IBAction func cancel(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
//        prev()
//    }
}
