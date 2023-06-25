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
    var match_group_id: Int = 0
    var manager_name: String = ""
    var manager_mobile: String = ""
    var manager_email: String = ""
    var manager_line: String = ""
    var order_token: String = ""
    var order_process: String = ""
    
    var matchTable: MatchTable? = nil
    var matchGroupTable: MatchGroupTable? = nil
    var matchPlayers: [MatchPlayerTable] = [MatchPlayerTable]()
    var matchGifts: [MatchGiftTable] = [MatchGiftTable]()
    var orderTable: OrderTable? = nil
    var productTable: ProductTable? = nil
    
    var product_token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case match_id
        case match_group_id
        case manager_name
        case manager_mobile
        case manager_email
        case manager_line
        case order_token
        case order_process
        case matchTable = "match"
        case matchGroupTable = "match_group"
        case matchPlayers = "match_players"
        case matchGifts = "match_gifts"
        case product_token
        case orderTable = "order"
        case productTable = "product"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        match_id = try container.decodeIfPresent(Int.self, forKey: .match_id) ?? 0
        match_group_id = try container.decodeIfPresent(Int.self, forKey: .match_group_id) ?? 0
        manager_name = try container.decodeIfPresent(String.self, forKey: .manager_name) ?? ""
        manager_mobile = try container.decodeIfPresent(String.self, forKey: .manager_mobile) ?? ""
        manager_email = try container.decodeIfPresent(String.self, forKey: .manager_email) ?? ""
        manager_line = try container.decodeIfPresent(String.self, forKey: .manager_line) ?? ""
        
        do {matchTable = try container.decode(MatchTable.self, forKey: .matchTable)}catch{matchTable = nil}
        do {matchGroupTable = try container.decode(MatchGroupTable.self, forKey: .matchGroupTable)}catch{matchGroupTable = nil}
        do {matchPlayers = try container.decode([MatchPlayerTable].self, forKey: .matchPlayers)}catch{matchPlayers = [MatchPlayerTable]()}
        do {matchGifts = try container.decode([MatchGiftTable].self, forKey: .matchGifts)}catch{matchGifts = [MatchGiftTable]()}
        
        product_token = try container.decodeIfPresent(String.self, forKey: .product_token) ?? ""
        orderTable = try container.decodeIfPresent(OrderTable.self, forKey: .orderTable) ?? nil
        productTable = try container.decodeIfPresent(ProductTable.self, forKey: .productTable) ?? nil
        
        order_token = try container.decodeIfPresent(String.self, forKey: .order_token) ?? ""
        order_process = try container.decodeIfPresent(String.self, forKey: .order_process) ?? ""
    }
    
    override func filterRow() {
        
        super.filterRow()
        matchTable?.filterRow()
        matchGroupTable?.filterRow()
        orderTable?.filterRow()
        
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
