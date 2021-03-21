//
//  OrderTable.swift
//  bm
//
//  Created by ives on 2021/3/20.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrdersTable: Tables {
    
    var rows: [OrderTable] = [OrderTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([OrderTable].self, forKey: .rows)
    }
}

class OrderTable: Table {
    
    var order_no: String = ""
    var product_id: Int = 0
    var member_id: Int = 0
    var quantity: Int = 0
    var amount: Int = 0
    var shipping_fee: Int = 0
    var tax: Int = 0
    
    var order_name: String = ""
    var order_tel: String = ""
    var order_email: String = ""
    var order_city: String = ""
    var order_area: String = ""
    var order_road: String = ""
    
    var memo: String = ""
    var process: String = ""
    
    var shipping_at: String = ""
    var payment_at: String = ""
    var complete_at: String = ""
    var cancel_at: String = ""
        
    var product_type: String = ""
    var gateway_ch: String = ""
    var method_ch: String = ""
    
    var payment: PaymentTable?
    var shipping: ShippingTable?
    var product: ProductTable?
    
    var order_clothes: [OrderClothesTable] = [OrderClothesTable]()
    var order_rackets: [OrderRacketTable] = [OrderRacketTable]()
    var order_mejumps: [OrderMeJumpTable] = [OrderMeJumpTable]()
    
    var attribute: String = ""
    var unit: String = "件"
    
    var address: String = ""
    var product_name: String = ""
    var quantity_show: String = ""
    var product_price_show: String = ""
    var shipping_fee_show: String = ""
    var tax_show: String = ""
    var amount_show: String = ""
    
    var order_process_show: String = ""
    
    var payment_process_show: String = ""
    var payment_at_show: String = "未付款"
    
    var shipping_process_show: String = ""
    var shipping_at_show: String = "準備中"
    
    enum CodingKeys: String, CodingKey {
        case order_no
        case product_id
        case member_id
        case quantity
        case amount
        case shipping_fee
        case tax
        case order_name
        case order_tel
        case order_email
        case order_city
        case order_area
        case order_road
        case memo
        case process
        case shipping_at
        case payment_at
        case complete_at
        case cancel_at
        case product_type
        case gateway_ch
        case method_ch
        case payment
        case shipping
        case product
        
        case order_clothes
        case order_rackets
        case order_mejumps
        case attribute
        case address
        case product_name
        case unit
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {order_no = try container.decode(String.self, forKey: .order_no)}catch{order_no=""}
        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id = -1}
        do {shipping_fee = try container.decode(Int.self, forKey: .shipping_fee)}catch{shipping_fee = -1}
        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
        do {amount = try container.decode(Int.self, forKey: .amount)}catch{amount = -1}
        do {shipping_fee = try container.decode(Int.self, forKey: .shipping_fee)}catch{shipping_fee = -1}
        do {tax = try container.decode(Int.self, forKey: .tax)}catch{tax = -1}
        do {order_name = try container.decode(String.self, forKey: .order_name)}catch{order_name = ""}
        do {order_tel = try container.decode(String.self, forKey: .order_tel)}catch{order_tel = ""}
        do {order_email = try container.decode(String.self, forKey: .order_email)}catch{order_email = ""}
        do {order_city = try container.decode(String.self, forKey: .order_city)}catch{order_city = ""}
        do {order_area = try container.decode(String.self, forKey: .order_area)}catch{order_area = ""}
        do {order_road = try container.decode(String.self, forKey: .order_road)}catch{order_road = ""}
        do {memo = try container.decode(String.self, forKey: .memo)}catch{memo = ""}
        do {process = try container.decode(String.self, forKey: .process)}catch{process = ""}
        do {shipping_at = try container.decode(String.self, forKey: .shipping_at)}catch{shipping_at = ""}
        do {payment_at = try container.decode(String.self, forKey: .payment_at)}catch{payment_at = ""}
        do {complete_at = try container.decode(String.self, forKey: .complete_at)}catch{complete_at = ""}
        do {cancel_at = try container.decode(String.self, forKey: .cancel_at)}catch{cancel_at = ""}
        
        do {product_type = try container.decode(String.self, forKey: .product_type)}catch{product_type = ""}
        do {gateway_ch = try container.decode(String.self, forKey: .gateway_ch)}catch{gateway_ch = ""}
        do {method_ch = try container.decode(String.self, forKey: .method_ch)}catch{method_ch = ""}
        
        do {payment = try container.decode(PaymentTable.self, forKey: .payment)}catch{payment = nil}
        do {shipping = try container.decode(ShippingTable.self, forKey: .shipping)}catch{shipping = nil}
        do {product = try container.decode(ProductTable.self, forKey: .product)}catch{product = nil}
        
        do {order_clothes = try container.decode([OrderClothesTable].self, forKey: .order_clothes)}catch{order_clothes = [OrderClothesTable]()}
        do {order_rackets = try container.decode([OrderRacketTable].self, forKey: .order_clothes)}catch{order_rackets = [OrderRacketTable]()}
        do {order_mejumps = try container.decode([OrderMeJumpTable].self, forKey: .order_clothes)}catch{order_mejumps = [OrderMeJumpTable]()}
        
        do {attribute = try container.decode(String.self, forKey: .attribute)}catch{attribute = ""}
        do {address = try container.decode(String.self, forKey: .address)}catch{address = ""}
        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = ""}
        
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        if product != nil {
            product_name = product!.name
        }
        address = order_city+order_area+order_road
        attribute = makeAttributes()
        quantity_show = "\(quantity)\(unit)"
        
        var product_price: Int = getProductPrice()
        product_price = product_price * quantity
        
        product_price_show = thousandNumber(product_price)
        shipping_fee_show = thousandNumber(shipping_fee)
        amount_show = thousandNumber(amount) + "元"
        
        created_at_show = created_at.noSec()
        order_process_show = ORDER_PROCESS.getRawValueFromString(process)
        
        if payment_at.count > 0 {
            payment_at_show = payment_at.noSec()
        }
        if payment != nil {
            payment_process_show = PAYMENT_PROCESS.getRawValueFromString(payment!.process)
        } else {
            payment_process_show = "沒有取得 process table 錯誤"
        }
        
        if shipping_at.count > 0 {
            shipping_at_show = shipping_at.noSec()
        }
        if shipping != nil {
            shipping_process_show = SHIPPING_PROCESS.getRawValueFromString(shipping!.process)
        } else {
            payment_process_show = "沒有取得 shipping table 錯誤"
        }
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
            for item in order_rackets {
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
            for item in order_mejumps {
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
            for tmp in order_rackets {
                price_id = tmp.price_id
            }
        } else if product_type == "mejump" {
            for tmp in order_mejumps {
                price_id = tmp.price_id
            }
        }
        return price_id
    }
    
    private func getProductPrice()-> Int {
        let price_id: Int = getProductPriceID()
        
        var product_price: Int = 9999999
        if product != nil {
            let prices: [ProductPriceTable] = product!.prices
            for price in prices {
                if price.id == price_id {
                    product_price = price.price_member
                    break
                }
            }
        }
        return product_price
    }
}

class OrderClothesTable: Table {
    
    var order_id: Int = -1
    var product_id: Int = -1
    var price_id: Int = -1
    var color: String = ""
    var size: String = ""
    var quantity: Int = -1
    var price: Int = -1
    var unit: String = "件"
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case product_id
        case price_id
        case color
        case size
        case quantity
        case price
        case unit
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
        do {price_id = try container.decode(Int.self, forKey: .price_id)}catch{price_id = -1}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        do {size = try container.decode(String.self, forKey: .size)}catch{size = ""}
        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = -1}
        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = "件"}
        
    }
    
    override func filterRow() {
        
        super.filterRow()
        
    }
}

class OrderRacketTable: Table {
    
    var order_id: Int = -1
    var product_id: Int = -1
    var price_id: Int = -1
    var color: String = ""
    var weight: String = ""
    var quantity: Int = -1
    var price: Int = -1
    var unit: String = "隻"
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case product_id
        case price_id
        case color
        case weight
        case quantity
        case price
        case unit
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
        do {price_id = try container.decode(Int.self, forKey: .price_id)}catch{price_id = -1}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        do {weight = try container.decode(String.self, forKey: .weight)}catch{weight = ""}
        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = -1}
        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = "隻"}
        
    }
    
    override func filterRow() {
        
        super.filterRow()
        
    }
}

class OrderMeJumpTable: Table {
    
    var order_id: Int = -1
    var product_id: Int = -1
    var price_id: Int = -1
    var quantity: Int = -1
    var price: Int = -1
    var title: String = ""
    var unit: String = "組"
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case product_id
        case price_id
        case price
        case quantity
        case title
        case unit
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
        do {price_id = try container.decode(Int.self, forKey: .price_id)}catch{price_id = -1}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = -1}
        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
        do {title = try container.decode(String.self, forKey: .title)}catch{title = ""}
        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = "組"}
        
    }
    
    override func filterRow() {
        
        super.filterRow()
        
    }
}
