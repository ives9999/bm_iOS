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
    var dob: Date {
        get {
            let tmp: String = session.getString(DOB_KEY)
            let formatter = DateFormatter()
            return formatter.date(from: tmp)!
        }
        set {
            session.set(DOB_KEY, newValue.toString())
        }
    }
    var sex: SEX {
        get {
            let tmp: String = session.getString(SEX_KEY)
            return SEX(rawValue: tmp)!
        }
        set {
            session.set(SEX_KEY, newValue.rawValue)
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
            session.set(AVATAR_KEY, newValue)
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
        if let val: String = data[PID_KEY] as? String {
            self.pid = val
        }
        if let val: String = data[AVATAR_KEY] as? String {
            self.avatar = val
        }
        if let val: String = data[DOB_KEY] as? String {
            if let tmp: Date = Date(value: val) {
                self.dob = tmp
            }
        }
        if let val: String = data[SEX_KEY] as? String {
            if let tmp: SEX = SEX(rawValue: val) {
                self.sex = tmp
            }
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
    }
}














