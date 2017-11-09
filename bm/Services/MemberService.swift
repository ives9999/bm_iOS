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
    
    func login(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password]
        //print(body)
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
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
        Alamofire.request(URL_MEMBER_UPDATE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                self.success = json["success"].boolValue
                if self.success {
                    self.jsonToMember(json: json)
                    NotificationCenter.default.post(name: NOTIF_MEMBER_UPDATE, object: nil)
                } else {
                    let errors: [String] = json["msg"].arrayObject as! [String]
                    for i in 0 ..< errors.count {
                        self.msg += errors[i]
                    }
                    //print(self.msg)
                }
                completion(true)
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
}

















