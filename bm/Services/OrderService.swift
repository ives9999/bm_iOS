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
    
    func update<T: SuperModel>(t: T.Type, token: String = "", params: [String: String], completion: @escaping CompletionHandler) {
        
        var url: String = URL_ORDER
        if token.count > 0 {
            url = String(format: URL_ORDER, "/"+token)
        }
//        print(url)
//        print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                print(data)
                self.msg = ""
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                //print(self.success)
                let s: T = JSONParse.parse(data: json["order"])
                self.superModel = s
                completion(true)
            } else {
                self.msg = "網路或伺服器錯誤，請聯絡管理員或請稍後再試"
                completion(false)
            }
        }
    }
}
