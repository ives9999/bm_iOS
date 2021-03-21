//
//  ShippingTable.swift
//  bm
//
//  Created by ives on 2021/3/20.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ShippingTable: Table {
    
    var order_id: Int = -1
    var method: String = ""
    var store_id: Int = 0
    var store_name: String = ""
    var store_address: String = ""
    var store_tel: String = ""
    var outside: Int = 0
    var process: String = ""
    var RtnCode: Int = 0
    var RtnMsg: String = ""
    var AllPayLogisticsID: String = ""
    var amount: Int = 0
        
    var UpdateStatusDate: String = ""
    var CVSPaymentNo: String = ""
    var CVSValidationNo: String = ""
    var BookingNote: String = ""
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case method
        case store_id
        case store_name
        case store_address
        case store_tel
        case outside
        case process
        case RtnCode
        case RtnMsg
        case AllPayLogisticsID
        case amount
        case UpdateStatusDate
        case CVSPaymentNo
        case CVSValidationNo
        case BookingNote
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
        do {method = try container.decode(String.self, forKey: .method)}catch{method = ""}
        do {store_id = try container.decode(Int.self, forKey: .store_id)}catch{store_id = -1}
        do {store_name = try container.decode(String.self, forKey: .store_name)}catch{store_name = ""}
        do {store_address = try container.decode(String.self, forKey: .store_address)}catch{store_address = ""}
        do {store_tel = try container.decode(String.self, forKey: .store_tel)}catch{store_tel = ""}
        do {outside = try container.decode(Int.self, forKey: .outside)}catch{outside = -1}
        do {process = try container.decode(String.self, forKey: .process)}catch{process = ""}
        do {RtnCode = try container.decode(Int.self, forKey: .RtnCode)}catch{RtnCode = -1}
        do {RtnMsg = try container.decode(String.self, forKey: .RtnMsg)}catch{RtnMsg = ""}
        do {AllPayLogisticsID = try container.decode(String.self, forKey: .AllPayLogisticsID)}catch{AllPayLogisticsID = ""}
        do {UpdateStatusDate = try container.decode(String.self, forKey: .UpdateStatusDate)}catch{UpdateStatusDate = ""}
        do {CVSPaymentNo = try container.decode(String.self, forKey: .CVSPaymentNo)}catch{CVSPaymentNo = ""}
        do {amount = try container.decode(Int.self, forKey: .amount)}catch{amount = 0}
        do {CVSValidationNo = try container.decode(String.self, forKey: .CVSValidationNo)}catch{CVSValidationNo = ""}
        do {BookingNote = try container.decode(String.self, forKey: .BookingNote)}catch{BookingNote = ""}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
    }
}
