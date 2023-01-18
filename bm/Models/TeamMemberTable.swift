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
    var memberTable: MemberTable?
    var managerTable: MemberTable?
    var teamTable: TeamTable?
    
    enum CodingKeys: String, CodingKey {
        case team_id
        case member_id
        case memberTable = "member"
        case managerTable = "manager"
        case teamTable = "team"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {team_id = try container.decode(Int.self, forKey: .team_id)}catch{team_id = -1}
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id = -1}
        
        memberTable = try container.decodeIfPresent(MemberTable.self, forKey: .memberTable) ?? nil
        managerTable = try container.decodeIfPresent(MemberTable.self, forKey: .managerTable) ?? nil
        teamTable = try container.decodeIfPresent(TeamTable.self, forKey: .teamTable) ?? nil
    }
    
    override func filterRow() {
        super.filterRow()
        
        memberTable?.filterRow()
        managerTable?.filterRow()
        teamTable?.filterRow()
    }
}
