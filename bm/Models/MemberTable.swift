//
//  MemberTable.swift
//  bm
//
//  Created by ives sun on 2021/9/15.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class MemberTable: Table {
    
    static let instance = MemberTable()
    
    var nickname: String = ""
//    var nickname: String {
//        get {
//            return UserDefaults.standard.getString(NICKNAME_KEY)
//        }
//        set { UserDefaults.standard.set(NICKNAME_KEY, newValue) }
//    }
    var dob: String = ""
    var sex: String = ""
    var email: String = ""
    var city: Int = -1
    var area: Int = -1
    var road: String = ""
    var zip: Int = 0
    var pid: String = ""
    var avatar: String = ""
    var player_id: String = ""
    var type: Int = 0
    var social: String = ""
    var fb: String = ""
    var line: String = ""
    var role: String = ""
    var validate: Int = 0
    
    var isLoggedIn: Bool = false
    
    var area_show: String = ""
    
    //要顯示時再呼叫即可
//    var sex_show: String = ""
//    var validate_show: String = ""
//    var type_show: String = ""
    
    enum CodingKeys: String, CodingKey {

        case nickname
        case dob
        case sex
        case email
        case city = "city_id"
        case area = "area_id"
        case road
        case zip
        case pid
        case avatar
        case player_id
        case type
        case social
        case fb
        case line
        case role
        case validate
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        for child in Mirror(reflecting: self).children {
//            guard let flag = child.value as? DecodableFlag else {
//
//            }
//        }
        
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
        dob = try container.decodeIfPresent(String.self, forKey: .dob) ?? ""
        sex = try container.decodeIfPresent(String.self, forKey: .sex) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        city = try container.decodeIfPresent(Int.self, forKey: .city) ?? -1
        area = try container.decodeIfPresent(Int.self, forKey: .area) ?? -1
        road = try container.decodeIfPresent(String.self, forKey: .road) ?? ""
        zip = try container.decodeIfPresent(Int.self, forKey: .zip) ?? 0
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        player_id = try container.decodeIfPresent(String.self, forKey: .player_id) ?? ""
        type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        social = try container.decodeIfPresent(String.self, forKey: .social) ?? ""
        fb = try container.decodeIfPresent(String.self, forKey: .fb) ?? ""
        line = try container.decodeIfPresent(String.self, forKey: .line) ?? ""
        validate = try container.decodeIfPresent(Int.self, forKey: .validate) ?? 0
    }
    
    override func filterRow() {
        super.filterRow()
        
        if avatar.count > 0 {
            if !avatar.hasPrefix("http://") || !avatar.hasPrefix("https://") {
                avatar = BASE_URL + avatar
            }
        }
        
        if (city > 0) {
            city_show = Global.instance.zoneIDToName(city)
        }
        
        if (area > 0) {
            area_show = Global.instance.zoneIDToName(area)
        }
        
        if (area_show.count > 0 && city_show.count > 0) {
            address = "\(city_show)\(area_show)\(zip)\(road)"
        }
        
        //要顯示時再呼叫即可
//        if (sex.count > 0 && (sex == "M" || sex == "F")) {
//            sex_show = sexShow(rawValue: sex)
//        }
//
//        validate_show = validateShow(rawValue: validate)
    }
    
    func toSession(isLoggedIn: Bool = false) {

        self.filterRow()
        self.isLoggedIn = isLoggedIn
        let session: UserDefaults = UserDefaults.standard
        var mirror: Mirror? = Mirror(reflecting: self)
        repeat {
            for property in mirror!.children {
                //print("\(property.label ?? ""): \(property.value)")
                if let label: String = property.label {
                    let value = property.value
                    session.set(label, value)
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
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
}

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
    
    func reset() {
        
        var mirror: Mirror? = Mirror(reflecting: MemberTable())
        repeat {
            for property in mirror!.children {
                //print("\(property.label ?? ""): \(property.value)")
                if let label: String = property.label {
                    //let value = property.value
                    session.set(label, "")
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
        
        
//        var data: [String: Any] = [String: Any]()
//
//        for (key, value) in info {
//            let d: String = value["default"]!
//            let type: String = value["type"]!
//            if type == "Int" {
//                let d1: Int = Int(d)!
//                data[key] = d1
//            } else if type == "Bool" {
//                let d1: Bool = Bool(d)!
//                data[key] = d1
//            } else {
//                data[key] = d
//            }
//        }
//        setData(data: data)
//        self.justGetMemberOne = false
    }
    
    func checkMust() -> String {
        
        var msg: String = ""
        
        for key in MEMBER_MUST_ARRAY {
            
            var isFilled: Bool = false
            
            var mirror: Mirror? = Mirror(reflecting: MemberTable())
            repeat {
                for property in mirror!.children {
                    if let name: String = property.label {
                        if (name == key) {
                            let t = String(describing: Swift.type(of: property.value))
                            if (t == String(describing: Swift.type(of: ""))) {
                                let value = session.getString(name)
                                if (value.count > 0) {
                                    isFilled = true
                                }
                            } else if (t == String(describing: Swift.type(of: 1))) {
                                let value = session.getInt(name)
                                if (value > 0) {
                                    isFilled = true
                                }
                            }
                            break
                        }
                    }
                }
                mirror = mirror?.superclassMirror
            } while mirror != nil
            
            if (!isFilled) {
                msg += MEMBER_MUST_ARRAY_WARNING[key]! + "\n"
            }
        }
        
        return msg
    }
    
    //init() {
        //var path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        //let folder: String = path[0] as! String
        //print("Your NSUserDefaults are stored in this folder: \(folder)/Preferences")
        //print("Member init is key exist: \(session.isKeyPresentInUserDefaults(key: ISLOGGEDIN_KEY))")
//        if !session.isKeyPresentInUserDefaults(key: ISLOGGEDIN_KEY) {
//            self.isLoggedIn = false
//            self.id = 0
//            self.nickname = ""
//            self.email = ""
//            self.token = ""
//            self.player_id = ""
//        }
    //}
    
    
    //    let info: Dictionary<String, [String: String]> = [
    //        ID_KEY: ["ch": "編號","type":"Int","default":"0"],
    //        NICKNAME_KEY: ["ch": "暱稱","type":"String","default":""],
    //        NAME_KEY: ["ch": "姓名","type":"String","default":""],
    //        EMAIL_KEY: ["ch": "email","type":"String","default":""],
    //        TOKEN_KEY: ["ch": "token","type":"String","default":""],
    //        UID_KEY: ["ch": "uid","type":"String","default":""],
    //        CHANNEL_KEY: ["ch": "channel","type":"String","default":"bm"],
    //        DOB_KEY: ["ch": "生日","type":"String","default":""],
    //        SEX_KEY: ["ch": "性別","type":"String","default":"M"],
    //        TEL_KEY: ["ch": "市內電話","type":"String","default":""],
    //        MOBILE_KEY: ["ch": "行動電話","type":"String","default":""],
    //        CITY_KEY: ["ch": "縣市","type":"Int","default":"0"],
    //        AREA_KEY: ["ch": "區域","type":"Int","default":"0"],
    //        ROAD_KEY: ["ch": "路名","type":"String","default":""],
    //        ZIP_KEY: ["ch": "郵遞區號","type":"Int","default":"0"],
    //        PLAYERID_KEY: ["ch": "推播id","type":"String","default":""],
    //        PID_KEY: ["ch": "身分證","type":"String","default":""],
    //        AVATAR_KEY: ["ch": "大頭貼","type":"String","default":""],
    //        SOCIAL_KEY: ["ch": "social","type":"String","default":""],
    //        FB_KEY: ["ch": "FB","type":"String","default":""],
    //        LINE_KEY: ["ch": "Line","type":"String","default":""],
    //        VALIDATE_KEY: ["ch": "認證階段","type":"Int","default":"0"],
    //        MEMBER_TYPE_KEY: ["ch": "會員類型","type":"Int","default":"0"],
    //        MEMBER_ROLE_KEY: ["ch": "會員角色","type":"String","default":""]
    //    ]
}