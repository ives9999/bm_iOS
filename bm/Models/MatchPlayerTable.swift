//
//  MatchTable.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchPlayersTable: Tables {
    
    var rows: [MatchPlayerTable] = [MatchPlayerTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([MatchPlayerTable].self, forKey: .rows)
    }
}

class MatchPlayerTable: Table {
    var match_id: Int = 0
    var match_group_id: Int = 0
    var member_id: Int = 0
    var age: Int = 0
    var line: String = ""
    
    var matchGroupTable: MatchGroupTable? = nil
    
    enum CodingKeys: String, CodingKey {
        case match_id
        case match_group_id
        case member_id
        case age
        case line
        case matchGroupTable
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {match_id = try container.decode(Int.self, forKey: .match_id)}catch{match_id = 0}
        do {match_group_id = try container.decode(Int.self, forKey: .match_group_id)}catch{match_group_id = 0}
        do {age = try container.decode(Int.self, forKey: .age)}catch{age = 0}
        do {line = try container.decode(String.self, forKey: .line)}catch{line = ""}
        matchGroupTable = try container.decodeIfPresent(MatchGroupTable.self, forKey: .matchGroupTable) ?? nil
    }
    
    override func filterRow() {
        
        super.filterRow()
    }
}
