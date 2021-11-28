//
//  Team_WeekdaysTable.swift
//  bm
//
//  Created by ives sun on 2021/4/16.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class Team_WeekdaysTable: Table {
    
    var team_id: Int = -1
    var weekday: Int = -1
    
    override init() {
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case team_id
        case weekday
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        team_id = try container.decodeIfPresent(Int.self, forKey: .team_id) ?? -1
        weekday = try container.decodeIfPresent(Int.self, forKey: .weekday) ?? -1
    }
}
