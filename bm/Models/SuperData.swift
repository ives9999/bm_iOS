//
//  Team.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class SuperData {
    var id: Int
    var title: String
    var featured: UIImage
    var path: String
    var token: String
    var youtube: String
    var vimeo: String
    var data: Dictionary<String, [String: Any]>
    var sections: [String]
    var rows: [[String]]
    var textKeys:[String] = [String]()
    var timeKeys:[String] = [String]()
    var cat_id: Int = 21
    
    //temp play
    var temp_play_data:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()
    
    let transferPair: [String: String] = [CITY_KEY:"city_id",ARENA_KEY:"arena_id"]
    
    let none: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
    let more: UITableViewCellAccessoryType = UITableViewCellAccessoryType.disclosureIndicator
    let defaultPad: UIKeyboardType = UIKeyboardType.default
    let numberPad: UIKeyboardType = UIKeyboardType.numberPad
    let phonePad: UIKeyboardType = UIKeyboardType.phonePad
    let emailPad: UIKeyboardType = UIKeyboardType.emailAddress
    
    init() {
        self.id = -1
        self.title = ""
        self.path = ""
        self.featured = UIImage(named: "nophoto")!
        self.token = ""
        self.vimeo = ""
        self.youtube = ""
        self.data = Dictionary<String, [String: Any]>()
        self.sections = [String]()
        self.rows = [[String]]()
    }
    
    init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        self.id = id
        self.title = title
        self.path = path
        self.featured = UIImage(named: "nophoto")!
        self.token = token
        self.vimeo = vimeo
        self.youtube = youtube
        self.data = Dictionary<String, [String: Any]>()
        self.sections = [String]()
        self.rows = [[String]]()
    }
    
    func neverFill() {
        for (key, _) in data {
            data[key]!["show"] = "未提供"
        }
    }
    
    func setSectionAndRow() {
        for (section, value1) in rows.enumerated() {
            for (idx, key) in value1.enumerated() {
                for (key1, _) in data {
                    if key == key1 {
                        data[key1]!["section"] = section
                        data[key1]!["row"] = idx
                        break
                    }
                }
            }
        }
    }
    
    func updateCity(_ city: City? = nil) {
        if city != nil {
            data[CITY_KEY]!["value"] = city!.id
            data[CITY_KEY]!["show"] = city!.name
            data[CITY_KEY]!["sender"] = city!.id
        } else {
            data[CITY_KEY]!["value"] = 0
            data[CITY_KEY]!["show"] = ""
            data[CITY_KEY]!["sender"] = 0
        }
    }
    
    func mobileShow(_ _mobile: String? = nil) {
        var mobile = _mobile
        if _mobile == nil {
            mobile = (data[MOBILE_KEY]!["value"] as! String)
        }
        mobile = mobile!.mobileShow()
        data[MOBILE_KEY]!["show"] = mobile
    }
    
    func telOrMobileShow(_tel: String? = nil) {
        var tel = _tel
        if _tel == nil {
            tel = (data[TEL_KEY]!["value"] as! String)
        }
        tel = tel!.telOrMobileShow()
        data[TEL_KEY]!["show"] = tel
    }
    
    func initTimeData() {
        for key in timeKeys {
            updateTime(key: key)
        }
    }
    
    func updateText(key: String, text: String?=nil) {
        var _content = ""
        if (text != nil) {
            _content = text!
        }
        data[key]!["value"] = _content
        textShow(key: key)
        setTextSender(key: key)
    }
    
    func initTextData() {
        for key in textKeys {
            updateText(key: key)
        }
    }
    
    func textShow(key: String, length: Int=12) {
        var text: String = data[key]!["value"] as! String
        if (text.count > 0) {
            text = text.truncate(length: length)
        }
        data[key]!["show"] = text
    }
    
    func setTextSender(key: String) {
        var res: [String: Any] = [String: Any]()
        let text: String = data[key]!["value"] as! String
        let type = contentKey2Type(key: key)
        res["text"] = text
        res["type"] = type
        data[key]!["sender"] = res
    }
    
    func setAllTextSender() {
        for key in textKeys {
            setTextSender(key: key)
        }
    }
    
    func updateTime(key: String, _ time: String? = nil) {
        if time != nil {
            data[key]!["value"] = time
        } else {
            data[key]!["value"] = ""
        }
        timeShow(key: key)
        setTimeSender(key: key)
    }
    
    func timeShow(key: String) {
        var time = data[key]!["value"] as! String
        if time.count > 0 {
            time = time.noSec()
        }
        data[key]!["show"] = time
    }
    
    func setTimeSender(key: String) {
        var res: [String: Any] = [String: Any]()
        var time: String = data[key]!["value"] as! String
        time = time.noSec()
        let type = timeKey2Type(key: key)
        res["type"] = type
        res["time"] = time
        data[key]!["sender"] = res
    }
    
    func initTimeShow() {
        for key in timeKeys {
            timeShow(key: key)
        }
    }
    
    func contentKey2Type(key: String)-> TEXT_INPUT_TYPE {
        var type = TEXT_INPUT_TYPE.content
        switch (key) {
        case TEAM_TEMP_CONTENT_KEY:
            type = TEXT_INPUT_TYPE.temp_play
            break
        case CHARGE_KEY:
            type = TEXT_INPUT_TYPE.charge
            break
        case CONTENT_KEY:
            type = TEXT_INPUT_TYPE.content
            break
        case COACH_EXP_KEY:
            type = TEXT_INPUT_TYPE.exp
            break
        case COACH_FEAT_KEY:
            type = TEXT_INPUT_TYPE.feat
            break
        case COACH_LICENSE_KEY:
            type = TEXT_INPUT_TYPE.license
            break
        default:
            type = .content
        }
        return type
    }
    
    func timeKey2Type(key: String)-> SELECT_TIME_TYPE {
        var type = SELECT_TIME_TYPE.play_start
        switch (key) {
        case TEAM_PLAY_START_KEY:
            type = .play_start
            break
        case TEAM_PLAY_END_KEY:
            type = .play_end
            break
        default:
            type = .play_start
        }
        return type
    }
    
    func listReset() {}
    func initData() {}
    func updateArena(_ arena: Arena?=nil) {}
    func updateWeekdays(_ days: [Int]?=nil) {}
    func updateDegree(_ degrees: [Degree]?=nil) {}
    func updateInterval(_ _startTime: String? = nil, _ _endTime: String? = nil) {}
    func updateNearDate(_ n1: String? = nil, _ n2: String? = nil) {}
    func feeShow() {}
    
    func makeSubmitArr() -> [String: Any] {
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
            //res["type"] = "team"
            let cat_id: [Int] = [self.cat_id]
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
    
    func aPrint() {
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            _print(it: property)
        }
    }
    
    func _print(it: Mirror.Child) {
        let key = it.label
        let value = it.label
        print("\(key) => \(value)")
    }
}
