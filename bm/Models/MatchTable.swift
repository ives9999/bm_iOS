//
//  MatchTable.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchesTable: Tables {
    
    var rows: [MatchTable] = [MatchTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([MatchTable].self, forKey: .rows)
    }
}

class MatchTable: Table {
    var arena_id: Int = 0
    var match_start: String = ""
    var match_end: String = ""
    var signup_start: String = ""
    var signup_end: String = ""
    var ball: String = ""
    var arena_name: String = ""
    var arenaTable: ArenaTable? = nil
    var matchContactTable: MatchContactTable? = nil
    var matchGroups: [MatchGroupTable] = [MatchGroupTable]()
    
    var match_start_show: String = ""
    var match_end_show: String = ""
    var match_start_weekday: String = ""
    var match_end_weekday: String = ""
    var match_time_show: String = ""
    var signup_start_show: String = ""
    var signup_end_show: String = ""
    var signup_start_weekday: String = ""
    var signup_end_weekday: String = ""
    var city_name: String = ""
    var area_name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case arena_id
        case match_start
        case match_end
        case signup_start
        case signup_end
        case ball
        case arena_name
        case arenaTable = "arena"
        case matchContactTable = "match_contact"
        case matchGroups = "match_groups"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {arena_id = try container.decode(Int.self, forKey: .arena_id)}catch{arena_id = 0}
        do {match_start = try container.decode(String.self, forKey: .match_start)}catch{match_start = ""}
        do {match_end = try container.decode(String.self, forKey: .match_end)}catch{match_end = ""}
        do {signup_start = try container.decode(String.self, forKey: .signup_start)}catch{signup_start = ""}
        do {signup_end = try container.decode(String.self, forKey: .signup_end)}catch{signup_end = ""}
        do {ball = try container.decode(String.self, forKey: .ball)}catch{ball = ""}
        do {arena_name = try container.decode(String.self, forKey: .arena_name)}catch{arena_name = ""}
        do {arenaTable = try container.decode(ArenaTable.self, forKey: .arenaTable)}catch{arenaTable = nil}
        do {matchContactTable = try container.decode(MatchContactTable.self, forKey: .matchContactTable)}catch{matchContactTable = nil}
        do{matchGroups = try container.decode([MatchGroupTable].self, forKey: .matchGroups)}catch{matchGroups = [MatchGroupTable]()}
    }
    
    override func filterRow() {
        
        super.filterRow()
        arenaTable?.filterRow()
        if matchGroups.count > 0 {
            for matchGroup in matchGroups {
                matchGroup.filterRow()
            }
        }
        
        if (match_start.count > 0) {
            match_start_show = match_start.noSec()
            if let t = match_start.toWeekday() {
                match_start_weekday = t
            }
        }
        
        if (match_end.count > 0) {
            match_end_show = match_end.noSec()
            if let t = match_end.toWeekday() {
                match_end_weekday = t
            }
        }
        
        match_time_show = "\(match_start_show) (\(match_start_weekday)) ~ \(match_end_show) (\(match_end_weekday))"
        
        if (signup_start.count > 0) {
            signup_start_show = signup_start.noSec()
            if let t = signup_start.toWeekday() {
                signup_start_weekday = t
            }
        }
        
        if (signup_end.count > 0) {
            signup_end_show = signup_end.noSec()
            if let t = signup_start.toWeekday() {
                signup_end_weekday = t
            }
        }
        
        if (arenaTable != nil) {
            if (arenaTable!.city_id > 0) {
                city_name = Global.instance.zoneIDToName(arenaTable!.city_id)
            }
            
            if (arenaTable!.area_id > 0) {
                area_name = Global.instance.zoneIDToName(arenaTable!.area_id)
            }
            
            if arenaTable!.city_id > 0 && arenaTable!.area_id > 0 {
                address = "\(city_name)\(area_name)\(arenaTable!.zip)\(arenaTable!.road)"
            }
        }
    }
}
