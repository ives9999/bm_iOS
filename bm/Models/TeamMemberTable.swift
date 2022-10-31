//
//  TeamMemberTable.swift
//  bm
//
//  Created by ives on 2022/10/30.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class TeamMemberTable: Table {
    
    var team_id: Int = -1
    var member_id: Int = -1
    
    enum CodingKeys: String, CodingKey {
        case team_id
        case member_id
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {team_id = try container.decode(Int.self, forKey: .team_id)}catch{team_id = -1}
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id = -1}
    }
    
    override func filterRow() {
        super.filterRow()
    }
}
