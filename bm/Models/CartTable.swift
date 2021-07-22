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
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case member_id
        case cancel_at
        case delete_at
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {order_id = try container.decode(Int.self, forKey: .order_id)}catch{order_id = -1}
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id = -1}
        
        do {delete_at = try container.decode(String.self, forKey: .delete_at)}catch{delete_at = ""}
        do {cancel_at = try container.decode(String.self, forKey: .cancel_at)}catch{cancel_at = ""}
    }
}

class CartItemTable: Table {
    
    var cart_id: Int = 0
    var product_id: Int = 0
    var price: Int = 0
    var discount: Int = 0
    var quantity: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case cart_id
        case product_id
        case price
        case discount
        case quantity
    }
    
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cart_id = try container.decodeIfPresent(Int.self, forKey: .cart_id) ?? -1
        product_id = try container.decodeIfPresent(Int.self, forKey: .product_id) ?? -1
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? -1
        discount = try container.decodeIfPresent(Int.self, forKey: .discount) ?? -1
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity) ?? -1
    }
}
