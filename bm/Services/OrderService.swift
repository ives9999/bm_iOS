//
//  OrderService.swift
//  bm
//
//  Created by ives on 2021/1/22.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderService: DataService {
    
    static let instance = OrderService()
    var superProduct: SuperProduct = SuperProduct()
    
    func update(token: String = "", params: [String: String], completion: @escaping CompletionHandler) {
        
        let url: String = String(format: URL_ORDER, token)
        print(url)
        print(params)
        
//        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//            
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                //print(data)
//                self.msg = ""
//                let json: JSON = JSON(data)
//                self.success = json["success"].boolValue
//                //print(self.success)
//                if self.success {
//                    self.id = json["id"].intValue
//                    if json["msg"].exists() {
//                        self.msg = json["msg"].stringValue
//                    }
//                    NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
//                } else {
//                    Member.instance.isLoggedIn = false
//                    self.msg = json["msg"].stringValue
//                }
//                completion(true)
//            } else {
//                self.msg = "網路或伺服器錯誤，請聯絡管理員或請稍後再試"
//                completion(false)
//            }
//        }
    }
}
