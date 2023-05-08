//
//  MatchTable.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchGiftsTable: Tables {
    
    var rows: [MatchGiftTable] = [MatchGiftTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([MatchGiftTable].self, forKey: .rows)
    }
}

class MatchGiftTable: Table {
    var match_id: Int = 0
    var product_id: Int = 0
    
    var productTable: ProductTable? = nil
    
    enum CodingKeys: String, CodingKey {
        case match_id
        case product_id
        case productTable = "product"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {match_id = try container.decode(Int.self, forKey: .match_id)}catch{match_id = 0}
        do {product_id = try container.decode(Int.self, forKey: .product_id)}catch{product_id = 0}
        do {productTable = try container.decode(ProductTable.self, forKey: .productTable)}catch{productTable = nil}
    }
    
    override func filterRow() {
        
        super.filterRow()
        //matchTable?.filterRow()
        productTable?.filterRow()
    }
}
