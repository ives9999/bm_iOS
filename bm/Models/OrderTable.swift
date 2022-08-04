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
    var total: Int = 0
    var promo: String = ""
    var discount: Int = 0
    var grand_total: Int = 0
    var handle_fee: Int = 0
    
    var invoice_type: String = ""
    var invoice_no: String = ""
    var invoice_at: String = ""
    var invoice_email: String = ""
    var invoice_company_name: String = ""
    var invoice_company_tax: String = ""
    
    var order_name: String = ""
    var order_tel: String = ""
    var order_email: String = ""
    var order_city: String = ""
    var order_area: String = ""
    var order_road: String = ""
    var order_address: String = ""
    
    var memo: String = ""
    var process: String = ""
    var all_process: Int = 0
    
    var ecpay_token: String = ""
    var ecpay_token_ExpireDate: String = ""
    
    //var shipping_at: String = ""
    //var gateway_at: String = ""
    var complete_at: String = ""
    var cancel_at: String = ""
        
    var product_type: String = ""
    
    var payment: PaymentTable?
    var gateway: GatewayTable?
    var shipping: ShippingTable?
    var productTable: ProductTable?
    var `return`: ReturnTable?
    
    var items: [OrderItemTable] = [OrderItemTable]()
//    var order_clothes: [OrderClothesTable] = [OrderClothesTable]()
//    var order_racket: [OrderRacketTable] = [OrderRacketTable]()
//    var order_mejump: [OrderMeJumpTable] = [OrderMeJumpTable]()
    
    var attribute: String = ""
    var unit: String = "件"
    
    var product_name: String = ""
    var quantity_show: String = ""
    var product_price_show: String = ""
    var shipping_fee_show: String = ""
    var tax_show: String = ""
    var amount_show: String = ""
    var total_show: String = ""
    var discount_show: String = ""
    var grand_total_show: String = ""
    var order_tel_show: String = ""
    
    var order_process_show: String = ""
    var all_process_show: String = ""
    
    //var gateway_at_show: String = "未付款"
    //var gateway_process_show: String = ""
    
    //var shipping_process_show: String = ""
    //var shipping_at_show: String = "準備中"
    
    var invoice_type_show: String = ""
    var canReturn: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case order_no
        case product_id
        case member_id
        case quantity
        case amount
        case shipping_fee
        case tax
        case total
        case promo
        case discount
        case grand_total
        case handle_fee
        case invoice_type
        case invoice_no
        case invoice_at
        case invoice_email
        case invoice_company_name
        case invoice_company_tax
        case order_name
        case order_tel
        case order_email
        case order_city
        case order_area
        case order_road
        case order_address
        case memo
        case process
        case all_process
        case ecpay_token
        case ecpay_token_ExpireDate
        //case shipping_at
        //case gateway_at
        case complete_at
        case cancel_at
        case product_type
        case payment
        case gateway
        case shipping
        case product
        case `return`
        
        case items
//        case order_clothes
//        case order_racket
//        case order_mejump
        case attribute
        case product_name
        case unit
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {order_no = try container.decode(String.self, forKey: .order_no)}catch{order_no=""}
        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id = -1}
        do {shipping_fee = try container.decode(Int.self, forKey: .shipping_fee)}catch{shipping_fee = 0}
        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
        do {amount = try container.decode(Int.self, forKey: .amount)}catch{amount = -1}
        do {tax = try container.decode(Int.self, forKey: .tax)}catch{tax = 0}
        do {order_name = try container.decode(String.self, forKey: .order_name)}catch{order_name = ""}
        do {order_tel = try container.decode(String.self, forKey: .order_tel)}catch{order_tel = ""}
        do {order_email = try container.decode(String.self, forKey: .order_email)}catch{order_email = ""}
        do {order_city = try container.decode(String.self, forKey: .order_city)}catch{order_city = ""}
        do {order_area = try container.decode(String.self, forKey: .order_area)}catch{order_area = ""}
        do {order_road = try container.decode(String.self, forKey: .order_road)}catch{order_road = ""}
        do {memo = try container.decode(String.self, forKey: .memo)}catch{memo = ""}
        do {process = try container.decode(String.self, forKey: .process)}catch{process = ""}
        //do {shipping_at = try container.decode(String.self, forKey: .shipping_at)}catch{shipping_at = ""}
        //do {gateway_at = try container.decode(String.self, forKey: .gateway_at)}catch{gateway_at = ""}
        do {complete_at = try container.decode(String.self, forKey: .complete_at)}catch{complete_at = ""}
        do {cancel_at = try container.decode(String.self, forKey: .cancel_at)}catch{cancel_at = ""}
        
        do {product_type = try container.decode(String.self, forKey: .product_type)}catch{product_type = ""}
        do {gateway = try container.decode(GatewayTable.self, forKey: .gateway)}catch{gateway = nil}
        do {payment = try container.decode(PaymentTable.self, forKey: .payment)}catch{payment = nil}
        do {shipping = try container.decode(ShippingTable.self, forKey: .shipping)}catch{shipping = nil}
        //do {product = try container.decode(product.self, forKey: .product)}catch{product = nil}
        
//        do {order_clothes = try container.decode([OrderClothesTable].self, forKey: .order_clothes)}catch{order_clothes = [OrderClothesTable]()}
//        do {order_racket = try container.decode([OrderRacketTable].self, forKey: .order_clothes)}catch{order_racket = [OrderRacketTable]()}
//        do {order_mejump = try container.decode([OrderMeJumpTable].self, forKey: .order_clothes)}catch{order_mejump = [OrderMeJumpTable]()}
        
        do {attribute = try container.decode(String.self, forKey: .attribute)}catch{attribute = ""}
        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = ""}
        
        ecpay_token = try container.decodeIfPresent(String.self, forKey: .ecpay_token) ?? ""
        ecpay_token_ExpireDate = try container.decodeIfPresent(String.self, forKey: .ecpay_token_ExpireDate) ?? ""
        gateway = try container.decodeIfPresent(GatewayTable.self, forKey: .gateway) ?? nil
        items = try container.decodeIfPresent([OrderItemTable].self, forKey: .items) ?? [OrderItemTable]()
        
        total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        discount = try container.decodeIfPresent(Int.self, forKey: .discount) ?? 0
        promo = try container.decodeIfPresent(String.self, forKey: .promo) ?? ""
        grand_total = try container.decodeIfPresent(Int.self, forKey: .grand_total) ?? 0
        handle_fee = try container.decodeIfPresent(Int.self, forKey: .handle_fee) ?? 0
        all_process = try container.decodeIfPresent(Int.self, forKey: .all_process) ?? 0
        
        invoice_type = try container.decodeIfPresent(String.self, forKey: .invoice_type) ?? ""
        invoice_no = try container.decodeIfPresent(String.self, forKey: .invoice_no) ?? ""
        invoice_at = try container.decodeIfPresent(String.self, forKey: .invoice_at) ?? ""
        invoice_email = try container.decodeIfPresent(String.self, forKey: .invoice_email) ?? ""
        invoice_company_name = try container.decodeIfPresent(String.self, forKey: .invoice_company_name) ?? ""
        invoice_company_tax = try container.decodeIfPresent(String.self, forKey: .invoice_company_tax) ?? ""
        order_address = try container.decodeIfPresent(String.self, forKey: .order_address) ?? ""
        `return` = try container.decodeIfPresent(ReturnTable.self, forKey: .`return`) ?? nil
    }
    
    override func filterRow() {
        
        super.filterRow()
        gateway?.filterRow()
        shipping?.filterRow()
        `return`?.filterRow()
        
        if productTable != nil {
            product_name = productTable!.name
        }
        address = order_city+order_area+order_road
        attribute = makeAttributes()
        quantity_show = "\(quantity)\(unit)"
        
        var product_price: Int = getProductPrice()
        product_price = product_price * quantity
        
        product_price_show = thousandNumber(product_price) + "元"
        shipping_fee_show = thousandNumber(shipping_fee) + "元"
        amount_show = thousandNumber(amount) + "元"
        tax_show = thousandNumber(tax) + "元"
        total_show = thousandNumber(total) + "元"
        discount_show = thousandNumber(discount) + "元"
        grand_total_show = thousandNumber(grand_total) + "元"
        
        created_at_show = created_at.noSec()
        order_process_show = ORDER_PROCESS.getRawValueFromString(process)
        all_process_show = ALL_PROCESS.intToEnum(all_process).rawValue
        
//        if gateway_at.count > 0 {
//            gateway_at_show = gateway_at.noSec()
//        }
//        if gatewayTable != nil {
//            gateway_process_show = GATEWAY_PROCESS.getRawValueFromString(method!.process)
//        } else {
//            gateway_process_show = "沒有取得 process table 錯誤"
//        }
        
//        if shipping_at.count > 0 {
//            shipping_at_show = shipping_at.noSec()
//        }
//        if shippingTable != nil {
//            shipping_process_show = SHIPPING_PROCESS.getRawValueFromString(shipping!.process)
//        } else {
//            shipping_process_show = "沒有取得 shipping table 錯誤"
//        }
        
        if (invoice_type == "company") {
            invoice_type_show = "公司行號"
        } else {
            invoice_type_show = "個人"
        }
        
        order_tel_show = order_tel.mobileShow()
        
        if all_process == 6 {
            var return_expire_date: Date = Date()
            if complete_at.count > 0 {
                let tmp: String = complete_at.noTime() + " 00:00:00"
                if let c: Date = tmp.toDateTime(format: "yyyy-MM-dd HH:mm:ss", locale: false) {
                    if let a: Date = Calendar.current.date(byAdding: .day, value: 10, to: c) {
                        return_expire_date = a
                    }
                }
            }
            
            if Date().isSmallerThan(return_expire_date) {
                canReturn = true
            }
        } else {
            canReturn = false
        }
        
    }
    
    private func makeAttributes()-> String {
        
//        var attributes: [String] = [String]()
//        if product_type == "clothes" {
//            for item in order_clothes {
//                let color: String = item.color
//                let size: String = item.size
//                unit = item.unit
//                let quantity: String = String(item.quantity) + unit
//                let price: String = String(item.price)
//                let attribute =
//                    "顏色：" + color + "," +
//                    "尺寸：" + size + "," +
//                    "數量：" + quantity + "," +
//                    "價格：" + price
//                attributes.append(attribute)
//            }
//        } else if product_type == "racket" {
//            for item in order_racket {
//                let color: String = item.color
//                let weight: String = item.weight
//                unit = item.unit
//                let quantity: String = String(item.quantity) + unit
//                let price: String = String(item.price)
//                let attribute =
//                    "顏色：" + color + "," +
//                    "重量：" + weight + "," +
//                    "數量：" + quantity + "," +
//                    "價格：" + price
//                attributes.append(attribute)
//            }
//        } else if product_type == "mejump" {
//            for item in order_mejump {
//                let title: String = item.title
//                unit = item.unit
//                let quantity: String = String(item.quantity) + unit
//                let price: String = String(item.price)
//                let attribute =
//                    "種類：" + title + "," +
//                    "數量：" + quantity + "," +
//                    "價格：" + price
//                attributes.append(attribute)
//            }
//        }
//        let attribute: String = attributes.joined(separator: "\n")
        
        return ""
    }
    
    private func thousandNumber(_ m: Int) -> String {
        let tmp = m.formattedWithSeparator
        let price: String = "NT$ \(tmp)"
        
        return price
    }
    
    private func getProductPriceID()-> Int {
        
        var price_id: Int = 0
//        if product_type == "clothes" {
//            for tmp in order_clothes {
//                price_id = tmp.price_id
//            }
//        } else if product_type == "racket" {
//            for tmp in order_racket {
//                price_id = tmp.price_id
//            }
//        } else if product_type == "mejump" {
//            for tmp in order_mejump {
//                price_id = tmp.price_id
//            }
//        }
        return price_id
    }
    
    private func getProductPrice()-> Int {
        //let price_id: Int = getProductPriceID()
        
        var product_price: Int = 9999999
//        if product != nil && product!.prices.count > 0 {
//            let prices: [ProductPriceTable] = product!.prices
//            product_price = prices[0].price_member
////            for price in prices {
////                if price.id == price_id {
////                    product_price = price.price_member
////                    break
////                }
////            }
//        }
        return product_price
    }
}

class OrderItemTable: Table {
    
    var order_id: Int = 0
    var product_id: Int = 0
    var attribute: String = ""
    var amount: Int = 0
    var discount: Int = 0
    var quantity: Int = 0
    var product: ProductTable?
    
    //[name:尺寸]
    //[alias:size]
    //[value:M]
    var attributes: [[String: String]] = [[String: String]]()
    
    var amount_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case product_id
        case attribute
        case amount
        case discount
        case quantity
        case product
    }
    
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        order_id = try container.decodeIfPresent(Int.self, forKey: .order_id) ?? -1
        product_id = try container.decodeIfPresent(Int.self, forKey: .product_id) ?? -1
        attribute = try container.decodeIfPresent(String.self, forKey: .attribute) ?? ""
        amount = try container.decodeIfPresent(Int.self, forKey: .amount) ?? -1
        discount = try container.decodeIfPresent(Int.self, forKey: .discount) ?? -1
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity) ?? -1
        product = try container.decodeIfPresent(ProductTable.self, forKey: .product) ?? nil
    }
    
    override func filterRow() {
        
        super.filterRow()
        product?.filterRow()
        
        //{name:尺寸,alias:size,value:M}|{name:尺寸,alias:size,value:M}
        let tmps: [String] = attribute.components(separatedBy: "|")
        for var tmp in tmps {
            
            //{name:尺寸,alias:size,value:M}
            tmp = tmp.replace(target: "{", withString: "")
            tmp = tmp.replace(target: "}", withString: "")
            
            //name:尺寸,alias:size,value:M
            let arr: [String] = tmp.components(separatedBy: ",")
            
            //[name:尺寸]
            //[alias:size]
            //[value:M]
            var a: [String: String] = [String: String]()
            if (a.count > 0) {
                for str in arr {
                    let b: [String] = str.components(separatedBy: ":")
                    a[b[0]] = b[1]
                }
                
                attributes.append(a)
            }
        }
        
        if (amount > 0) {
            amount_show = "NT$ \(amount.formattedWithSeparator) 元"
        } else {
            amount_show = "未提供"
        }
    }
}

class GatewayTable: Table {
    
    var order_id: Int = 0
    var method: String = ""
    var process: String = ""
    var card6No: String = ""
    var card4No: String = ""
    var pay_from: String = ""
    var payment_no: String = ""
    var payment_url: String = ""
    var barcode1: String = ""
    var barcode2: String = ""
    var barcode3: String = ""
    var bank_code: String = ""
    var bank_account: String = ""
    var complete_at: String = ""
    var expire_at: String = ""
    var return_at: String = ""
    
    var method_show: String = ""
    var process_show: String = ""
    var complete_at_show: String = "未付款"
    var expire_at_show: String = ""
    var return_at_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case method
        case process
        case card6No
        case card4No
        case pay_from
        case payment_no
        case payment_url
        case barcode1
        case barcode2
        case barcode3
        case bank_code
        case bank_account
        case complete_at
        case expire_at
        case return_at
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        order_id = try container.decodeIfPresent(Int.self, forKey: .order_id) ?? 0
        method = try container.decodeIfPresent(String.self, forKey: .method) ?? ""
        process = try container.decodeIfPresent(String.self, forKey: .process) ?? ""
        card6No = try container.decodeIfPresent(String.self, forKey: .card6No) ?? ""
        card4No = try container.decodeIfPresent(String.self, forKey: .card4No) ?? ""
        pay_from = try container.decodeIfPresent(String.self, forKey: .pay_from) ?? ""
        payment_no = try container.decodeIfPresent(String.self, forKey: .payment_no) ?? ""
        payment_url = try container.decodeIfPresent(String.self, forKey: .payment_url) ?? ""
        barcode1 = try container.decodeIfPresent(String.self, forKey: .barcode1) ?? ""
        barcode2 = try container.decodeIfPresent(String.self, forKey: .barcode2) ?? ""
        barcode3 = try container.decodeIfPresent(String.self, forKey: .barcode3) ?? ""
        bank_code = try container.decodeIfPresent(String.self, forKey: .bank_code) ?? ""
        bank_account = try container.decodeIfPresent(String.self, forKey: .bank_account) ?? ""
        complete_at = try container.decodeIfPresent(String.self, forKey: .complete_at) ?? ""
        expire_at = try container.decodeIfPresent(String.self, forKey: .expire_at) ?? ""
        return_at = try container.decodeIfPresent(String.self, forKey: .return_at) ?? ""
    }
    
    override func filterRow() {
        
        super.filterRow()
        method_show = GATEWAY.getRawValueFromString(method)
        process_show = GATEWAY_PROCESS.getRawValueFromString(process)
        complete_at_show = complete_at.noSec()
        expire_at_show = expire_at.noSec()
        return_at_show = return_at.noSec()
    }
}

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
    var shipping_at: String = ""
    var store_at: String = ""
    var complete_at: String = ""
    var return_at: String = ""
        
    var UpdateStatusDate: String = ""
    var CVSPaymentNo: String = ""
    var CVSValidationNo: String = ""
    var BookingNote: String = ""
    
    var method_show: String = ""
    var process_show: String = ""
    var shipping_at_show: String = "準備中"
    var store_at_show: String = ""
    var complete_at_show: String = ""
    var return_at_show: String = ""
    
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
        case shipping_at
        case store_at
        case complete_at
        case return_at
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
        
        shipping_at = try container.decodeIfPresent(String.self, forKey: .shipping_at) ?? ""
        store_at = try container.decodeIfPresent(String.self, forKey: .store_at) ?? ""
        complete_at = try container.decodeIfPresent(String.self, forKey: .complete_at) ?? ""
        return_at = try container.decodeIfPresent(String.self, forKey: .return_at) ?? ""
        
    }
    
    override func filterRow() {
        
        super.filterRow()
        method_show = SHIPPING.getRawValueFromString(method)
        process_show = SHIPPING_PROCESS.getRawValueFromString(process)
        shipping_at_show = shipping_at.noSec()
        store_at_show = store_at.noSec()
        complete_at_show = complete_at.noSec()
        return_at_show = return_at.noSec()
    }
}

//class OrderClothesTable: Table {
//
//    var order_id: Int = -1
//    var product_id: Int = -1
//    var price_id: Int = -1
//    var color: String = ""
//    var size: String = ""
//    var quantity: Int = -1
//    var price: Int = -1
//    var unit: String = "件"
//
//    enum CodingKeys: String, CodingKey {
//        case order_id
//        case product_id
//        case price_id
//        case color
//        case size
//        case quantity
//        case price
//        case unit
//    }
//
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
//        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
//        do {price_id = try container.decode(Int.self, forKey: .price_id)}catch{price_id = -1}
//        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
//        do {size = try container.decode(String.self, forKey: .size)}catch{size = ""}
//        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
//        do {price = try container.decode(Int.self, forKey: .price)}catch{price = -1}
//        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = "件"}
//
//    }
//
//    override func filterRow() {
//
//        super.filterRow()
//
//    }
//}
//
//class OrderRacketTable: Table {
//
//    var order_id: Int = -1
//    var product_id: Int = -1
//    var price_id: Int = -1
//    var color: String = ""
//    var weight: String = ""
//    var quantity: Int = -1
//    var price: Int = -1
//    var unit: String = "隻"
//
//    enum CodingKeys: String, CodingKey {
//        case order_id
//        case product_id
//        case price_id
//        case color
//        case weight
//        case quantity
//        case price
//        case unit
//    }
//
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
//        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
//        do {price_id = try container.decode(Int.self, forKey: .price_id)}catch{price_id = -1}
//        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
//        do {weight = try container.decode(String.self, forKey: .weight)}catch{weight = ""}
//        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
//        do {price = try container.decode(Int.self, forKey: .price)}catch{price = -1}
//        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = "隻"}
//
//    }
//
//    override func filterRow() {
//
//        super.filterRow()
//
//    }
//}
//
//class OrderMeJumpTable: Table {
//
//    var order_id: Int = -1
//    var product_id: Int = -1
//    var price_id: Int = -1
//    var quantity: Int = -1
//    var price: Int = -1
//    var unit: String = "組"
//
//    enum CodingKeys: String, CodingKey {
//        case order_id
//        case product_id
//        case price_id
//        case price
//        case quantity
//        case title
//        case unit
//    }
//
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id=0}
//        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
//        do {price_id = try container.decode(Int.self, forKey: .price_id)}catch{price_id = -1}
//        do {price = try container.decode(Int.self, forKey: .price)}catch{price = -1}
//        do {quantity = try container.decode(Int.self, forKey: .quantity)}catch{quantity = -1}
//        do {unit = try container.decode(String.self, forKey: .unit)}catch{unit = "組"}
//
//    }
//
//    override func filterRow() {
//
//        super.filterRow()
//
//    }
//}
