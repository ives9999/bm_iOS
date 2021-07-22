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
    var ecpay_token: String = ""
    var tokenExpireDate: String = ""
    var order_token: String = ""
    
    override func getListURL() -> String {
        return URL_ORDER_LIST
    }
    
    override func getUpdateURL()-> String {
        return URL_ORDER_UPDATE
    }
    
    override func getSource() -> String? {
        return "order"
    }
}
