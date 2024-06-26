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
    //var one: JSON? = nil
    var blacklists: Array<Dictionary<String, Any>> = Array()
    
    override func getSource() -> String? {
        return "member"
    }
    
    override func getUpdateURL() -> String {
        return URL_MEMBER_UPDATE
    }
    
    func login(email: String, password: String, playerID: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: String] = ["device": "app", "email": lowerCaseEmail, "password": password, "player_id": playerID]
        //print(body)
        //print(URL_LOGIN)
        
        AF.request(URL_LOGIN, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if (response.data != nil) {
                    self.jsonData = response.data
                    //print(self.jsonData?.prettyPrintedJSONString)
                    completion(true)
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func memberTeamList(token: String, page:Int, perPage: Int, completion: @escaping CompletionHandler) {
        let url: String = URL_MEMBER_TEAM_LIST
        var body: [String: String] = ["device": "app", "channel": CHANNEL, "page": String(page), "perPage": String(perPage), "token": token]
//        print(url)
//        print(body)
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
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
        let body: [String: String] = ["device": "app", "code": code, TOKEN_KEY: token]
        //print(url)
        //print(body)
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            //print(response)
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                //print(json)
//                self.success = json["success"].boolValue
//                if self.success {
//                    NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
//                    completion(true)
//                } else {
//                    if json["msg"] != JSON.null {
//                        self.msg = json["msg"].stringValue
//                    }
//                    //print(self.msg)
//                    completion(false)
//                }
//            } else {
//                self.success = false
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
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
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            //print(response)
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                //print(json)
//                self.success = json["success"].boolValue
//                if self.success {
//                    completion(true)
//                } else {
//                    if json["msg"] != JSON.null {
//                        self.msg = json["msg"].stringValue
//                    }
//                    //print(self.msg)
//                    completion(false)
//                }
//            } else {
//                self.success = false
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
        }
    }
    
//    func getOne(token: String, completion: @escaping CompletionHandler) {
//        let body: [String: String] = ["source": "app",TOKEN_KEY: token]
//        //print(URL_MEMBER_GETONE)
//        //print(body)
//        one = nil
//        Alamofire.request(URL_MEMBER_GETONE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//            //print(response)
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                //print(json)
//                self.success = json["success"].boolValue
//                if self.success {
//                    self.one = json
//                    if token == Member.instance.token {
//                        self.jsonToMember(json: json)
//                    }
//                    completion(true)
//                } else {
//                    if json["msg"] != JSON.null {
//                        self.msg = json["msg"].stringValue
//                    }
//                    //print(self.msg)
//                    completion(false)
//                }
//            } else {
//                self.success = false
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
//        }
//    }
    
    func blacklist(token: String, completion: @escaping CompletionHandler) {
        
        let body: [String: String] = ["source": "app","channel":CHANNEL,"token":token]
        let url: String = URL_MEMBER_BLACKLIST
        //print(url)
        //print(body)
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        
            
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                //print(json)
//                let success:Bool = json["success"].boolValue
//                if (success) {
//                    self.blacklists.removeAll()
//                    let rows: [JSON] = json["rows"].arrayValue
//                    for row in rows {
//                        //print(row)
//                        let id: Int = row["id"].intValue
//                        let memberName: String = row["name"].stringValue
//                        let memberMobile: String = row["mobile"].stringValue
//                        let memberToken: String = row["token"].stringValue
//                        let date: String = row["created_at"].stringValue.noSec()
//                        let memo: String = row["memo"].stringValue
//                        let teamObj: JSON = row["team"]
//                        let teamName: String = teamObj["name"].stringValue
//                        let teamToken: String = teamObj["token"].stringValue
//                        let d:Dictionary<String, Any> = ["id":id,"memberName":memberName,"memberMobile":memberMobile,"memberToken":memberToken,"date":date,"teamName":teamName,"memo":memo,"teamToken":teamToken]
//                        self.blacklists.append(d)
//                    }
//                    //print(self.blacklists)
//                    completion(true)
//                } else {
//                    self.msg = "無法取得管理球隊的黑名單，請稍後再試"
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                }
//            }
        }
    }
    
    func deleteMemberTeam(token: String, completion: @escaping CompletionHandler) {
        let url: String = URL_MEMBER_TEAM_DELETE
        var body: [String: String] = ["device": "app", "channel": CHANNEL, "team_member_token": token]
        
//        print(url)
//        print(body)
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func likelist(able_type: String, like_list: String = "喜歡", page: Int=1, perPage: Int=20, completion: @escaping CompletionHandler) {
        
        if (!testNetwork()) {
            //msg = "無法連到網路，請檢查您的網路設定"
            myError = MYERROR.NONETWORK
            completion(false)
            return
        }
        
        let body: [String: String] = [
            "device": "app",
            "channel": CHANNEL,
            "member_token": Member.instance.token,
            "able_type": able_type,
            "like_list": like_list,
            "page": String(page),
            "perpage": String(perPage)
        ]
        //print(body)
                
        let url: String = URL_MEMBER_LIKELIST
        //print(url)
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(json)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
//    override func jsonToMember(json: JSON) {
//        //print(json)
//        var data:[String: Any] = [String: Any]()
//        for key in MEMBER_FIELD_STRING {
//            let tmp = json[key].stringValue
//            data[key] = tmp
//        }
//        for key in MEMBER_FIELD_INT {
//            let tmp = json[key].intValue
//            data[key] = tmp
//        }
//        for key in MEMBER_FIELD_BOOL {
//            let tmp = json[key].boolValue
//            data[key] = tmp
//        }
//
//        data[ISLOGGEDIN_KEY] = true
//        //print(data)
//        Member.instance.setData(data: data)
//    }
    
    func forgetPassword(email: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: String] = ["device": "app", "email": lowerCaseEmail]
        
        //print(URL_FORGET_PASSWORD)
        //print(body)
        
        AF.request(URL_FORGET_PASSWORD, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        
            
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    return
//                }
//                let json = JSON(data)
//                self.success = json["success"].boolValue
//                self.msg = json["msg"].stringValue
//                completion(true)
//            }
        }
    }
    
    func changePassword(oldPassword: String, password: String, rePassword: String, completion: @escaping CompletionHandler) {
        let token: String = Member.instance.token
        let body: [String: String] = [
            "device": "app",
            "password_old": oldPassword,
            "password":password,
            "repassword":rePassword,
            "token":token
        ]
//        print(body)
//        print(URL_CHANGE_PASSWORD)
        
        AF.request(URL_CHANGE_PASSWORD, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    return
//                }
//                let json = JSON(data)
//                self.success = json["success"].boolValue
//                self.msg = json["msg"].stringValue
//                completion(true)
//            }
        }
    }
    
    func memberSignupCalendar(year: Int, month: Int, member_token: String? = nil, able_type: String = "course", page: Int, perPage: Int, completion: @escaping CompletionHandler) {
//        var res = true
//        if member_token == nil {
//            res = false
//            return (res, "沒有傳輸會員碼錯誤，請洽管理員")
//        }
        let url: String = URL_MEMBER_SIGNUP_CALENDAR
        //print(url)
        let params: [String: String] = [
            "y":String(year),
            "m":String(month),
            "member_token":member_token!,
            "able_type":able_type,
            "page":String(page),
            "perPage":String(perPage),
            "device": "app",
            "channel": "bm"
        ]
        //print(params)
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
            
            
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    //print("get response result value error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                //print(json["able"])
//                completion(true)
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
        }
        
        //return (res, "")
    }
    
    func bank(_params: [String: String], completion: @escaping CompletionHandler) {
        
        let url: String = URL_MEMBER_BANK
        var params: [String: String] = ["channel":CHANNEL,"device":"app"]
        params.merge(_params)
        
        //print(url)
        //print(params)
        
        msg = ""
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func MemberCoinList(member_token: String? = nil, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        
        let _member_token: String = (member_token == nil) ? Member.instance.token : member_token!
        
        let url: String = URL_MEMBER_COINLIST
        let params: [String: String] = ["device": "app","member_token":_member_token]
        
        //print(url)
        //print(params)
        
        _simpleService(url: url, params: params, completion: completion)
    }
    
    func subscriptionKind(member_token: String? = nil, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        
        let _member_token: String = (member_token == nil) ? Member.instance.token : member_token!
        
        let url: String = URL_MEMBER_SUBSCRIPTION_KIND
        let params: [String: String] = ["device": "app","member_token":_member_token]
        
        //print(url)
        //print(params)
        
        _simpleService(url: url, params: params, completion: completion)
    }
    
    func subscriptionLog(member_token: String? = nil, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        
        let _member_token: String = (member_token == nil) ? Member.instance.token : member_token!
        
        let url: String = URL_MEMBER_SUBSCRIPTION_LOG
        let params: [String: String] = ["device": "app","member_token":_member_token]
        
        print(url)
        print(params)
        
        _simpleService(url: url, params: params, completion: completion)
    }
    
    func subscription(kind: String, completion: @escaping CompletionHandler) {
        
        let url: String = URL_MEMBER_SUBSCRIPTION
        let params: [String: String] = ["device": "app","member_token": Member.instance.token, "kind": kind]
        
        print(url)
        print(params)
        
        _simpleService(url: url, params: params, completion: completion)
    }
    
    func unSubscription(completion: @escaping CompletionHandler) {
        let url: String = URL_MEMBER_UNSUBSCRIPTION
        let params: [String: String] = ["device": "app","member_token": Member.instance.token]
        
        print(url)
        print(params)
        
        _simpleService(url: url, params: params, completion: completion)
    }
    
    func coinReturn(member_token: String? = nil, completion: @escaping CompletionHandler) {
        
        let _member_token: String = (member_token == nil) ? Member.instance.token : member_token!
        
        let url: String = URL_MEMBER_COINRETURN
        let params: [String: String] = ["device": "app","member_token":_member_token]
        
        //print(url)
        //print(params)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
//                    let json = JSON(value)
//                    print(json)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
}

















