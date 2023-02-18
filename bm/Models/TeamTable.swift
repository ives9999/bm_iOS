//
//  TeamTable.swift
//  bm
//
//  Created by ives on 2021/3/17.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class TeamsTable: Tables {
    
    var rows: [TeamTable] = [TeamTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([TeamTable].self, forKey: .rows)
    }
}

class TeamTable: Table {
    
    var leader: String = ""
    var line: String = ""
    var email: String = ""
    var website: String = ""
    var fb: String = ""
    var youtube: String = ""
    var arena_id: Int = -1
    //var arena_name: String = ""
    var play_start: String = ""
    var play_end: String = ""
    var number: Int = 0
    var ball: String = ""
    var degree: String = ""
    var block: Int = 1
    var charge: String = ""
    var manager_id: Int = -1
    var manager_token: String = ""
    var manager_nickname: String = ""
    var temp_fee_M: Int = -1
    var temp_fee_F: Int = -1
    var people_limit: Int = 0
    var temp_content: String = ""
    var temp_status: String = ""
    var temp_signup_count: Int = 0
    var color: String = ""
    var weekdays: [Team_WeekdaysTable] = [Team_WeekdaysTable]()
    var arena: ArenaTable?
    var signupDate: SignupDateTable?
    var nextDate: String = ""
    
    var isSignup: Bool = false
    var isTempPlay: Bool = false
    var signupNormalTables: [SignupNormalTable] = [SignupNormalTable]()
    var signupStandbyTables: [SignupStandbyTable] = [SignupStandbyTable]()
    
    var play_start_show: String = ""
    var play_end_show: String = ""
    var weekdays_show: String = ""
    var interval_show: String = ""
    var degree_show: String = ""
    var block_show: String = "1面"
    var people_limit_show: String = ""
    var temp_signup_count_show: String = ""
    var temp_status_show: String = "上線"
    var temp_fee_M_show: String = ""
    var temp_fee_F_show: String = ""
    var last_signup_date: String = ""
    
    override init(){
        super.init()
        arena = ArenaTable()
    }
    
    enum CodingKeys: String, CodingKey {
        case leader
        case line
        case mobile
        case email
        case website
        case fb
        case youtube
        case arena_id
        //case arena_name
        case play_start
        case play_end
        case number
        case ball
        case degree
        case block
        case charge
        case manager_id
        case manager_token
        case manager_nickname
        case temp_fee_M
        case temp_fee_F
        case people_limit
        case temp_content
        case temp_status
        case temp_signup_count
        case color
        case weekdays
        case arena
        case signupDate = "signup_date"
        case isSignup
        case isTempPlay
        case signupNormalTables = "signup_normal_models"
        case signupStandbyTables = "signup_standby_models"
        case nextDate
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {leader = try container.decode(String.self, forKey: .leader)}catch{leader = ""}
        do {line = try container.decode(String.self, forKey: .line)}catch{line = ""}
        do {mobile = try container.decode(String.self, forKey: .mobile)}catch{mobile = ""}
        do {email = try container.decode(String.self, forKey: .email)}catch{email = ""}
        do {website = try container.decode(String.self, forKey: .website)}catch{website = ""}
        do {fb = try container.decode(String.self, forKey: .fb)}catch{fb = ""}
        do {arena_id = try container.decode(Int.self, forKey: .arena_id)}catch{arena_id = -1}
        //do {arena_name = try container.decode(String.self, forKey: .arena_name)}catch{arena_name = ""}
        do {play_start = try container.decode(String.self, forKey: .play_start)}catch{play_start = ""}
        do {play_end = try container.decode(String.self, forKey: .play_end)}catch{play_end = ""}
        do {number = try container.decode(Int.self, forKey: .number)}catch{number = 0}
        do {ball = try container.decode(String.self, forKey: .ball)}catch{ball = ""}
        do {degree = try container.decode(String.self, forKey: .degree)}catch{degree = ""}
        do {block = try container.decode(Int.self, forKey: .block)}catch{block = 1}
        do {charge = try container.decode(String.self, forKey: .charge)}catch{charge = ""}
        do {manager_id = try container.decode(Int.self, forKey: .manager_id)}catch{manager_id = 0}
        do {manager_token = try container.decode(String.self, forKey: .manager_token)}catch{manager_token = ""}
        do {manager_nickname = try container.decode(String.self, forKey: .manager_nickname)}catch{manager_nickname = ""}
        do {temp_fee_M = try container.decode(Int.self, forKey: .temp_fee_M)}catch{temp_fee_M = -1}
        do {temp_fee_F = try container.decode(Int.self, forKey: .temp_fee_F)}catch{temp_fee_F = -1}
        do {youtube = try container.decode(String.self, forKey: .youtube)}catch{youtube = ""}
        do {people_limit = try container.decode(Int.self, forKey: .people_limit)}catch{people_limit = 0}
        do {temp_content = try container.decode(String.self, forKey: .temp_content)}catch{temp_content = ""}
        do {temp_status = try container.decode(String.self, forKey: .temp_status)}catch{temp_status = ""}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        
        temp_signup_count = try container.decodeIfPresent(Int.self, forKey: .temp_signup_count) ?? 0
        weekdays = try container.decodeIfPresent([Team_WeekdaysTable].self, forKey: .weekdays) ?? [Team_WeekdaysTable]()
        arena = try container.decodeIfPresent(ArenaTable.self, forKey: .arena) ?? nil
        signupDate = try container.decodeIfPresent(SignupDateTable.self, forKey: .signupDate) ?? nil
        isSignup = try container.decodeIfPresent(Bool.self, forKey: .isSignup) ?? false
        isTempPlay = try container.decodeIfPresent(Bool.self, forKey: .isTempPlay) ?? false
        signupNormalTables = try container.decodeIfPresent([SignupNormalTable].self, forKey: .signupNormalTables) ?? [SignupNormalTable]()
        signupStandbyTables = try container.decodeIfPresent([SignupStandbyTable].self, forKey: .signupStandbyTables) ?? [SignupStandbyTable]()
        nextDate = try container.decodeIfPresent(String.self, forKey: .nextDate) ?? ""
        //do {arena = try container.decode(ArenaTable.self, forKey: .arena)}catch{arena = nil}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        if play_start.count > 0 {
            play_start_show = play_start.noSec()
        }
        
        if play_end.count > 0 {
            play_end_show = play_end.noSec()
        }
        
        if isTempPlay {
            people_limit_show = "臨打：\(people_limit)位"
            temp_signup_count_show = "報名：\(temp_signup_count)位"
        } else {
            people_limit_show = "目前未提供臨打"
            temp_signup_count_show = ""
        }
        
        temp_status_show = STATUS(status: temp_status).rawValue
        
        if weekdays.count > 0 {
            var show: [String] = [String]()
            for weekday in weekdays {
                let tmp: String = WEEKDAY(weekday: weekday.weekday).toString()
                show.append(tmp)
            }
            weekdays_show = show.joined(separator: ",")
        }
        
        if play_start.count > 0 && play_end.count > 0 {
            interval_show = play_start.noSec() + " ~ " + play_end.noSec()
        }
        
        if (degree.count > 0) {
            let degrees: [String] = degree.components(separatedBy: ",")
            var show: [String] = [String]()
            for value in degrees {
                let tmp: String = DEGREE.enumFromString(string: value).rawValue
                show.append(tmp)
            }
            degree_show = show.joined(separator: ",")
        }
        
        if arena != nil {
            arena!.filterRow()
        }
        
        if signupDate != nil {
            signupDate?.filterRow()
            last_signup_date = signupDate!.date
        }
        
        if temp_fee_M >= 0 {
            temp_fee_M_show = "\(temp_fee_M)元"
        } else {
            temp_fee_M_show = "未提供"
        }
        
        if temp_fee_F >= 0 {
            temp_fee_F_show = "\(temp_fee_F)元"
        } else {
            temp_fee_F_show = "未提供"
        }
        
        if block > 1 {
            block_show = "\(block)面"
        }
    }
}
