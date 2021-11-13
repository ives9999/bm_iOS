//
//  CartTable.swift
//  bm
//
//  Created by ives on 2021/7/21.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class CartsTable: Tables {
    
    var rows: [CartTable] = [CartTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([CartTable].self, forKey: .rows)
    }
}

class CartTable: Table {
    
    var order_id: Int = 0
    var member_id: Int = 0
    
    var cancel_at: String = ""
    var delete_at: String = ""
    
    var items: [CartItemTable] = [CartItemTable]()
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case member_id
        case cancel_at
        case delete_at
        case items
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id = -1}
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id = -1}
        
        do {delete_at = try container.decode(String.self, forKey: .delete_at)}catch{delete_at = ""}
        do {cancel_at = try container.decode(String.self, forKey: .cancel_at)}catch{cancel_at = ""}
        
        items = try container.decodeIfPresent([CartItemTable].self, forKey: .items) ?? [CartItemTable]()
    }
}

class CartItemTable: Table {
    
    var cart_id: Int = 0
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
        case cart_id
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
        
        cart_id = try container.decodeIfPresent(Int.self, forKey: .cart_id) ?? -1
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
        if (attribute.count > 0) {
            let tmps: [String] = attribute.components(separatedBy: "|")
            attributes.removeAll()
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
                if (arr.count > 0) {
                    for str in arr {
                        let b: [String] = str.components(separatedBy: ":")
                        a[b[0]] = b[1]
                    }
                    
                    attributes.append(a)
                }
            }
        }
        
        if (amount > 0) {
            amount_show = "NT$ \(amount.formattedWithSeparator) 元"
        } else {
            amount_show = "未提供"
        }
    }
}
