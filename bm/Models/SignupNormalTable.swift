//
//  SignupNormalTable.swift
//  bm
//
//  Created by ives on 2021/3/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class SignupNormalTable: Table {
    
    var member_id: Int = -1
    var signupable_id: Int = -1
    var signupable_type: String = ""
    var able_date_id: Int = -1
    var cancel_deadline: String = ""
    var member_name: String = ""
    var member_token: String = ""
    
    var teamTable: TeamTable?
    var memberTable: MemberTable?
    
    enum CodingKeys: String, CodingKey {
        case member_id
        case signupable_id
        case signupable_type
        case able_date_id
        case cancel_deadline
        case member_name
        case member_token
        case teamTable
        case memberTable
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {member_id = try container.decode(Int.self, forKey: .member_id)}catch{member_id=0}
        do {signupable_id = try container.decode(Int.self, forKey: .signupable_id)}catch{signupable_id = 0}
        do {able_date_id = try container.decode(Int.self, forKey: .able_date_id)}catch{able_date_id = 0}
        do {signupable_type = try container.decode(String.self, forKey: .signupable_type)}catch{signupable_type = ""}
        do {cancel_deadline = try container.decode(String.self, forKey: .cancel_deadline)}catch{cancel_deadline = ""}
        do {member_name = try container.decode(String.self, forKey: .member_name)}catch{member_name = ""}
        
        member_token = try container.decodeIfPresent(String.self, forKey: .member_token) ?? ""
        teamTable = try container.decodeIfPresent(TeamTable.self, forKey: .teamTable) ?? nil
        memberTable = try container.decodeIfPresent(MemberTable.self, forKey: .memberTable) ?? nil
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        if created_at.count > 0 {
            created_at_show = created_at.noSec()
        }
        
        if updated_at.count > 0 {
            updated_at_show = updated_at.noSec()
        }
        
        if let tmp: Date = created_at.toDateTime() {
            
            let weekday: String = tmp.dateToWeekdayForChinese()
            created_at_show = created_at_show + "(" + weekday + ")"
        }
        
        if (teamTable != nil) {
            teamTable!.filterRow()
        }
        
        if (memberTable != nil) {
            memberTable!.filterRow()
        }
        
        if (status.count > 0) {
            status_show = SIGNUP_STATUS(status: status).rawValue
        }
    }
    
    override public func printRow() {
        //super.printRow()
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            print("\(property.label ?? "")=>\(property.value)")
        }
    }
}
