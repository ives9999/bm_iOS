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
    
    let defaults: UserDefaults = UserDefaults.standard
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
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
    }
    
    var msg:String = ""
    var success: Bool = false
    
    func login(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password]
        print(body)
        
        Alamofire.request(URL_HOME, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {
                    print("data error")
                    return
                }
                print("data: \(data)")
                let json: JSON = JSON(data: data)
                self.success = json["success"].boolValue
                print(self.success)
                completion(true)
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = ["source": "app", "email": lowerCaseEmail, "password": password]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}

















