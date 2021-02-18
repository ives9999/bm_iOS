//
//  SuperOrder.swift
//  bm
//
//  Created by ives on 2021/1/25.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

@objc(SuperOrder)
class SuperOrder: SuperModel {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var order_no: String = ""
    @objc dynamic var product_id: Int = 0
    @objc dynamic var member_id: Int = 0
    @objc dynamic var quantity: Int = 0
    @objc dynamic var shipping_fee: Int = 0
    @objc dynamic var tax: Int = 0
    
    @objc dynamic var order_name: String = ""
    @objc dynamic var order_tel: String = ""
    @objc dynamic var order_email: String = ""
    @objc dynamic var order_city: String = ""
    @objc dynamic var order_area: String = ""
    @objc dynamic var order_road: String = ""
    
    @objc dynamic var memo: String = ""
    @objc dynamic var process: String = ""
    
    @objc dynamic var status: String = "online"
    @objc dynamic var token: String = ""
    @objc dynamic var channel: String = ""
    
    @objc dynamic var shipping_at: String = ""
    @objc dynamic var payment_at: String = ""
    @objc dynamic var complete_at: String = ""
    @objc dynamic var cancel_at: String = ""
    
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    
    @objc dynamic var payment: SuperPayment = SuperPayment()
    @objc dynamic var shipping: SuperShipping = SuperShipping()
    @objc dynamic var product: SuperProduct = SuperProduct()
    
    @objc dynamic var order_clothes: [SuperOrderClothes] = [SuperOrderClothes]()
    @objc dynamic var order_racket: [SuperOrderRacket] = [SuperOrderRacket]()
    @objc dynamic var order_mejump: [SuperOrderMejump] = [SuperOrderMejump]()
    
    override func filterRow() {
        
    }
}
