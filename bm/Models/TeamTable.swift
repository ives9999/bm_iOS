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
    var email: String = ""
    var website: String = ""
    var fb: String = ""
    var youtube: String = ""
    var arena_id: Int = -1
    var arena_name: String = ""
    var play_start: String = ""
    var play_end: String = ""
    var ball: String = ""
    var degree: String = ""
    var charge: String = ""
    var manager_id: Int = -1
    var temp_fee_M: Int = -1
    var temp_fee_F: Int = -1
    var temp_quantity: Int = 0
    var temp_content: String = ""
    var temp_status: String = ""
    var temp_signup_count: Int = 0
    var color: String = ""
    var weekdays: [Team_WeekdaysTable] = [Team_WeekdaysTable]()
    var arena: ArenaTable?
    
    var play_start_show: String = ""
    var play_end_show: String = ""
    var weekdays_show: String = ""
    var interval_show: String = ""
    var degree_show: String = ""
    var temp_quantity_show: String = ""
    var temp_signup_count_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case leader
        case mobile
        case email
        case website
        case fb
        case youtube
        case arena_id
        case arena_name
        case play_start
        case play_end
        case ball
        case degree
        case charge
        case manager_id
        case temp_fee_M
        case temp_fee_F
        case temp_quantity
        case temp_content
        case temp_status
        case temp_signup_count
        case color
        case weekdays
        case arena
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {leader = try container.decode(String.self, forKey: .leader)}catch{leader = ""}
        do {mobile = try container.decode(String.self, forKey: .mobile)}catch{mobile = ""}
        do {email = try container.decode(String.self, forKey: .email)}catch{email = ""}
        do {website = try container.decode(String.self, forKey: .website)}catch{website = ""}
        do {fb = try container.decode(String.self, forKey: .fb)}catch{fb = ""}
        do {arena_id = try container.decode(Int.self, forKey: .arena_id)}catch{arena_id = -1}
        do {arena_name = try container.decode(String.self, forKey: .arena_name)}catch{arena_name = ""}
        do {play_start = try container.decode(String.self, forKey: .play_start)}catch{play_start = ""}
        do {play_end = try container.decode(String.self, forKey: .play_end)}catch{play_end = ""}
        do {ball = try container.decode(String.self, forKey: .ball)}catch{ball = ""}
        do {degree = try container.decode(String.self, forKey: .degree)}catch{degree = ""}
        do {charge = try container.decode(String.self, forKey: .charge)}catch{charge = ""}
        do {manager_id = try container.decode(Int.self, forKey: .manager_id)}catch{manager_id = 0}
        do {temp_fee_M = try container.decode(Int.self, forKey: .temp_fee_M)}catch{temp_fee_M = -1}
        do {temp_fee_F = try container.decode(Int.self, forKey: .temp_fee_F)}catch{temp_fee_F = -1}
        do {youtube = try container.decode(String.self, forKey: .youtube)}catch{youtube = ""}
        do {temp_quantity = try container.decode(Int.self, forKey: .temp_quantity)}catch{temp_quantity = 0}
        do {temp_content = try container.decode(String.self, forKey: .temp_content)}catch{temp_content = ""}
        do {temp_status = try container.decode(String.self, forKey: .temp_status)}catch{temp_status = ""}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        
        temp_signup_count = try container.decodeIfPresent(Int.self, forKey: .temp_signup_count) ?? 0
        weekdays = try container.decodeIfPresent([Team_WeekdaysTable].self, forKey: .weekdays) ?? [Team_WeekdaysTable]()
        arena = try container.decodeIfPresent(ArenaTable.self, forKey: .arena) ?? nil
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
        
        if temp_status == "on" {
            temp_quantity_show = "臨打：\(temp_quantity)位"
            temp_signup_count_show = "報名：\(temp_signup_count)位"
        } else {
            temp_quantity_show = "未開放"
            temp_signup_count_show = "未開放"
        }
        
        if weekdays.count > 0 {
            var show: [String] = [String]()
            for weekday in weekdays {
                let tmp: String = WEEKDAY.intToString(weekday.weekday)
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
    }
}
