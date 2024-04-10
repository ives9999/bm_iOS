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
//            myTable!.name = "測試與球隊"
//            myTable!.city_id = 218
//            myTable!.arena_id = 6
//            let arena: ArenaTable = ArenaTable()
//            arena.name = "艾婕"
//            myTable!.arena = arena
//            let weekdays1: Team_WeekdaysTable = Team_WeekdaysTable()
//            weekdays1.weekday = 2
//            let weekdays2: Team_WeekdaysTable = Team_WeekdaysTable()
//            weekdays2.weekday = 4
//            myTable!.weekdays = [weekdays1, weekdays2]
//            myTable!.play_start = "19:00:00"
//            myTable!.play_end = "21:00:00"
//            myTable!.number = 16
//            myTable!.degree = "high,soso"
//            myTable!.ball = "RSL4號"
//            myTable!.temp_fee_M = 300
//            myTable!.temp_fee_F = 200
//            myTable!.manager_id = 1
//            myTable!.manager_nickname = "xxx"
//            myTable!.line = "rich@gmail.com"
//            myTable!.mobile = "0920123456"
//            myTable!.email = "john@housetube.tw"
//            myTable!.youtube = "youtube"
//            myTable!.fb = "fb"
//            myTable!.charge = "收費詳細說明"
//            myTable!.content = "這是內容說明"
//            myTable!.filterRow()
            
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
        
        let manager_id: String = (myTable!.manager_id <= 0) ? "" : String(myTable!.manager_id)
        var row: OneRow = OneRow(title: "管理員", value: manager_id, show: myTable!.manager_nickname, key: MANAGER_ID_KEY, cell: "more", isRequired: false)
        row.prompt = "如果新增者就是管理者，就不用填寫此項目"
        row.token = myTable!.manager_token
        rows.append(row)
        row = OneRow(title: "名稱", value: myTable!.name, show: myTable!.name, key: NAME_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "羽球密碼羽球隊", isRequired: true)
        row.msg = "球隊名稱沒有填寫"
        rows.append(row)
        row = OneRow(title: "縣市", value: String(myTable!.city_id), show: myTable!.city_show, key: CITY_KEY, cell: "more", keyboard: KEYBOARD.default, placeholder: "", isRequired: true)
        row.msg = "沒有選擇縣市"
        rows.append(row)
        row = OneRow(title: "球館", value: String(myTable!.arena_id), show: myTable!.arena!.name, key: ARENA_KEY, cell: "more", keyboard: KEYBOARD.default, placeholder: "", isRequired: true)
        row.msg = "沒有選擇球館"
        rows.append(row)
        
        var section: OneSection = makeSectionRow(title: "基本資料", key: "general", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "球隊狀態", value: myTable!.status, show: myTable!.status_show, key: STATUS_KEY, cell: "switch")
        rows.append(row)
        var weekdays: Int = 0
        for weekday in myTable!.weekdays.num {
            let n: Int = (pow(2, weekday) as NSDecimalNumber).intValue
            weekdays = weekdays | n
        }
        row = OneRow(title: "星期幾", value: String(weekdays), show: myTable!.weekdays_show, key: WEEKDAYS_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇星期幾"
        rows.append(row)
        row = OneRow(title: "開始時間", value: myTable!.play_start, show: myTable!.play_start_show, key: TEAM_PLAY_START_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇開始時間"
        rows.append(row)
        row = OneRow(title: "結束時間", value: myTable!.play_end, show: myTable!.play_end_show, key: TEAM_PLAY_END_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇結束時間"
        rows.append(row)
        row = OneRow(title: "人數", value: String(myTable!.number), show: String(myTable!.number), key: NUMBER_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, isRequired: true)
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
//        row = OneRow(title: "臨打日期", value: myTable!.last_signup_date, show: myTable!.last_signup_date, key: TEAM_TEMP_DATE_KEY, cell: "more")
//        rows.append(row)
//
//        var people_limit: String = ""
//        if (myTable!.people_limit > 0) {
//            people_limit = String(myTable!.people_limit)
//        }
//        row = OneRow(title: "臨打名額", value: people_limit, show: people_limit, key: PEOPLE_LIMIT_KEY, cell: "textField")
//        rows.append(row)
        
        var temp_fee_M: String = ""
        if (myTable!.temp_fee_M >= 0) {
            temp_fee_M = String(myTable!.temp_fee_M)
        }
        row = OneRow(title: "臨打費用-男", value: temp_fee_M, show: temp_fee_M, key: TEAM_TEMP_FEE_M_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "300")
        
        var temp_fee_F: String = ""
        if (myTable!.temp_fee_F >= 0) {
            temp_fee_F = String(myTable!.temp_fee_F)
        }
        rows.append(row)
        row = OneRow(title: "臨打費用-女", value: temp_fee_F, show: temp_fee_F, key: TEAM_TEMP_FEE_F_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "200")
        rows.append(row)
        row = OneRow(title: "臨打說明", value: myTable!.temp_content, show: myTable!.temp_content, key: TEAM_TEMP_CONTENT_KEY, cell: "more")
        rows.append(row)
        section = makeSectionRow(title: "臨打資料", key: "tempplay", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
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
        
        var row: OneRow = getOneRowFromKey(TEAM_TEMP_STATUS_KEY)
        //print(row.value)
        if (row.value == "online") {
            row = getOneRowFromKey(TEAM_TEMP_DATE_KEY)
            let temp_date_string: String = row.value
            if let temp_date = temp_date_string.toDateTime(format: "yyyy-MM-dd") {
                //print(temp_date)
                if temp_date.isSmallerThan(Date()) {
                    msg = "臨打日期必須在明天之後\n"
                }
            }
        }
    }
}
