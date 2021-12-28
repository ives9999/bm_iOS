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
    
    //var teamTable: TeamTable?
    var ableTable: AbleTable?
    var memberTable: MemberTable?
    
    enum CodingKeys: String, CodingKey {
        case member_id
        case signupable_id
        case signupable_type
        case able_date_id
        case cancel_deadline
        case member_name
        case member_token
        case ableTable
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
        ableTable = try container.decodeIfPresent(AbleTable.self, forKey: .ableTable) ?? nil
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
        
        if (ableTable != nil) {
            ableTable!.filterRow()
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

class AbleTable: Table {
    
    var arena_name: String = ""
    var arena_id: Int = 0
    var weekdays: Int = 0
    var play_start: String = ""
    var play_end: String = ""
    
    var weekdays_show: String = ""
    var interval_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case arena_name
        case arena_id
        case weekdays
        case play_start
        case play_end
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        arena_name = try container.decodeIfPresent(String.self, forKey: .arena_name) ?? ""
        arena_id = try container.decodeIfPresent(Int.self, forKey: .arena_id) ?? 0
        weekdays = try container.decodeIfPresent(Int.self, forKey: .weekdays) ?? 0
        play_start = try container.decodeIfPresent(String.self, forKey: .play_start) ?? ""
        play_end = try container.decodeIfPresent(String.self, forKey: .play_end) ?? ""
    }
    
    override func filterRow() {
        super.filterRow()
        
        if play_start.count > 0 && play_end.count > 0 {
            interval_show = play_start.noSec() + " ~ " + play_end.noSec()
        }
        
        if (weekdays > 0) {
            var weekdays_string: [String] = [String]()
            var i: Int = 1
            while (i <= 7) {
                let n = (pow(2, i) as NSDecimalNumber).intValue
                if weekdays & n > 0 {
                    weekdays_string.append(WEEKDAY.intToString(i))
                }
                i += 1
            }
            weekdays_show = weekdays_string.joined(separator: ",")
        }
    }
}
