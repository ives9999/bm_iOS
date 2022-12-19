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
    var member_token: String = ""
    var member_featured: String = ""
    var manager_nickname: String = ""
    var team_name: String = ""
    var team_featured: String = ""
    
    enum CodingKeys: String, CodingKey {
        case team_id
        case member_id
        case member_nickname
        case member_token
        case member_featured
        case manager_nickname
        case team_name
        case team_featured
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
        do {member_token = try container.decode(String.self, forKey: .member_token)}catch{member_token = ""}
        do {member_featured = try container.decode(String.self, forKey: .member_featured)}catch{member_featured = ""}
        do {manager_nickname = try container.decode(String.self, forKey: .manager_nickname)}catch{manager_nickname = ""}
        do {team_name = try container.decode(String.self, forKey: .team_name)}catch{team_name = ""}
        do {team_featured = try container.decode(String.self, forKey: .team_featured)}catch{team_featured = ""}
    }
    
    override func filterRow() {
        super.filterRow()
        
        if member_featured.count > 0 {
            if !member_featured.hasPrefix("http://") && !member_featured.hasPrefix("https://") {
                member_featured = BASE_URL + member_featured
                //print(featured_path)
            }
        } else {
            member_featured = BASE_URL + "/imgs/nophoto.png"
        }
        
        if team_featured.count > 0 {
            if !team_featured.hasPrefix("http://") && !team_featured.hasPrefix("https://") {
                team_featured = BASE_URL + team_featured
                //print(featured_path)
            }
        } else {
            team_featured = BASE_URL + "/imgs/nophoto.png"
        }
    }
}
