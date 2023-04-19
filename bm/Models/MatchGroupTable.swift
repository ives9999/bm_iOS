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
    var limit: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case match_id
        case number
        case price
        case limit
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {match_id = try container.decode(Int.self, forKey: .match_id)}catch{match_id = 0}
        do {number = try container.decode(Int.self, forKey: .number)}catch{number = 0}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = 0}
        do {limit = try container.decode(Int.self, forKey: .limit)}catch{limit = 0}
    }
    
    override func filterRow() {
        
        super.filterRow()
    }
}
