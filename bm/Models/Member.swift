//
//  Member.swift
//  bm
//
//  Created by ives on 2017/11/1.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class Member {
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
            session.set(SEX_KEY, newValue.string)
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
    var type: MEMBER_TYPE {
        get {
            let tmp: String = session.getString(MEMBER_TYPE_KEY)
            return MEMBER_TYPE(rawValue: tmp)!
        }
        set {
            session.set(MEMBER_TYPE_KEY, newValue.rawValue)
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
    
    var isLogin: Bool {
        get {
            return session.getBool(ISLOGIN_KEY)
        }
        set {
            session.set(ISLOGIN_KEY, newValue)
        }
    }
    
    init() {
        var path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        let folder: String = path[0] as! String
        print("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
        print("Member init is key exist: \(session.isKeyPresentInUserDefaults(key: ISLOGIN_KEY))")
        if !session.isKeyPresentInUserDefaults(key: ISLOGIN_KEY) {
            self.isLogin = false
            self.id = 0
            self.nickname = ""
            self.email = ""
            self.token = ""
        }
    }
}














