//
//  PaymentTable.swift
//  bm
//
//  Created by ives on 2021/3/20.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class PaymentTable: Table {
    
    var order_id: Int = -1
    var gateway: String = ""
    var amount: Int = 0
    var shipping_fee: Int = 0
    var handling_fee: Int = 0
    var tax: Int = 0

    var discount: Int = 0
    var process: String = ""
    var trade_no: String = ""
    var barcode1: String = ""
    var barcode2: String = ""
    var barcode3: String = ""

    var expire_at: String = ""
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case gateway
        case amount
        case shipping_fee
        case handling_fee
        case tax
        case discount
        case process
        case trade_no
        case barcode1
        case barcode2
        case barcode3
        case expire_at
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
        do {gateway = try container.decode(String.self, forKey: .gateway)}catch{gateway = ""}
        do {amount = try container.decode(Int.self, forKey: .amount)}catch{amount = -1}
        do {shipping_fee = try container.decode(Int.self, forKey: .shipping_fee)}catch{shipping_fee = -1}
        do {handling_fee = try container.decode(Int.self, forKey: .handling_fee)}catch{handling_fee = -1}
        do {tax = try container.decode(Int.self, forKey: .tax)}catch{tax = -1}
        do {discount = try container.decode(Int.self, forKey: .discount)}catch{discount = -1}
        do {process = try container.decode(String.self, forKey: .process)}catch{process = ""}
        do {trade_no = try container.decode(String.self, forKey: .trade_no)}catch{trade_no = ""}
        do {barcode1 = try container.decode(String.self, forKey: .barcode1)}catch{barcode1 = ""}
        do {barcode2 = try container.decode(String.self, forKey: .barcode2)}catch{barcode2 = ""}
        do {barcode3 = try container.decode(String.self, forKey: .barcode3)}catch{barcode3 = ""}
        do {expire_at = try container.decode(String.self, forKey: .expire_at)}catch{expire_at = ""}
        
    }
    
    override func filterRow() {
        
        super.filterRow()
        
    }
}
