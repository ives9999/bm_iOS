//
//  ProductTable.swift
//  bm
//
//  Created by ives sun on 2021/3/17.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ProductsTable: Tables {
    var rows: [ProductTable] = [ProductTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([ProductTable].self, forKey: .rows)
    }
}

class ProductTable: Table {
    
    var type: String = ""
    var color: String = ""
    var size: String = ""
    var weight: String = ""
    var shipping: String = ""
    var gateway: String = ""
    var order_min: Int = 1
    var order_max: Int = 1
    
    var cart_token: String = ""
    
    var alias: String = ""
    
    var images: [String] = [String]()
    var prices: [ProductPriceTable] = [ProductPriceTable]()
    var attributes: [ProductAttributeTable] = [ProductAttributeTable]()
    var colors: [String] = [String]()
    var sizes: [String] = [String]()
    var weights: [String] = [String]()
    var shippings: [String] = [String]()
    var gateways: [String] = [String]()
    
    enum CodingKeys: String, CodingKey {
        case type
        case color
        case size
        case weight
        case shipping
        case gateway
        case order_min
        case order_max
        case cart_token
        case alias
        case prices
        case attributes = "product_attributes"
        case images
        case colors
        case sizes
        case weights
        case shippings
        case gateways
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {type = try container.decode(String.self, forKey: .type)}catch{type = ""}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        do {size = try container.decode(String.self, forKey: .size)}catch{size = ""}
        do {weight = try container.decode(String.self, forKey: .weight)}catch{weight = ""}
        do {shipping = try container.decode(String.self, forKey: .shipping)}catch{shipping = ""}
        do {gateway = try container.decode(String.self, forKey: .gateway)}catch{gateway = ""}
        do {order_min = try container.decode(Int.self, forKey: .order_min)}catch{order_min = 1}
        do {order_max = try container.decode(Int.self, forKey: .order_max)}catch{order_max = 1}
        do {alias = try container.decode(String.self, forKey: .alias)}catch{alias = ""}
        do {prices = try container.decode([ProductPriceTable].self, forKey: .prices)}catch{prices=[ProductPriceTable]()}
        do {images = try container.decode([String].self, forKey: .images)}catch{images=[String]()}
        do {colors = try container.decode([String].self, forKey: .colors)}catch{colors=[String]()}
        do {sizes = try container.decode([String].self, forKey: .sizes)}catch{sizes=[String]()}
        do {weights = try container.decode([String].self, forKey: .weights)}catch{weights=[String]()}
        do {shippings = try container.decode([String].self, forKey: .shippings)}catch{shippings=[String]()}
        do {gateways = try container.decode([String].self, forKey: .gateways)}catch{gateways=[String]()}
        
        attributes = try container.decodeIfPresent([ProductAttributeTable].self, forKey: .attributes) ?? [ProductAttributeTable]()
        cart_token = try container.decodeIfPresent(String.self, forKey: .cart_token) ?? ""
    }
    
    override func filterRow() {
        
        super.filterRow()
        if images.count > 0 {
            for (idx, image) in images.enumerated() {
                if !image.hasPrefix("http://") && !image.hasPrefix("https://") {
                    let _image = BASE_URL + image
                    images[idx] = _image
                }
            }
        }
    }
}

class ProductPriceTable: Table {
    
    var product_id: Int = -1
    var price_title: String = ""
    var price_title_alias: String = ""
    var price_member: Int = 100000000
    var price_nonmember: Int = 1000000000
    var price_dummy: Int = 100000000
    var price_desc: String = ""
    var shipping_fee: Int = 0
    var shipping_fee_unit: Int = 0
    var shippint_fee_desc: String = ""
    var tax: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case product_id
        case price_title
        case price_title_alias
        case price_member
        case price_nonmember
        case price_dummy
        case price_desc
        case shipping_fee
        case shipping_fee_unit
        case shippint_fee_desc
        case tax
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = -1}
        do {price_title = try container.decode(String.self, forKey: .price_title)}catch{price_title = ""}
        do {price_title_alias = try container.decode(String.self, forKey: .price_title_alias)}catch{price_title_alias = ""}
        do {price_member = try container.decode(Int.self, forKey: .price_member)}catch{price_member = 1000000}
        do {price_nonmember = try container.decode(Int.self, forKey: .price_nonmember)}catch{price_nonmember = 1000000}
        do {price_dummy = try container.decode(Int.self, forKey: .price_dummy)}catch{price_dummy = 100000000}
        do {price_desc = try container.decode(String.self, forKey: .price_desc)}catch{price_desc = ""}
        do {shipping_fee = try container.decode(Int.self, forKey: .shipping_fee)}catch{shipping_fee = 0}
        do {shipping_fee_unit = try container.decode(Int.self, forKey: .shipping_fee_unit)}catch{shipping_fee_unit = 0}
        do {shippint_fee_desc = try container.decode(String.self, forKey: .shippint_fee_desc)}catch{shippint_fee_desc = ""}
        do {tax = try container.decode(Int.self, forKey: .tax)}catch{tax = 1}
    }
    
    override func filterRow() {
        
        super.filterRow()
    }
}

class ProductAttributeTable: Table {
 
    var product_id: Int = -1
    var attribute: String = ""
    var alias: String = ""
    var placeholder: String = ""
    
    enum CodingKeys: String, CodingKey {
        case product_id
        case attribute
        case alias
        case placeholder
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        product_id = try container.decodeIfPresent(Int.self, forKey: .product_id) ?? -1
        attribute = try container.decodeIfPresent(String.self, forKey: .attribute) ?? ""
        alias = try container.decodeIfPresent(String.self, forKey: .alias) ?? ""
        placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder) ?? ""
    }
}
