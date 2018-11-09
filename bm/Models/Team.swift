//
//  Team.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class Team: SuperData {
    static let instance = Team()
    let _sections: [String] = ["", "聯絡資訊", "所在地", "打球時間", "臨打說明", "其他說明"]
    let _rows: [[String]] = [
        [NAME_KEY],
        [TEAM_LEADER_KEY,MOBILE_KEY,EMAIL_KEY],
        [CITY_KEY,ARENA_KEY],
        [TEAM_DAYS_KEY,TEAM_PLAY_START_KEY,TEAM_PLAY_END_KEY],
        [TEAM_TEMP_FEE_M_KEY,TEAM_TEMP_FEE_F_KEY,TEAM_TEMP_CONTENT_KEY],
        [TEAM_BALL_KEY,TEAM_DEGREE_KEY,CHARGE_KEY,CONTENT_KEY]
    ]
//    var data:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()
    var data1:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()
    var data2:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()

    var testData: [String: Any] = [String: Any]()
    
    let temp_play_edit_sections: [String] = [""]
    let temp_play_edit_rows: [[Dictionary<String, String>]] = [
        [
            ["key": TEAM_TEMP_STATUS_KEY], ["key": TEAM_TEMP_QUANTITY_KEY]
        ]
    ]

    let temp_play_list_sections: [String] = [""]
    let temp_play_list_rows: [[Dictionary<String, String>]] = [
        [
            ["key": NAME_KEY], ["key": TEAM_TEMP_QUANTITY_KEY]
        ]
    ]
    var list: [DATA] = [DATA]()
    
    override init() {
        super.init()
        sections = _sections
        rows = _rows
        self.initData()
        self.initTempPlayData()
    }
    
    override init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        super.init(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
        sections = _sections
        rows = _rows
        initData()
    }
    override func listReset() {
        sections = _sections
        rows = _rows
        initData()
    }
    
    override func initData() {
        data1 = [
            ID_KEY:["ch":"編號","vtype":"Int","value":-1,"submit":false,"show":""],
            CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","submit":false,"show":""],
            WEBSITE_KEY:["ch":"網站","vtype":"String","value":"","submit":false,"show":""],
            FB_KEY:["ch":"FB","vtype":"String","value":"","submit":false,"show":""],
            YOUTUBE_KEY:["ch":"youtube","vtype":"String","value":"","submit":false,"show":""],
            SLUG_KEY:["ch":"插槽","vtype":"String","value":"","submit":true,"show":""],
            MANAGER_ID_KEY:["ch":"管理者編號","vtype":"Int","value":-1,"submit":false,"show":""],
            TEAM_TEMP_QUANTITY_KEY:["ch":"臨打人數缺額","vtype":"Int","value":-1,"submit":false,"show":""],
            TEAM_TEMP_STATUS_KEY:["ch":"臨打狀態","vtype":"String","value":"","submit":false,"show":""],
            PV_KEY:["ch":"瀏覽數","vtype":"Int","value":-1,"submit":false,"show":""],
            TOKEN_KEY:["ch":"球隊token","vtype":"String","value":"","submit":false,"show":""],
            CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":-1,"submit":false,"show":""],
            CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","submit":false,"show":""],
            UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","submit":false,"show":""],
            THUMB_KEY:["ch":"代表圖","vtype":"String","value":"","submit":false,"show":""],
            TEAM_NEAR_DATE_KEY:["ch":"下次臨打日期","vtype":"String","value":"","value1":"","submit":false,"show":""],
            TEAM_TEMP_SIGNUP_KEY:["ch":"已報名人數","vtype":"String","value":"","submit":false,"show":""]
        ]
        data2 = [
            NAME_KEY:["ch":"名稱","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":defaultPad,"text_field":true],
            TEAM_LEADER_KEY:["ch":"聯絡人","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":defaultPad,"text_field":true],
            MOBILE_KEY:["ch":"電話","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":phonePad,"text_field":true],
            EMAIL_KEY:["ch":"EMail","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":emailPad,"text_field":true],
            TEAM_PLAY_START_KEY:["ch":"開始時間","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_SELECT_TIME,"sender":[String: Any](),"show":""],
            TEAM_PLAY_END_KEY:["ch":"結束時間","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_SELECT_TIME,"sender":[String: Any](),"show":""],
            TEAM_INTERVAL_KEY:["ch":"打球時段","vtype":"String","value":"","submit":true,"atype":none,"segue":TO_SELECT_TIME,"sender":[String: Any](),"show":""],
            TEAM_BALL_KEY:["ch":"使用球種","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":defaultPad,"text_field":true],
            TEAM_DEGREE_KEY:["ch":"球隊程度","vtype":"array","value":[String](),"submit":true,"atype":more,"segue":TO_SELECT_DEGREE,"sender":[Degree](),"show":""],
            CHARGE_KEY:["ch":"收費說明","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_TEXT_INPUT,"sender":[String: Any](),"show":""],
            CONTENT_KEY:["ch":"詳細說明","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_TEXT_INPUT,"sender":[String: Any](),"show":""],
            TEAM_TEMP_FEE_M_KEY:["ch":"臨打費用：男","vtype":"Int","value":-1,"submit":true,"atype":none,"show":"","keyboardType":numberPad,"text_field":true],
            TEAM_TEMP_FEE_F_KEY:["ch":"臨打費用：女","vtype":"Int","value":-1,"submit":true,"atype":none,"show":"","keyboardType":numberPad,"text_field":true],
            TEAM_TEMP_CONTENT_KEY:["ch":"臨打說明","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_TEXT_INPUT,"sender":[String: Any](),"show":""],
            CITY_KEY:["ch":"區域","vtype":"array","value":0,"submit":true,"atype":more,"segue":TO_CITY,"sender":0,"show":""],
            ARENA_KEY:["ch":"球館","vtype":"array","value":0,"submit":true,"atype":more,"segue":TO_ARENA,"sender":[String: Int](),"show":""],
            TEAM_DAYS_KEY:["ch":"星期幾","vtype":"array","value":[Int](),"submit":true,"atype":more,"segue":TO_DAY,"sender":[Int](),"show":""],
            FEATURED_KEY:["ch":"代表圖","vtype":"image","value":UIImage(named: "nophoto")!,"path":"","submit":false,"show":""]
        ]
        for (key, _) in data2 {
            data2[key]!["change"] = false
        }
        
        data.merge(data1)
        data.merge(data2)
        setSectionAndRow()
        _initData2()
        //print("2. \(data["name"])")
        
        for (key, _) in data {
            data[key]!["key"] = key
        }
        //runTestData()
        //data["play_end"]!["value"] = "ccc"
    }
    
    func initTempPlayData() {
        temp_play_data = [
            ID_KEY:["ch":"編號","vtype":"Int","value":-1,"show":"","atype":none,"submit":false],
            NAME_KEY:["ch":"名稱","vtype":"String","value":"","submit":false,"atype":none,"show":"","keyboardType":defaultPad],
            TEAM_TEMP_STATUS_KEY:["ch":"臨打狀態","vtype":"String","value":"off","show":"off","atype":none,"itype":"switch","submit":true,"change":false],
            TEAM_TEMP_QUANTITY_KEY:["ch":"臨打人數","vtype":"Int","value":-1,"show":"","atype":none,"itype":"text","keyboardType":numberPad,"hidden":true,"submit":true,"change":false]
        ]
        for (section, value1) in temp_play_edit_rows.enumerated() {
            for (row, value2) in value1.enumerated() {
                let key: String = value2["key"]!
                for (key1, _) in temp_play_data {
                    if key == key1 {
                        temp_play_data[key1]!["section"] = section
                        temp_play_data[key1]!["row"] = row
                    }
                }
            }
        }
        for (key, _) in temp_play_data {
            temp_play_data[key]!["key"] = key
        }
    }
    
    func runTestData() {
         testData = [
         NAME_KEY: "快樂羽球隊",
         TEAM_LEADER_KEY: "孫志煌",
         MOBILE_KEY: "0911299994",
         EMAIL_KEY: "ives@housetube.tw",
         TEAM_TEMP_FEE_M_KEY: 150,
         TEAM_TEMP_FEE_F_KEY: 100,
         TEAM_BALL_KEY: "RSL 4",
         CONTENT_KEY: "請勿報名沒有來，列入黑名單",
         CHARGE_KEY: "一季3600含球",
         TEAM_TEMP_CONTENT_KEY: "歡迎加入",
         TEAM_PLAY_START_KEY: "16:00",
         TEAM_PLAY_END_KEY: "18:00",
         TEAM_DEGREE_KEY: [Degree(value:DEGREE.high,text:""), Degree(value: DEGREE.high, text: "")],
         TEAM_DAYS_KEY: [2, 4],
         CITY_KEY: City(id:218, name: "台南"),
         ARENA_KEY: Arena(id: 10, name: "全穎羽球館")
         ]
        if testData.count > 0 {
            for (key1, value) in testData {
                if key1 == CITY_KEY {
                    let city: City = value as! City
                    data[key1]!["value"] = city.id
                    data[key1]!["show"] = city.name
                } else if key1 == ARENA_KEY {
                    let arena: Arena = value as! Arena
                    data[key1]!["value"] = arena.id
                    data[key1]!["show"] = arena.title
                } else {
                    for (key2, row) in data {
                        if key1 == key2 {
                            data[key2]!["value"] = value
                            let vtype: String = row["vtype"] as! String
                            if vtype != "array" {
                                data[key2]!["show"] = "\(value)"
                            }
                        }
                    }
                }
                data[key1]!["change"] = true
            }
            updateDays(testData[TEAM_DAYS_KEY] as! [Int])
            updateDegree(testData[TEAM_DEGREE_KEY] as! [Degree])
        }
    }
    
    private func _initData2() {
        updatePlayStartTime()
        updatePlayEndTime()
        updateTempContent()
        updateCharge()
        updateContent()
    }
    
    override func updateCity(_ city: City) {
        super.updateCity(city)
        setArenaSender()
    }
    override func updateArena(_ arena: Arena) {
        data[ARENA_KEY]!["value"] = arena.id
        data[ARENA_KEY]!["show"] = arena.title
        setArenaSender()
    }
    override func updateDays(_ days: [Int]) {
        data[TEAM_DAYS_KEY]!["value"] = days
        daysShow()
        setDaysSender()
    }
    override func updateDegree(_ degrees: [Degree]) {
        var res: [String] = [String]()
        for degree in degrees {
            res.append(DEGREE.DBValue(degree.value))
        }
        data[TEAM_DEGREE_KEY]!["value"] = res
        degreeShow()
        setDegreeSender(degrees)
    }
    override func updatePlayStartTime(_ time: String? = nil) {
        if time != nil {
            data[TEAM_PLAY_START_KEY]!["value"] = time
        }
        let tmp: String = data[TEAM_PLAY_START_KEY]!["value"] as! String
        data[TEAM_PLAY_START_KEY]!["show"] = tmp.noSec()
        setPlayStartTimeSender()
    }
    override func updatePlayEndTime(_ time: String? = nil) {
        if time != nil {
            data[TEAM_PLAY_END_KEY]!["value"] = time
        }
        let tmp: String = data[TEAM_PLAY_END_KEY]!["value"] as! String
        data[TEAM_PLAY_END_KEY]!["show"] = tmp.noSec()
        setPlayEndTimeSender()
    }
    override func updateInterval(_ _startTime: String? = nil, _ _endTime: String? = nil) {
        var startTime = _startTime
        if startTime == nil {
            startTime = data[TEAM_PLAY_START_KEY]!["show"] as? String
        }
        var endTime = _endTime
        if endTime == nil {
            endTime = data[TEAM_PLAY_END_KEY]!["show"] as? String
        }
        let tmp: String = startTime! + " ~ " + endTime!
        data[TEAM_INTERVAL_KEY]!["show"] = tmp
    }
    override func updateTempContent(_ content: String? = nil) {
        if content != nil {
            data[TEAM_TEMP_CONTENT_KEY]!["value"] = content
        }
        tempContentShow()
        setTempContentSender()
    }
    
    override func updateNearDate(_ n1: String? = nil, _ n2: String? = nil) {
        var nn1: String = ""
        var nn2: String = ""
        if n1 != nil {
            data[TEAM_NEAR_DATE_KEY]!["value"] = n1
            nn1 = n1!
        } else {
            nn1 = (data[TEAM_NEAR_DATE_KEY]!["value"] as! String)
        }
        if n2 != nil {
            data[TEAM_NEAR_DATE_KEY]!["value1"] = n2
            nn2 = n2!
        } else {
            nn2 = (data[TEAM_NEAR_DATE_KEY]!["value1"] as! String)
        }
        let n: String = nn1 + "(" + nn2 + ")"
        data[TEAM_NEAR_DATE_KEY]!["show"] = n
    }
    
    func daysShow() {
        let row: [String: Any] = data[TEAM_DAYS_KEY]!
        if row["value"] != nil {
            let days: [Int] = row["value"] as! [Int]
            if days.count > 0 {
                var res: [String] = [String]()
                for day in days {
                    for item in Global.instance.days {
                        let idx: Int = item["value"] as! Int
                        let text: String = item["text"] as! String
                        if idx == day {
                            res.append(text)
                        }
                    }
                }
                let show: String = res.joined(separator: ", ")
                data[TEAM_DAYS_KEY]!["show"] = show
            } else {
                data[TEAM_DAYS_KEY]!["show"] = "未提供"
            }
        }
    }
    func degreeShow() {
        let degrees: [String] = data[TEAM_DEGREE_KEY]!["value"] as! [String]
        var res: [String] = [String]()
        for degree in degrees {
            let type: DEGREE = DEGREE.enumFromString(string: degree)
            let text: String = type.rawValue
            res.append(text)
        }
        data[TEAM_DEGREE_KEY]!["show"] = res.joined(separator: ", ")
    }
    func tempContentShow(_ length: Int=15) {
        var text: String = data[TEAM_TEMP_CONTENT_KEY]!["value"] as! String
        text = text.truncate(length: length)
        data[TEAM_TEMP_CONTENT_KEY]!["show"] = text
    }
    
    override func feeShow() {
        var text: String = ""
        text = data[TEAM_TEMP_FEE_M_KEY]!["show"] as! String
        data[TEAM_TEMP_FEE_M_KEY]!["show"] = text
        text = data[TEAM_TEMP_FEE_F_KEY]!["show"] as! String
        data[TEAM_TEMP_FEE_F_KEY]!["show"] = text
    }
    
    func setArenaSender() {
        var arena_sender: [String: Int] = [String: Int]()
        let city_id: Int = data[CITY_KEY]!["value"] as! Int
        let arena_id: Int = data[ARENA_KEY]!["value"] as! Int
        arena_sender["city_id"] = city_id
        arena_sender["arena_id"] = arena_id
        data[ARENA_KEY]!["sender"] = arena_sender
    }
    func setDaysSender() {
        data[TEAM_DAYS_KEY]!["sender"] = data[TEAM_DAYS_KEY]!["value"]
    }
    func setDegreeSender(_ degrees: [Degree]) {
        data[TEAM_DEGREE_KEY]!["sender"] = degrees
    }
    func setPlayStartTimeSender() {
        var res: [String: Any] = [String: Any]()
        var time: String = data[TEAM_PLAY_START_KEY]!["value"] as! String
        time = time.noSec()
        res["type"] = SELECT_TIME_TYPE.play_start
        res["time"] = time
        data[TEAM_PLAY_START_KEY]!["sender"] = res
    }
    func setPlayEndTimeSender() {
        var res: [String: Any] = [String: Any]()
        var time: String = data[TEAM_PLAY_END_KEY]!["value"] as! String
        time = time.noSec()
        res["type"] = SELECT_TIME_TYPE.play_end
        res["time"] = time
        data[TEAM_PLAY_END_KEY]!["sender"] = res
    }
    func setTempContentSender() {
        var res: [String: Any] = [String: Any]()
        let text: String = data[TEAM_TEMP_CONTENT_KEY]!["value"] as! String
        res["text"] = text
        res["type"] = TEXT_INPUT_TYPE.temp_play
        data[TEAM_TEMP_CONTENT_KEY]!["sender"] = res
    }
    override func setContentSender() {
        var res: [String: Any] = [String: Any]()
        let text: String = data[CONTENT_KEY]!["value"] as! String
        res["text"] = text
        res["type"] = TEXT_INPUT_TYPE.team
        data[CONTENT_KEY]!["sender"] = res
    }
    
    override func makeSubmitArr() -> [String: Any] {
        var isAnyOneChange: Bool = false
        var res: [String: Any] = [String: Any]()
        for (key, row) in data {
            var isSubmit: Bool = false
            if row["submit"] != nil {
                isSubmit = row["submit"] as! Bool
            }
            var isChange: Bool = false
            if row["change"] != nil {
                isChange = row["change"] as! Bool
            }
            if isSubmit && isChange {
                res[key] = row["value"]
                if !isAnyOneChange {
                    isAnyOneChange = true
                }
            }
        }
        if !isAnyOneChange {
            return res
        }
        res[SLUG_KEY] = data[NAME_KEY]!["value"]
        res[CREATED_ID_KEY] = Member.instance.id
        var id: Int = -1
        if data[ID_KEY]!["value"] != nil {
            id = data[ID_KEY]!["value"] as! Int
        }
        if id < 0 {
            res[MANAGER_ID_KEY] = Member.instance.id
            res[CHANNEL_KEY] = "bm"
            res["type"] = "team"
            let cat_id: [Int] = [21]
            res[CAT_KEY] = cat_id
        } else {
            res[ID_KEY] = id
        }
        for (key, value) in transferPair {
            res[value] = res[key]
            res.removeValue(forKey: key)
        }
        
        return res
    }
    func makeTempPlaySubmitArr() -> [String: Any] {
        var isAnyOneChange: Bool = false
        var res: [String: Any] = [String: Any]()
        for (key, row) in temp_play_data {
            let isSubmit: Bool = row["submit"] as! Bool
            var isChange: Bool = false
            if row["change"] != nil {
                isChange = row["change"] as! Bool
            }
            if isSubmit && isChange {
                res[key] = row["value"]
                if !isAnyOneChange {
                    isAnyOneChange = true
                }
            }
        }
        if !isAnyOneChange {
            return res
        }
        res[ID_KEY] = temp_play_data[ID_KEY]!["value"]
        
        return res
    }
    
    func hideOrShowTempPlayData() {
        let statusStr: String = temp_play_data[TEAM_TEMP_STATUS_KEY]!["value"] as! String
        let status = statusStr == "on" ? true : false
        for (key, item) in temp_play_data {
            if item["section"] != nil && item["row"] != nil {
                if key != TEAM_TEMP_STATUS_KEY {
                    temp_play_data[key]!["hidden"] = !status
                }
            }
        }
    }
}
