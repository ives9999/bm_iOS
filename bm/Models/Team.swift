//
//  Team.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class Team {
    static let instance = Team()
    let sections: [String] = ["", "聯絡資訊", "所在地", "打球時間", "臨打說明", "其他說明"]
    let rows: [[Dictionary<String, String>]] = [
        [
            ["key": TEAM_NAME_KEY]
        ],
        [
            ["key": TEAM_LEADER_KEY],["key": TEAM_MOBILE_KEY],["key": TEAM_EMAIL_KEY]
        ],
        [
            ["key": TEAM_CITY_KEY],["key": TEAM_ARENA_KEY]
        ],
        [
            ["key": TEAM_DAYS_KEY],["key": TEAM_PLAY_START_KEY],["key": TEAM_PLAY_END_KEY]
        ],
        [
            ["key": TEAM_TEMP_FEE_M_KEY],["key": TEAM_TEMP_FEE_F_KEY],["key": TEAM_TEMP_CONTENT_KEY]
        ],
        [
            ["key": TEAM_BALL_KEY],["key": TEAM_DEGREE_KEY],["key": TEAM_CHARGE_KEY],["key": TEAM_CONTENT_KEY]
        ]
    ]
    var data:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()
    let transferPair: [String: String] = [TEAM_CITY_KEY:"city_id",TEAM_ARENA_KEY:"arena_id"]
    var testData: [String: Any] = [String: Any]()

    init() {
        
        let none: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
        let more: UITableViewCellAccessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let defaultPad: UIKeyboardType = UIKeyboardType.default
        let numberPad: UIKeyboardType = UIKeyboardType.numberPad
        let phonePad: UIKeyboardType = UIKeyboardType.phonePad
        let emailPad: UIKeyboardType = UIKeyboardType.emailAddress
        
        let data1: Dictionary<String, [String: Any]> = [
            TEAM_ID_KEY:["ch":"編號","vtype":"Int","value":-1,"submit":false,"show":""],
            TEAM_CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","submit":false,"show":""],
            TEAM_WEBSITE_KEY:["ch":"網站","vtype":"String","value":"","submit":false,"show":""],
            TEAM_FB_KEY:["ch":"FB","vtype":"String","value":"","submit":false,"show":""],
            TEAM_YOUTUBE_KEY:["ch":"youtube","vtype":"String","value":"","submit":false,"show":""],
            TEAM_SLUG_KEY:["ch":"插槽","vtype":"String","value":"","submit":true,"show":""],
            TEAM_MANAGER_ID_KEY:["ch":"管理者編號","vtype":"Int","value":-1,"submit":false,"show":""],
            TEAM_TEMP_QUANTITY_KEY:["ch":"臨打人數","vtype":"Int","value":-1,"submit":false,"show":""],
            TEAM_TEMP_STATUS_KEY:["ch":"臨打狀態","vtype":"String","value":"","submit":false,"show":""],
            TEAM_PV_KEY:["ch":"瀏覽數","vtype":"Int","value":-1,"submit":false,"show":""],
            TEAM_TOKEN_KEY:["ch":"球隊token","vtype":"String","value":"","submit":false,"show":""],
            TEAM_CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":-1,"submit":false,"show":""],
            TEAM_CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","submit":false,"show":""],
            TEAM_UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","submit":false,"show":""],
            TEAM_THUMB_KEY:["ch":"代表圖","vtype":"String","value":"","submit":false,"show":""]
            
        ]
        var data2: Dictionary<String, [String: Any]> = [
            TEAM_NAME_KEY:["ch":"名稱","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":defaultPad],
            TEAM_LEADER_KEY:["ch":"隊長","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":defaultPad],
            TEAM_MOBILE_KEY:["ch":"電話","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":phonePad],
            TEAM_EMAIL_KEY:["ch":"EMail","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":emailPad],
            TEAM_PLAY_START_KEY:["ch":"開始時間","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_SELECT_TIME,"sender":[String: Any](),"show":""],
            TEAM_PLAY_END_KEY:["ch":"結束時間","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_SELECT_TIME,"sender":[String: Any](),"show":""],
            TEAM_BALL_KEY:["ch":"使用球種","vtype":"String","value":"","submit":true,"atype":none,"show":"","keyboardType":defaultPad],
            TEAM_DEGREE_KEY:["ch":"球隊程度","vtype":"array","value":[String](),"submit":true,"atype":more,"segue":TO_SELECT_DEGREE,"sender":[String](),"show":""],
            TEAM_CHARGE_KEY:["ch":"收費說明","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_TEXT_INPUT,"sender":[String: Any](),"show":""],
            TEAM_CONTENT_KEY:["ch":"球隊說明","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_TEXT_INPUT,"sender":[String: Any](),"show":""],
            TEAM_TEMP_FEE_M_KEY:["ch":"臨打費用：男","vtype":"Int","value":-1,"submit":true,"atype":none,"show":"","keyboardType":numberPad],
            TEAM_TEMP_FEE_F_KEY:["ch":"臨打費用：女","vtype":"Int","value":-1,"submit":true,"atype":none,"show":"","keyboardType":numberPad],
            TEAM_TEMP_CONTENT_KEY:["ch":"臨打說明","vtype":"String","value":"","submit":true,"atype":more,"segue":TO_TEXT_INPUT,"sender":[String: Any](),"show":""],
            TEAM_CITY_KEY:["ch":"區域","vtype":"array","value":0,"submit":true,"atype":more,"segue":TO_CITY,"sender":0,"show":""],
            TEAM_ARENA_KEY:["ch":"球館","vtype":"array","value":0,"submit":true,"atype":more,"segue":TO_ARENA,"sender":[String: Int](),"show":""],
            TEAM_DAYS_KEY:["ch":"星期幾","vtype":"array","value":[Int](),"submit":true,"atype":more,"segue":TO_DAY,"sender":[Int](),"show":""],
            TEAM_FEATURED_KEY:["ch":"代表圖","vtype":"image","value":UIImage(),"path":"","submit":false,"show":""]
        ]
        
        testData = [
            TEAM_NAME_KEY: "快樂羽球隊",
            TEAM_LEADER_KEY: "孫志煌",
            TEAM_MOBILE_KEY: "0911299994",
            TEAM_EMAIL_KEY: "ives@housetube.tw",
            TEAM_TEMP_FEE_M_KEY: 150,
            TEAM_TEMP_FEE_F_KEY: 100,
            TEAM_BALL_KEY: "RSL 4",
            TEAM_CONTENT_KEY: "請勿報名沒有來，列入黑名單",
            TEAM_CHARGE_KEY: "一季3600含球",
            TEAM_TEMP_CONTENT_KEY: "歡迎加入",
            TEAM_PLAY_START_KEY: "16:00",
            TEAM_PLAY_END_KEY: "18:00",
            TEAM_DEGREE_KEY: ["high", "soso"],
            TEAM_DAYS_KEY: [2, 4],
            TEAM_CITY_KEY: City(id:218, name: "台南"),
            TEAM_ARENA_KEY: Arena(id: 10, name: "全穎羽球館")
        ]
        
        for (key, _) in data2 {
            data2[key]!["change"] = false
        }
        
        for (section, value1) in rows.enumerated() {
            for (row, value2) in value1.enumerated() {
                let key: String = value2["key"]!
                for (key1, _) in data2 {
                    if key == key1 {
                        data2[key1]!["section"] = section
                        data2[key1]!["row"] = row
                    }
                }
            }
        }
        data.merge(data1)
        data.merge(data2)
        
        if testData.count > 0 {
            for (key1, value) in testData {
                if key1 == TEAM_CITY_KEY {
                    let city: City = value as! City
                    data[key1]!["value"] = city.id
                    data[key1]!["show"] = city.name
                } else if key1 == TEAM_ARENA_KEY {
                    let arena: Arena = value as! Arena
                    data[key1]!["value"] = arena.id
                    data[key1]!["show"] = arena.name
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
            }
            updateDays(testData[TEAM_DAYS_KEY] as! [Int])
            updateDegree(testData[TEAM_DEGREE_KEY] as! [String])
        }
        
        
        initData2()
        
        for (key, _) in data {
            data[key]!["key"] = key
        }
        //print(data)
    }
    
    func initData2() {
        updatePlayStartTime()
        updatePlayEndTime()
        updateTempContent()
        updateCharge()
        updateContent()
    }
    
    func updateCity(_ city: City) {
        data[TEAM_CITY_KEY]!["value"] = city.id
        data[TEAM_CITY_KEY]!["show"] = city.name
        data[TEAM_CITY_KEY]!["sender"] = city.id
        setArenaSender()
    }
    func updateArena(_ arena: Arena) {
        data[TEAM_ARENA_KEY]!["value"] = arena.id
        data[TEAM_ARENA_KEY]!["show"] = arena.name
        setArenaSender()
    }
    func updateDays(_ days: [Int]) {
        data[TEAM_DAYS_KEY]!["value"] = days
        daysShow()
        setDaysSender()
    }
    func updateDegree(_ degrees: [String]) {
        data[TEAM_DEGREE_KEY]!["value"] = degrees
        degreeShow()
        setDegreeSender()
    }
    func updatePlayStartTime(_ time: String? = nil) {
        if time != nil {
            data[TEAM_PLAY_START_KEY]!["value"] = time
        }
        let tmp: String = data[TEAM_PLAY_START_KEY]!["value"] as! String
        data[TEAM_PLAY_START_KEY]!["show"] = Global.instance.noSec(tmp)
        setPlayStartTimeSender()
    }
    func updatePlayEndTime(_ time: String? = nil) {
        if time != nil {
            data[TEAM_PLAY_END_KEY]!["value"] = time
        }
        let tmp: String = data[TEAM_PLAY_END_KEY]!["value"] as! String
        data[TEAM_PLAY_END_KEY]!["show"] = Global.instance.noSec(tmp)
        setPlayEndTimeSender()
    }
    func updateTempContent(_ content: String? = nil) {
        if content != nil {
            data[TEAM_TEMP_CONTENT_KEY]!["value"] = content
        }
        tempContentShow()
        setTempContentSender()
    }
    func updateCharge(_ content: String? = nil) {
        if content != nil {
            data[TEAM_CHARGE_KEY]!["value"] = content
        }
        chargeShow()
        setChargeSender()
    }
    func updateContent(_ content: String? = nil) {
        if content != nil {
            data[TEAM_CONTENT_KEY]!["value"] = content
        }
        contentShow()
        setContentSender()
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
    func chargeShow(_ length: Int=15) {
        var text: String = data[TEAM_CHARGE_KEY]!["value"] as! String
        text = text.truncate(length: length)
        data[TEAM_CHARGE_KEY]!["show"] = text
    }
    func contentShow(_ length: Int=15) {
        var text: String = data[TEAM_CONTENT_KEY]!["value"] as! String
        text = text.truncate(length: length)
        data[TEAM_CONTENT_KEY]!["show"] = text
    }
    
    func setArenaSender() {
        var arena_sender: [String: Int] = [String: Int]()
        let city_id: Int = data[TEAM_CITY_KEY]!["value"] as! Int
        let arena_id: Int = data[TEAM_ARENA_KEY]!["value"] as! Int
        arena_sender["city_id"] = city_id
        arena_sender["arena_id"] = arena_id
        data[TEAM_ARENA_KEY]!["sender"] = arena_sender
    }
    func setDaysSender() {
        data[TEAM_DAYS_KEY]!["sender"] = data[TEAM_DAYS_KEY]!["value"]
    }
    func setDegreeSender() {
        data[TEAM_DEGREE_KEY]!["sender"] = data[TEAM_DEGREE_KEY]!["value"]
    }
    func setPlayStartTimeSender() {
        var res: [String: Any] = [String: Any]()
        var time: String = data[TEAM_PLAY_START_KEY]!["value"] as! String
        time = Global.instance.noSec(time)
        res["type"] = SELECT_TIME_TYPE.play_start
        res["time"] = time
        data[TEAM_PLAY_START_KEY]!["sender"] = res
    }
    func setPlayEndTimeSender() {
        var res: [String: Any] = [String: Any]()
        var time: String = data[TEAM_PLAY_END_KEY]!["value"] as! String
        time = Global.instance.noSec(time)
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
    func setChargeSender() {
        var res: [String: Any] = [String: Any]()
        let text: String = data[TEAM_CHARGE_KEY]!["value"] as! String
        res["text"] = text
        res["type"] = TEXT_INPUT_TYPE.charge
        data[TEAM_CHARGE_KEY]!["sender"] = res
    }
    func setContentSender() {
        var res: [String: Any] = [String: Any]()
        let text: String = data[TEAM_CONTENT_KEY]!["value"] as! String
        res["text"] = text
        res["type"] = TEXT_INPUT_TYPE.team
        data[TEAM_CONTENT_KEY]!["sender"] = res
    }
    
    func makeSubmitArr() -> [String: Any] {
        var isAnyOneChange: Bool = false
        var res: [String: Any] = [String: Any]()
        for (key, row) in data {
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
        res[TEAM_SLUG_KEY] = data[TEAM_NAME_KEY]!["value"]
        res[TEAM_CREATED_ID_KEY] = Member.instance.id
        var id: Int = -1
        if data[TEAM_ID_KEY]!["value"] != nil {
            id = data[TEAM_ID_KEY]!["value"] as! Int
        }
        if id < 0 {
            res[TEAM_MANAGER_ID_KEY] = Member.instance.id
            res[TEAM_CHANNEL_KEY] = "bm"
            res["type"] = "team"
            let cat_id: [Int] = [21]
            res[TEAM_CAT_KEY] = cat_id
        } else {
            res[TEAM_ID_KEY] = id
        }
        for (key, value) in transferPair {
            res[value] = res[key]
            res.removeValue(forKey: key)
        }
        
        return res
    }
}
