//
//  MatchTable.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchesTable: Tables {
    
    var rows: [MatchTable] = [MatchTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([MatchTable].self, forKey: .rows)
    }
}

class MatchTable: Table {
    var arena_id: Int = 0
    var start_datetime: String = ""
    var end_datetime: String = ""
    var signup_start: String = ""
    var signup_end: String = ""
    var ball: String = ""
    
    var arena_name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case arena_id
        case start_datetime
        case end_datetime
        case signup_start
        case signup_end
        case ball
        case arena_name
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {arena_id = try container.decode(Int.self, forKey: .arena_id)}catch{arena_id = 0}
        do {start_datetime = try container.decode(String.self, forKey: .start_datetime)}catch{start_datetime = ""}
        do {end_datetime = try container.decode(String.self, forKey: .end_datetime)}catch{end_datetime = ""}
        do {signup_start = try container.decode(String.self, forKey: .signup_start)}catch{signup_start = ""}
        do {signup_end = try container.decode(String.self, forKey: .signup_end)}catch{signup_end = ""}
        do {ball = try container.decode(String.self, forKey: .ball)}catch{ball = ""}
        do {arena_name = try container.decode(String.self, forKey: .arena_name)}catch{arena_name = ""}
    }
    
    override func filterRow() {
        
        super.filterRow()
    }
}
