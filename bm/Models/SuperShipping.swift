//
//  SuperShipping.swift
//  bm
//
//  Created by ives on 2021/1/25.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

@objc(SuperShipping)
class SuperShipping: SuperModel {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var order_id: Int = -1
    @objc dynamic var method: String = ""
    @objc dynamic var store_id: Int = 0
    @objc dynamic var store_name: String = ""
    @objc dynamic var store_address: String = ""
    @objc dynamic var store_tel: String = ""
    @objc dynamic var outside: Int = 0
    @objc dynamic var process: String = ""
    @objc dynamic var RtnCode: Int = 0
    @objc dynamic var RtnMsg: String = ""
    @objc dynamic var AllPayLogisticsID: String = ""
    @objc dynamic var amount: Int = 0
        
    @objc dynamic var UpdateStatusDate: String = ""
    @objc dynamic var CVSPaymentNo: String = ""
    @objc dynamic var CVSValidationNo: String = ""
    @objc dynamic var BookingNote: String = ""
    
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
}
