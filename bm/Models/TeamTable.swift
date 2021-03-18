//
//  TeamTable.swift
//  bm
//
//  Created by ives on 2021/3/17.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class TeamsTable: Table {
    
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var rows: [TeamTable] = [TeamTable]()
    
    enum CodingKeys: String, CodingKey {
        case success
        case page
        case totalCount
        case perPage
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        perPage = try container.decode(Int.self, forKey: .perPage)
        rows = try container.decode([TeamTable].self, forKey: .rows)
    }
}

class TeamTable: Table {
    
    var name: String = ""
    var leader: String = ""
    var mobile: String = ""
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
    var content: String = ""
    var manager_id: Int = -1
    var temp_fee_M: Int = -1
    var temp_fee_F: Int = -1
    var temp_quantity: Int = 0
    var temp_content: String = ""
    var temp_status: String = ""
    var color: String = ""
    var city_id: Int = -1
    var weekdays: [Int] = [Int]()
    
    var city_show: String = ""
    var play_start_show: String = ""
    var play_end_show: String = ""
    var weekdays_show: String = ""
    var interval_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
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
        case content
        case manager_id
        case temp_fee_M
        case temp_fee_F
        case temp_quantity
        case temp_content
        case temp_status
        case color
        case city_id
        case weekdays
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {name = try container.decode(String.self, forKey: .name)}catch{name=""}
        do {leader = try container.decode(String.self, forKey: .leader)}catch{leader = ""}
        do {mobile = try container.decode(String.self, forKey: .mobile)}catch{mobile = ""}
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
        do {content = try container.decode(String.self, forKey: .content)}catch{content = ""}
        do {temp_quantity = try container.decode(Int.self, forKey: .temp_quantity)}catch{temp_quantity = 0}
        do {city_id = try container.decode(Int.self, forKey: .city_id)}catch{city_id = 0}
        do {temp_content = try container.decode(String.self, forKey: .temp_content)}catch{temp_content = ""}
        do {temp_status = try container.decode(String.self, forKey: .temp_status)}catch{temp_status = ""}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        do {weekdays = try container.decode([Int].self, forKey: .weekdays)}catch{weekdays = [Int]()}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        if city_id > 0 {
            city_show = Global.instance.zoneIDToName(city_id)
        }
        
        if play_start.count > 0 {
            play_start_show = play_start.noSec()
        }
        
        if play_end.count > 0 {
            play_end_show = play_end.noSec()
        }
        
        if weekdays.count > 0 {
            var show: [String] = [String]()
            for weekday in weekdays {
                let tmp: String = WEEKDAY.intToString(weekday)
                show.append(tmp)
            }
            weekdays_show = show.joined(separator: ",")
        }
        
        if play_start.count > 0 && play_end.count > 0 {
            interval_show = play_start.noSec() + " ~ " + play_end.noSec()
        }
    }
}
