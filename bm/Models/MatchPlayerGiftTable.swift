//
//  MatchPlayerGiftTable.swift
//  bm
//
//  Created by ives on 2023/5/30.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchPlayerGiftTable: Table {
    
    var match_player_id: Int = 0
    var match_gift_id: Int = 0
    var attributes: String = ""
    
    enum CodingKeys: String, CodingKey {
        case match_player_id
        case match_gift_id
        case attributes
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        match_player_id = try container.decodeIfPresent(Int.self, forKey: .match_player_id) ?? 0
        match_gift_id = try container.decodeIfPresent(Int.self, forKey: .match_gift_id) ?? 0
        attributes = try container.decodeIfPresent(String.self, forKey: .attributes) ?? ""
    }
}
