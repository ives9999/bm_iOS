//
//  MatchTable.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchTeamsTable: Tables {
    
    var rows: [MatchTeamTable] = [MatchTeamTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([MatchTeamTable].self, forKey: .rows)
    }
}

class MatchTeamTable: Table {
    var match_id: Int = 0
    var number: Int = 0
    var price: Int = 0
    var limit: Int = 0
    
    var matchTable: MatchTable? = nil
    var matchGroupTable: MatchGroupTable? = nil
    var matchPlayers: [MatchPlayerTable] = [MatchPlayerTable]()
    var matchGifts: [MatchGiftTable] = [MatchGiftTable]()
    
    var product_token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case match_id
        case number
        case price
        case limit
        case matchTable = "match"
        case matchGroupTable = "match_group"
        case matchPlayers = "match_players"
        case matchGifts = "match_gifts"
        case product_token
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {match_id = try container.decode(Int.self, forKey: .match_id)}catch{match_id = 0}
        do {number = try container.decode(Int.self, forKey: .number)}catch{number = 0}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = 0}
        do {limit = try container.decode(Int.self, forKey: .limit)}catch{limit = 0}
        do {matchTable = try container.decode(MatchTable.self, forKey: .matchTable)}catch{matchTable = nil}
        do {matchGroupTable = try container.decode(MatchGroupTable.self, forKey: .matchGroupTable)}catch{matchGroupTable = nil}
        do {matchPlayers = try container.decode([MatchPlayerTable].self, forKey: .matchPlayers)}catch{matchPlayers = [MatchPlayerTable]()}
        do {matchGifts = try container.decode([MatchGiftTable].self, forKey: .matchGifts)}catch{matchGifts = [MatchGiftTable]()}
        
        product_token = try container.decodeIfPresent(String.self, forKey: .product_token) ?? ""
    }
    
    override func filterRow() {
        
        super.filterRow()
        matchTable?.filterRow()
        matchGroupTable?.filterRow()
        
        if (matchPlayers.count > 0) {
            for matcherPlayer in matchPlayers {
                matcherPlayer.filterRow()
            }
        }
        
        if (matchGifts.count > 0) {
            for matchGift in matchGifts {
                matchGift.filterRow()
            }
        }
    }
}
