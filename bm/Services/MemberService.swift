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

class MemberService {
    static let instance = MemberService()
    
    var msg:String = ""
    var success: Bool = false
    var one: JSON? = nil
    
    func login(email: String, password: String, playerID: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password, "player_id": playerID]
        //print(body)
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
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
            }
        }
    }
    
    func login_fb(playerID: String, completion: @escaping CompletionHandler) {
        let fb: Facebook = Facebook.instance
        let body: [String: String] = ["source":"app","uid":fb.uid,"email":fb.email,"name":fb.name,"sex":fb.sex,"avatar":fb.avatar,"social":fb.social,"channel":fb.channel,"player_id":playerID]
        //print(body)
        Alamofire.request(URL_FB_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
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
            }
        }
    }
    
    func logout() {
        Member.instance.isLoggedIn = false
        Member.instance.reset()
        Facebook.instance.logout()
        NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
    }
    
    func register(email: String, password: String, repassword: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password, "repassword": repassword]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
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
        Alamofire.request(URL_MEMBER_UPDATE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            //print(response.result.error)
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                //print(json)
                self.success = json["success"].boolValue
                if self.success {
                    self.jsonToMember(json: json)
                    NotificationCenter.default.post(name: NOTIF_MEMBER_UPDATE, object: nil)
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
                completion(false)
            }
        }
    }
    func jsonToMember(json: JSON) {
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
}

















