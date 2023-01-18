//
//  TeamMemberLeaveTable.swift
//  bm
//
//  Created by ives on 2023/1/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class TeamMemberLeaveTable: Table {
    
    var team_member_id: Int = -1
    var play_date: String = ""
    
    enum CodingKeys: String, CodingKey {
        case team_member_id
        case play_date
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {team_member_id = try container.decode(Int.self, forKey: .team_member_id)}catch{team_member_id = -1}
        do {play_date = try container.decode(String.self, forKey: .play_date)}catch{play_date = ""}
    }
    
    override func filterRow() {
        super.filterRow()
    }
}
