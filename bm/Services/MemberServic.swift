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
    
    /*var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var id: Int {
        get {
            return defaults.value(forKey: ID_KEY) as! Int
        }
        set {
            defaults.set(newValue, forKey: ID_KEY)
        }
    }
    var token: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var email: String {
        get {
            return defaults.value(forKey: EMAIL_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: EMAIL_KEY)
        }
    }
    var nickname: String {
        get {
            return defaults.value(forKey: NICKNAME_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: NICKNAME_KEY)
        }
    }*/
    
    var msg:String = ""
    var success: Bool = false
    
    func login(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password]
        print(body)
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                //print(data)
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                //print(self.success)
                //self.member = [String: Any]()
                var member: [String: Any] = [String: Any]()
                if self.success {
                    member["id"] = json["id"].intValue
                    member["nickname"] = json["nickname"].stringValue
                    member["token"] = json["token"].stringValue
                    member["isLoggin"] = true
                } else {
                    member["isLogin"] = false
                    self.msg = json["msg"].stringValue
                }
                Global.instance.member = member
                completion(true)
            }
        }
    }
    
    func logout() {
        //Global.instance.member.isLoggin = false
    }
    
    func register(email: String, password: String, repassword: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password, "repassword": repassword]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                print(data)
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                //print(self.success)
                var member: [String: Any] = [String: Any]()
                if self.success {
//                    self.member.id = json["id"].intValue
//                    self.member.nickname = json["nickname"].stringValue
//                    self.member.token = json["token"].stringValue
//                    self.member.isLoggin = true
                } else {
                    let errors: [String] = json["msg"].arrayObject as! [String]
                    for i in 0 ..< errors.count {
                        self.msg += errors[i]
                    }
                    //print(self.msg)
                }
                //Global.instance.member = self.member
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}

















