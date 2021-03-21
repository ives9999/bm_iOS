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
    var ecpay_token: String = ""
    var tokenExpireDate: String = ""
    var order_token: String = ""
    
    override func getListURL() -> String {
        return URL_ORDER_LIST
    }
    override func getSource() -> String? {
        return "order"
    }
    
    func update(token: String = "", params: [String: String], completion: @escaping CompletionHandler) {
        
        var url: String = URL_ORDER
        if token.count > 0 {
            url = String(format: URL_ORDER, "/"+token)
        }
        //print(url)
        //print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            //print(response.result);
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
                //print(json)
                self.success = json["success"].boolValue
                //print(self.success)
                if self.success {
                    self.ecpay_token = json["token"].stringValue
                    self.tokenExpireDate = json["tokenExpireDate"].stringValue
                    self.order_token = json["order_token"].stringValue
                    completion(true)
                } else {
                    self.msg = json["msg"].stringValue
                    completion(false)
                }
            } else {
                //print(response.result.error)
                self.msg = "網路或伺服器錯誤，請聯絡管理員或請稍後再試"
                completion(false)
            }
        }
    }
}
