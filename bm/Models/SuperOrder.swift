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
    @objc dynamic var amount: Int = 0
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
    
    @objc dynamic var product_type: String = ""
    @objc dynamic var gateway_ch: String = ""
    @objc dynamic var method_ch: String = ""
    
    @objc dynamic var payment: SuperPayment = SuperPayment()
    @objc dynamic var shipping: SuperShipping = SuperShipping()
    @objc dynamic var product: SuperProduct = SuperProduct()
    
    @objc dynamic var order_clothes: [SuperOrderClothes] = [SuperOrderClothes]()
    @objc dynamic var order_racket: [SuperOrderRacket] = [SuperOrderRacket]()
    @objc dynamic var order_mejump: [SuperOrderMejump] = [SuperOrderMejump]()
    
    var attribute: String = ""
    var address: String = ""
    var product_name: String = ""
    
    var unit: String = "件"
    var quantity_show: String = ""
    var product_price_show: String = ""
    var shipping_fee_show: String = ""
    var tax_show: String = ""
    var amount_show: String = ""
    
    var created_at_show: String = ""
    var order_process_show: String = ""
    
    var payment_process_show: String = ""
    var payment_at_show: String = "未付款"
    
    var shipping_process_show: String = ""
    var shipping_at_show: String = "準備中"
    
    override func filterRow() {
        product_name = product.name
        address = order_city+order_area+order_road
        attribute = makeAttributes()
        quantity_show = "\(quantity)\(unit)"
        
        var product_price: Int = getProductPrice()
        product_price = product_price * quantity
        
        product_price_show = thousandNumber(product_price)
        shipping_fee_show = thousandNumber(shipping_fee)
        amount_show = thousandNumber(amount)
        
        created_at_show = created_at.noSec()
        order_process_show = ORDER_PROCESS.getRawValueFromString(process)
        
        if payment_at.count > 0 {
            payment_at_show = payment_at.noSec()
        }
        payment_process_show = PAYMENT_PROCESS.getRawValueFromString(payment.process)
        
        if shipping_at.count > 0 {
            shipping_at_show = shipping_at.noSec()
        }
        shipping_process_show = SHIPPING_PROCESS.getRawValueFromString(shipping.process)
    }
    
    private func makeAttributes()-> String {
        
        var attributes: [String] = [String]()
        if product_type == "clothes" {
            for item in order_clothes {
                let color: String = item.color
                let size: String = item.size
                unit = item.unit
                let quantity: String = String(item.quantity) + unit
                let price: String = String(item.price)
                let attribute =
                    "顏色：" + color + "," +
                    "尺寸：" + size + "," +
                    "數量：" + quantity + "," +
                    "價格：" + price
                attributes.append(attribute)
            }
        } else if product_type == "racket" {
            for item in order_racket {
                let color: String = item.color
                let weight: String = item.weight
                unit = item.unit
                let quantity: String = String(item.quantity) + unit
                let price: String = String(item.price)
                let attribute =
                    "顏色：" + color + "," +
                    "重量：" + weight + "," +
                    "數量：" + quantity + "," +
                    "價格：" + price
                attributes.append(attribute)
            }
        } else if product_type == "mejump" {
            for item in order_mejump {
                let title: String = item.title
                unit = item.unit
                let quantity: String = String(item.quantity) + unit
                let price: String = String(item.price)
                let attribute =
                    "種類：" + title + "," +
                    "數量：" + quantity + "," +
                    "價格：" + price
                attributes.append(attribute)
            }
        }
        let attribute: String = attributes.joined(separator: "\n")
        
        return attribute
    }
    
    private func thousandNumber(_ m: Int) -> String {
        let tmp = m.formattedWithSeparator
        let price: String = "NT$ \(tmp)"
        
        return price
    }
    
    private func getProductPriceID()-> Int {
        
        var price_id: Int = 0
        if product_type == "clothes" {
            for tmp in order_clothes {
                price_id = tmp.price_id
            }
        } else if product_type == "racket" {
            for tmp in order_racket {
                price_id = tmp.price_id
            }
        } else if product_type == "mejump" {
            for tmp in order_mejump {
                price_id = tmp.price_id
            }
        }
        return price_id
    }
    
    private func getProductPrice()-> Int {
        let price_id: Int = getProductPriceID()
        let prices: [SuperProductPrice] = product.prices
        var product_price: Int = 0
        for price in prices {
            if price.id == price_id {
                product_price = price.price_member
                break
            }
        }
        return product_price
    }
}

class SuperOrders: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var page: Int = 0
    @objc dynamic var totalCount: Int = 0
    @objc dynamic var perPage: Int = 0
    @objc dynamic var rows: [SuperOrder] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
    
    override func getRows<SuperOrder>() -> [SuperOrder]? {
        return (rows as! [SuperOrder])
    }
    
    override func getRowFromIdx<T>(_ idx: Int) -> T? where T : SuperModel {
        if rows.count >= idx {
            return (rows[idx] as! T)
        } else {
            return nil
        }
    }
}
