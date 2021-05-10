//
//  ArenaTable.swift
//  bm
//
//  Created by ives on 2021/3/18.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ArenasTable: Tables {
    
    var rows: [ArenaTable] = [ArenaTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([ArenaTable].self, forKey: .rows)
    }
}

class ArenaTable: Table {
    
    var fb: String = ""
    var website: String = ""
    var email: String = ""
    var open_time: String = ""
    var close_time: String = ""
    var block: Int = -1
    var area_id: Int = -1
    var road: String = ""
    var zip: Int = -1
    var air_condition: Int = -1
    var parking: Int = -1
    var bathroom: Int = -1
    var charge: String = ""
    var manager_id: Int = -1
    var color: String = ""
    
    var area_show: String = ""
    var interval_show: String = ""
    var air_condition_show: String = ""
    var parking_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case email
        case website
        case fb
        case open_time
        case close_time
        case block
        case area_id
        case road
        case zip
        case air_condition
        case parking
        case bathroom
        case charge
        case manager_id
        case color
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {email = try container.decode(String.self, forKey: .email)}catch{email = ""}
        do {website = try container.decode(String.self, forKey: .website)}catch{website = ""}
        do {fb = try container.decode(String.self, forKey: .fb)}catch{fb = ""}
        do {open_time = try container.decode(String.self, forKey: .open_time)}catch{open_time = ""}
        do {close_time = try container.decode(String.self, forKey: .close_time)}catch{close_time = ""}
        do {block = try container.decode(Int.self, forKey: .block)}catch{block = -1}
        do {road = try container.decode(String.self, forKey: .road)}catch{road = ""}
        do {zip = try container.decode(Int.self, forKey: .zip)}catch{zip = -1}
        do {air_condition = try container.decode(Int.self, forKey: .air_condition)}catch{air_condition = -1}
        do {parking = try container.decode(Int.self, forKey: .parking)}catch{parking = -1}
        do {bathroom = try container.decode(Int.self, forKey: .bathroom)}catch{bathroom = -1}
        do {charge = try container.decode(String.self, forKey: .charge)}catch{charge = ""}
        do {manager_id = try container.decode(Int.self, forKey: .manager_id)}catch{manager_id = 0}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        do {area_id = try container.decode(Int.self, forKey: .area_id)}catch{area_id = 0}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        if area_id > 0 {
            area_show = Global.instance.zoneIDToName(area_id)
        }
        
        if open_time.count > 0 && close_time.count > 0 {
            interval_show = open_time.noSec() + " ~ " + close_time.noSec()
        }
        
        switch air_condition {
        case 1:
            air_condition_show = "有"
        case 0:
            air_condition_show = "無"
        default:
            air_condition_show = "未提供"
        }
        
        if parking > 0 {
            parking_show = "\(parking)個"
        } else {
            parking_show = "未提供"
        }
        
        if city_id > 0 && area_id > 0 {
            address = "\(city_show)\(area_show)\(road)"
        }
    }
}
