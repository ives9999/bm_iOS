//
//  Member.swift
//  bm
//
//  Created by ives on 2017/11/1.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class Member {
    static let instance = Member()
    let session: UserDefaults = UserDefaults.standard
    var id: Int {
        get {
            return session.getInt(ID_KEY)
        }
        set {
            session.set(ID_KEY, newValue)
        }
    }
    var nickname: String {
        get {
            return session.getString(NICKNAME_KEY)
        }
        set {
            session.set(NICKNAME_KEY, newValue)
        }
    }
    var uid: String {
        get {
            return session.getString(UID_KEY)
        }
        set {
            session.set(UID_KEY, newValue)
        }
    }
    //var slug: String
    var name: String {
        get {
            return session.getString(NAME_KEY)
        }
        set {
            session.set(NAME_KEY, newValue)
        }
    }
    var channel: String {
        get {
            return session.getString(CHANNEL_KEY)
        }
        set {
            session.set(CHANNEL_KEY, newValue)
        }
    }
    var dob: String {
        get {
            //let tmp: String = session.getString(DOB_KEY)
            //let formatter = DateFormatter()
            //return formatter.date(from: tmp)!
            return session.getString(DOB_KEY)
        }
        set {
            //session.set(DOB_KEY, newValue.toString())
            session.set(DOB_KEY, newValue)
        }
    }
    var sex: String {
        get {
            return session.getString(SEX_KEY)
        }
        set {
            session.set(SEX_KEY, newValue)
        }
    }
    var tel: String {
        get {
            return session.getString(TEL_KEY)
        }
        set {
            session.set(TEL_KEY, newValue)
        }
    }
    var mobile: String {
        get {
            return session.getString(MOBILE_KEY)
        }
        set {
            session.set(MOBILE_KEY, newValue)
        }
    }
    var email: String {
        get {
            return session.getString(EMAIL_KEY)
        }
        set {
            session.set(EMAIL_KEY, newValue)
        }
    }
    var city: Int {
        get {
            return session.getInt(CITY_KEY)
        }
        set {
            session.set(CITY_KEY, newValue)
        }
    }
    var area: Int {
        get {
            return session.getInt(AREA_KEY)
        }
        set {
            session.set(AREA_KEY, newValue)
        }
    }
//    var city_id: Int {
//        get {
//            return session.getInt(CITY_KEY)
//        }
//        set {
//            session.set(CITY_KEY, newValue)
//        }
//    }
//    var area_id: Int {
//        get {
//            return session.getInt(AREA_KEY)
//        }
//        set {
//            session.set(AREA_KEY, newValue)
//        }
//    }
    var road: String {
        get {
            return session.getString(ROAD_KEY)
        }
        set {
            session.set(ROAD_KEY, newValue)
        }
    }
    var zip: Int {
        get {
            return session.getInt(ZIP_KEY)
        }
        set {
            session.set(ZIP_KEY, newValue)
        }
    }
    var address: String {
        get {
            return session.getString(ADDRESS_KEY)
        }
        set {
            session.set(ADDRESS_KEY, newValue)
        }
    }
    var pid: String {
        get {
            return session.getString(PID_KEY)
        }
        set {
            session.set(PID_KEY, newValue)
        }
    }
    var avatar: String {
        get {
            return session.getString(AVATAR_KEY)
        }
        set {
            var avatar = ""
            if newValue.count > 0 {
                if !newValue.hasPrefix("http://") || !newValue.hasPrefix("https://") {
                    avatar = BASE_URL + newValue
                }
            }
            session.set(AVATAR_KEY, avatar)
        }
    }
    var player_id: String {
        get {
            return session.getString(PLAYERID_KEY)
        }
        set {
            session.set(PLAYERID_KEY, newValue)
        }
    }
    var type: Int {
        get {
            return session.getInt(MEMBER_TYPE_KEY)
        }
        set {
            session.set(MEMBER_TYPE_KEY, newValue)
        }
    }
    var social: String {
        get {
            return session.getString(SOCIAL_KEY)
        }
        set {
            session.set(SOCIAL_KEY, newValue)
        }
    }
    var fb: String {
        get {
            return session.getString(FB_KEY)
        }
        set {
            session.set(FB_KEY, newValue)
        }
    }
    var line: String {
        get {
            return session.getString(LINE_KEY)
        }
        set {
            session.set(LINE_KEY, newValue)
        }
    }
    var role: MEMBER_ROLE {
        get {
            let tmp: String = session.getString(MEMBER_ROLE_KEY)
            return MEMBER_ROLE(rawValue: tmp)!
        }
        set {
            session.set(MEMBER_ROLE_KEY, newValue.rawValue)
        }
    }
//    var status: STATUS {
//        get {
//            let tmp: String = session.getString(STATUS_KEY)
//            return STATUS(rawValue: tmp)!
//        }
//        set {
//            session.set(SEX_KEY, newValue.rawValue)
//        }
//    }
    var validate: Int {
        get {
            return session.getInt(VALIDATE_KEY)
        }
        set {
            session.set(VALIDATE_KEY, newValue)
        }
    }
    //var mobile_validate: String
    var token: String {
        get {
            return session.getString(TOKEN_KEY)
        }
        set {
            session.set(TOKEN_KEY, newValue)
        }
    }
    //var created_at: Date
    //var updated_at: Date
    //var ip: Int
    
    var isLoggedIn: Bool {
        get {
            return session.getBool(ISLOGGEDIN_KEY)
        }
        set {
            session.set(ISLOGGEDIN_KEY, newValue)
        }
    }
    var isTeamManager: Bool {
        get {
            return session.getBool(ISTEAMMANAGER_KEY)
        }
        set {
            session.set(ISTEAMMANAGER_KEY, newValue)
        }
    }
    var justGetMemberOne: Bool {
        get {
            return session.getBool("justGetMemberOne")
        }
        set {
            session.set("justGetMemberOne", newValue)
        }
    }
    let info: Dictionary<String, [String: String]> = [
        ID_KEY: ["ch": "編號","type":"Int","default":"0"],
        NICKNAME_KEY: ["ch": "暱稱","type":"String","default":""],
        NAME_KEY: ["ch": "姓名","type":"String","default":""],
        EMAIL_KEY: ["ch": "email","type":"String","default":""],
        TOKEN_KEY: ["ch": "token","type":"String","default":""],
        UID_KEY: ["ch": "uid","type":"String","default":""],
        CHANNEL_KEY: ["ch": "channel","type":"String","default":"bm"],
        DOB_KEY: ["ch": "生日","type":"String","default":""],
        SEX_KEY: ["ch": "性別","type":"String","default":"M"],
        TEL_KEY: ["ch": "市內電話","type":"String","default":""],
        MOBILE_KEY: ["ch": "行動電話","type":"String","default":""],
        CITY_KEY: ["ch": "縣市","type":"Int","default":"0"],
        AREA_KEY: ["ch": "區域","type":"Int","default":"0"],
        ROAD_KEY: ["ch": "路名","type":"String","default":""],
        ZIP_KEY: ["ch": "郵遞區號","type":"Int","default":"0"],
        PLAYERID_KEY: ["ch": "推播id","type":"String","default":""],
        PID_KEY: ["ch": "身分證","type":"String","default":""],
        AVATAR_KEY: ["ch": "大頭貼","type":"String","default":""],
        SOCIAL_KEY: ["ch": "social","type":"String","default":""],
        FB_KEY: ["ch": "FB","type":"String","default":""],
        LINE_KEY: ["ch": "Line","type":"String","default":""],
        VALIDATE_KEY: ["ch": "認證階段","type":"Int","default":"0"],
        MEMBER_TYPE_KEY: ["ch": "會員類型","type":"Int","default":"0"],
        MEMBER_ROLE_KEY: ["ch": "會員角色","type":"String","default":""]
    ]
    
    init() {
        //var path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        //let folder: String = path[0] as! String
        //print("Your NSUserDefaults are stored in this folder: \(folder)/Preferences")
        //print("Member init is key exist: \(session.isKeyPresentInUserDefaults(key: ISLOGGEDIN_KEY))")
        if !session.isKeyPresentInUserDefaults(key: ISLOGGEDIN_KEY) {
            self.isLoggedIn = false
            self.id = 0
            self.nickname = ""
            self.email = ""
            self.token = ""
            self.player_id = ""
        }
    }
    
    func setData(data: [String: Any]) {
        if let val: Int = data[ID_KEY] as? Int {
            self.id = val
        }
        if let val: Int = data[VALIDATE_KEY] as? Int {
            self.validate = val
        }
        if let val: String = data[NICKNAME_KEY] as? String {
            self.nickname = val
        }
        if let val: String = data[EMAIL_KEY] as? String {
            self.email = val
        }
        if let val: String = data[TOKEN_KEY] as? String {
            self.token = val
        }
        if let val: String = data[UID_KEY] as? String {
            self.uid = val
        }
        if let val: String = data[PLAYERID_KEY] as? String {
            self.player_id = val
        }
        if let val: String = data[NAME_KEY] as? String {
            self.name = val
        }
        if let val: String = data[CHANNEL_KEY] as? String {
            self.channel = val
        }
        if let val: String = data[TEL_KEY] as? String {
            self.tel = val
        }
        if let val: String = data[MOBILE_KEY] as? String {
            self.mobile = val
        }
        if let val: Int = data["city_id"] as? Int {
            self.city = val
        }
        if let val: Int = data["area_id"] as? Int {
            self.area = val
        }
//        if let val: Int = data[CITY_KEY] as? Int {
//            self.city_id = val
//        }
//        if let val: Int = data[AREA_KEY] as? Int {
//            self.area_id = val
//        }
        if let val: String = data[ROAD_KEY] as? String {
            self.road = val
        }
        if let val: Int = data[ZIP_KEY] as? Int {
            self.zip = val
        }

        if let val: String = data[FB_KEY] as? String {
            self.fb = val
        }
        if let val: String = data[LINE_KEY] as? String {
            self.line = val
        }
        if let val: String = data[PID_KEY] as? String {
            self.pid = val
        }
        if let val: String = data[AVATAR_KEY] as? String {
            self.avatar = val
        }
        if let val: String = data[DOB_KEY] as? String {
            self.dob = val
            //if let tmp: Date = Date(value: val) {
                //self.dob = tmp
            //}
        }
        if let val: String = data[SEX_KEY] as? String {
            self.sex = val
        }
        if let val: String = data[SOCIAL_KEY] as? String {
            self.social = val
        }
        if let val: Int = data[MEMBER_TYPE_KEY] as? Int {
            self.type = val
        }
        if let val: String = data[MEMBER_ROLE_KEY] as? String {
            if let tmp:MEMBER_ROLE = MEMBER_ROLE(rawValue: val) {
                self.role = tmp
            }
        }
        if let val: Bool = data[ISLOGGEDIN_KEY] as? Bool {
            self.isLoggedIn = val
        }
        let val: Int = self.type & TEAM_TYPE
        self.isTeamManager = val > 0 ? true : false
        
        let city_name: String = Global.instance.zoneIDToName(self.city)
        let area_name: String = Global.instance.zoneIDToName(self.area)
        let address: String = "\(city_name)\(area_name)\(self.zip)\(self.road)"
        self.address = address
    }
    
    func getData(key: String) -> Any {
        if key == ID_KEY {
            return self.id
        } else if key == VALIDATE_KEY {
            return self.validate
        } else if key == NICKNAME_KEY {
            return self.nickname
        } else if key == EMAIL_KEY {
            return self.email
        } else if key == TOKEN_KEY {
            return self.token
        } else if key == UID_KEY {
            return self.uid
        } else if key == PLAYERID_KEY {
            return self.uid
        } else if key == NAME_KEY {
            return self.name
        } else if key == CHANNEL_KEY {
            return self.channel
        } else if key == TEL_KEY {
            return self.tel
        } else if key == MOBILE_KEY {
            return self.mobile
        } else if key == CITY_KEY {
            return self.city
        } else if key == AREA_KEY {
            return self.area
        } else if key == ROAD_KEY {
            return self.road
        } else if key == ZIP_KEY {
            return self.zip
        } else if key == ADDRESS_KEY {
            return self.address
        } else if key == FB_KEY {
            return self.fb
        } else if key == LINE_KEY {
            return self.line
        } else if key == PID_KEY {
            return self.pid
        } else if key == AVATAR_KEY {
            return self.avatar
        }else if key == SOCIAL_KEY {
            return self.avatar
        } else if key == DOB_KEY {
            return self.dob
        } else if key == SEX_KEY {
            return self.sex
        } else if key == MEMBER_TYPE_KEY {
            return self.type
        } else if key == MEMBER_ROLE_KEY {
            return self.role
        } else if key == ISLOGGEDIN_KEY {
            return self.isLoggedIn
        }
        return ""
    }
    func sexShow(rawValue: String) -> String {
        return SEX.enumFromString(string: rawValue).rawValue
    }
    func validateShow(rawValue: Int) -> [String] {
        var res: [String] = [String]()
        if rawValue & EMAIL_VALIDATE > 0 {
            res.append("email認證")
        }
        if rawValue & MOBILE_VALIDATE > 0 {
            res.append("手機認證")
        }
        if rawValue & PID_VALIDATE > 0 {
            res.append("身分證認證")
        }
        if res.count == 0 {
            res.append("未通過任何認證")
        }
        return res
    }
    func typeShow(rawValue: Int) -> String {
        var res: [String] = [String]()
        if rawValue & GENERAL_TYPE >= 0 {
            res.append("一般會員")
        }
        if rawValue & TEAM_TYPE > 0 {
            res.append("球隊隊長")
        }
        if rawValue & ARENA_TYPE > 0 {
            res.append("球場管理員")
        }
        return res.joined(separator: ",")
    }
    
    func reset() {
        var data: [String: Any] = [String: Any]()
        
        for (key, value) in info {
            let d: String = value["default"]!
            let type: String = value["type"]!
            if type == "Int" {
                let d1: Int = Int(d)!
                data[key] = d1
            } else if type == "Bool" {
                let d1: Bool = Bool(d)!
                data[key] = d1
            } else {
                data[key] = d
            }
        }
        setData(data: data)
        self.justGetMemberOne = false
    }
}














