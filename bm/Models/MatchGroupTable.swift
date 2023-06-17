//
//  MatchTable.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchGroupsTable: Tables {
    
    var rows: [MatchGroupTable] = [MatchGroupTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([MatchGroupTable].self, forKey: .rows)
    }
}

class MatchGroupTable: Table {
    var match_id: Int = 0
    var number: Int = 0
    var price: Int = 0
    var product_price_id: Int = 0
    var limit: Int = 0
    var signup_count: Int = 0
    
    var matchTable: MatchTable? = nil
    var matchPlayers: [MatchPlayerTable] = [MatchPlayerTable]()
    var productPrice: ProductPriceTable? = nil
    
    enum CodingKeys: String, CodingKey {
        case match_id
        case number
        case price
        case product_price_id
        case limit
        case matchTable = "match"
        case matchPlayers = "match_players"
        case productPrice = "product_price"
        case signup_count
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {match_id = try container.decode(Int.self, forKey: .match_id)}catch{match_id = 0}
        do {number = try container.decode(Int.self, forKey: .number)}catch{number = 0}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = 0}
        product_price_id = try container.decodeIfPresent(Int.self, forKey: .product_price_id) ?? 0
        do {limit = try container.decode(Int.self, forKey: .limit)}catch{limit = 0}
        do {matchTable = try container.decode(MatchTable.self, forKey: .matchTable)}catch{matchTable = nil}
        do {matchPlayers = try container.decode([MatchPlayerTable].self, forKey: .matchPlayers)}catch{matchPlayers = [MatchPlayerTable]()}
        productPrice = try container.decodeIfPresent(ProductPriceTable.self, forKey: .productPrice) ?? nil
        signup_count = try container.decodeIfPresent(Int.self, forKey: .signup_count) ?? 0
    }
    
    override func filterRow() {
        
        super.filterRow()
        matchTable?.filterRow()
        if (matchPlayers.count > 0) {
            for matcherPlayer in matchPlayers {
                matcherPlayer.filterRow()
            }
        }
    }
}
