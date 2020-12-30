//
//  MemberServic.swift
//  bm
//
//  Created by ives on 2017/10/26.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class MemberService: DataService {
    static let instance = MemberService()
    
    //var msg:String = ""
    //var success: Bool = false
    var one: JSON? = nil
    var blacklists: Array<Dictionary<String, Any>> = Array()
    
    override func getUpdateURL() -> String {
        return URL_MEMBER_UPDATE
    }
    
    func login(email: String, password: String, playerID: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password, "player_id": playerID]
        //print(body)
        //print(URL_LOGIN)
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                //print(data)
                self.msg = ""
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                //print(self.success)
                if self.success {
                    self.jsonToMember(json: json)
                    if json["msg"].exists() {
                        self.msg = json["msg"].stringValue
                    }
                    NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
                } else {
                    Member.instance.isLoggedIn = false
                    self.msg = json["msg"].stringValue
                }
                completion(true)
            } else {
                self.msg = "網路或伺服器錯誤，請聯絡管理員或請稍後再試"
                completion(false)
            }
        }
    }
    
    func login_fb(playerID: String, completion: @escaping CompletionHandler) {
        let fb: Facebook = Facebook.instance
        let body: [String: String] = ["source":"app","uid":fb.uid,"email":fb.email,"name":fb.name,"sex":fb.sex,"avatar":fb.avatar,"social":fb.social,"channel":fb.channel,"player_id":playerID]
        //print(body)
        //print(URL_FB_LOGIN)
        Alamofire.request(URL_FB_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                //print(data)
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                //print(self.success)
                if self.success {
                    self.jsonToMember(json: json)
                    NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
                } else {
                    Member.instance.isLoggedIn = false
                    self.msg = json["msg"].stringValue
                }
                completion(true)
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func logout() {
        Member.instance.isLoggedIn = false
        Member.instance.reset()
        Facebook.instance.logout()
        //NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
    }
    
    func register(email: String, password: String, repassword: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password, "repassword": repassword]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                //print(data)
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                //print(self.success)
                if self.success {
                    self.jsonToMember(json: json)
                    NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
                } else {
                    let errors: [String] = json["msg"].arrayObject as! [String]
                    for i in 0 ..< errors.count {
                        self.msg += errors[i]
                    }
                    //print(self.msg)
                }
                completion(true)
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func update(id: Int, field: String, value: inout String, completion: @escaping CompletionHandler) {
        if field == EMAIL_KEY {
            value = value.lowercased()
        }
        let body: [String: Any] = ["source": "app", field: value, ID_KEY: id]
        //print(body)
        //print(URL_MEMBER_UPDATE)
        msg = ""
        Alamofire.request(URL_MEMBER_UPDATE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            //print(response.result.error)
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                self.success = json["success"].boolValue
                if self.success {
                    self.jsonToMember(json: json)
                    NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
                } else {
                    let errors: [String] = json["error"].arrayObject as! [String]
                    for i in 0 ..< errors.count {
                        self.msg += errors[i]
                    }
                    //print(self.msg)
                }
                completion(true)
            } else {
                self.success = false
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func validate(type: String, code: String, token: String, completion: @escaping CompletionHandler) {
        var url: String = ""
        if (type == "email") {
            url = URL_EMAIL_VALIDATE
        } else if (type == "mobile") {
            url = URL_MOBILE_VALIDATE
        }
        let body: [String: Any] = ["source": "app", "code": code, TOKEN_KEY: token]
        //print(url)
        //print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            //print(response)
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                self.success = json["success"].boolValue
                if self.success {
                    NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
                    completion(true)
                } else {
                    if json["msg"] != JSON.null {
                        self.msg = json["msg"].stringValue
                    }
                    //print(self.msg)
                    completion(false)
                }
            } else {
                self.success = false
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func sendVaildateCode(type: String, value: String, token: String, completion: @escaping CompletionHandler) {
        var url: String = ""
        if type == "email" {
            url = URL_SEND_EMAIL_VALIDATE
        } else if type == "mobile" {
            url = URL_SEND_MOBILE_VALIDATE
        }
        let body: [String: String] = ["source": "app","value": value,TOKEN_KEY: token]
        //print(url)
        //print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            //print(response)
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                self.success = json["success"].boolValue
                if self.success {
                    completion(true)
                } else {
                    if json["msg"] != JSON.null {
                        self.msg = json["msg"].stringValue
                    }
                    //print(self.msg)
                    completion(false)
                }
            } else {
                self.success = false
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func getOne(token: String, completion: @escaping CompletionHandler) {
        let body: [String: String] = ["source": "app",TOKEN_KEY: token]
        //print(URL_MEMBER_GETONE)
        //print(body)
        one = nil
        Alamofire.request(URL_MEMBER_GETONE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            //print(response)
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                self.success = json["success"].boolValue
                if self.success {
                    self.one = json
                    if token == Member.instance.token {
                        self.jsonToMember(json: json)
                    }
                    completion(true)
                } else {
                    if json["msg"] != JSON.null {
                        self.msg = json["msg"].stringValue
                    }
                    //print(self.msg)
                    completion(false)
                }
            } else {
                self.success = false
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func blacklist(token:String,completion:@escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app","channel":CHANNEL,"token":token]
        let url: String = URL_MEMBER_BLACKLIST
        //print(url)
        //print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("get response result value error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                let success:Bool = json["success"].boolValue
                if (success) {
                    self.blacklists.removeAll()
                    let rows: [JSON] = json["rows"].arrayValue
                    for row in rows {
                        //print(row)
                        let id: Int = row["id"].intValue
                        let memberName: String = row["name"].stringValue
                        let memberMobile: String = row["mobile"].stringValue
                        let memberToken: String = row["token"].stringValue
                        let date: String = row["created_at"].stringValue.noSec()
                        let memo: String = row["memo"].stringValue
                        let teamObj: JSON = row["team"]
                        let teamName: String = teamObj["name"].stringValue
                        let teamToken: String = teamObj["token"].stringValue
                        let d:Dictionary<String, Any> = ["id":id,"memberName":memberName,"memberMobile":memberMobile,"memberToken":memberToken,"date":date,"teamName":teamName,"memo":memo,"teamToken":teamToken]
                        self.blacklists.append(d)
                    }
                    //print(self.blacklists)
                    completion(true)
                } else {
                    self.msg = "無法取得管理球隊的黑名單，請稍後再試"
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            }
        }
    }
    
    override func jsonToMember(json: JSON) {
        //print(json)
        var data:[String: Any] = [String: Any]()
        for key in MEMBER_FIELD_STRING {
            let tmp = json[key].stringValue
            data[key] = tmp
        }
        for key in MEMBER_FIELD_INT {
            let tmp = json[key].intValue
            data[key] = tmp
        }
        for key in MEMBER_FIELD_BOOL {
            let tmp = json[key].boolValue
            data[key] = tmp
        }
        data[ISLOGGEDIN_KEY] = true
        //print(data)
        Member.instance.setData(data: data)
    }
    
    func forgetPassword(email: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail]
        
        Alamofire.request(URL_FORGET_PASSWORD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                let json = JSON(data)
                self.success = json["success"].boolValue
                self.msg = json["msg"].stringValue
                completion(true)
            }
        }
    }
    
    func changePassword(oldPassword: String, password: String, rePassword: String, completion: @escaping CompletionHandler) {
        let token: String = Member.instance.token
        let body: [String: Any] = ["source": "app", "password_old": oldPassword,"password":password,"repassword":rePassword,"token":token]
        
        Alamofire.request(URL_CHANGE_PASSWORD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                let json = JSON(data)
                self.success = json["success"].boolValue
                self.msg = json["msg"].stringValue
                completion(true)
            }
        }
    }
    
    func memberSignupCalendar(year: Int, month: Int, member_token: String? = nil, source: String = "course", completion: @escaping CompletionHandler)-> (success: Bool, msg: String) {
        var res = true
        if member_token == nil {
            res = false
            return (res, "沒有傳輸會員碼錯誤，請洽管理員")
        }
        let url: String = URL_MEMBER_SIGNUP_CALENDAR
        //print(url)
        let body: [String: String] = ["y":String(year),"m":String(month),"member_token":member_token!,"source":source,"device": "app", "channel": "bm"]
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.result.value else {
                    //print("get response result value error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json["able"])
//                if json["able"].exists() {
//                    self.able = self.parseAbleForSingupList(data: json["able"])
//                    //print(able.printRow())
//                }
                
                let s: SuperSignups = JSONParse.parse(data: json)
                self.superModel = s
                
                let rows: [SuperSignup] = s.getRows() ?? [SuperSignup]()
                for row in rows {
                    row.filterRow()
                    //row.printRow()
                }
                completion(true)
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
        return (res, "")
    }
}

















