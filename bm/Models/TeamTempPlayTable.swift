//
//  TeamTempPlayTable.swift
//  bm
//
//  Created by ives on 2023/2/24.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class TeamTempPlayTable: Table {
    
    var team_id: Int = 0
    var member_id: Int = 0
    var play_date: String = ""
    
    enum CodingKeys: String, CodingKey {
        case team_id
        case member_id
        case play_date
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        team_id = try container.decodeIfPresent(Int.self, forKey: .team_id) ?? 0
        member_id = try container.decodeIfPresent(Int.self, forKey: .member_id) ?? 0
        play_date = try container.decodeIfPresent(String.self, forKey: .play_date) ?? ""
    }
    
    override func filterRow() {
        super.filterRow()
    }
}
