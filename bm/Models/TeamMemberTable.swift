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
    var member_nickname: String = ""
    var manager_nickname: String = ""
    var team_name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case team_id
        case member_id
        case member_nickname
        case manager_nickname
        case team_name
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {team_id = try container.decode(Int.self, forKey: .team_id)}catch{team_id = -1}
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id = -1}
        do {member_nickname = try container.decode(String.self, forKey: .member_nickname)}catch{member_nickname = ""}
        do {manager_nickname = try container.decode(String.self, forKey: .manager_nickname)}catch{manager_nickname = ""}
        do {team_name = try container.decode(String.self, forKey: .team_name)}catch{team_name = ""}
    }
    
    override func filterRow() {
        super.filterRow()
    }
}
