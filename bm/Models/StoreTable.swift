//
//  StoreTable.swift
//  bm
//
//  Created by ives sun on 2021/3/17.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class StoresTable: Tables {
    
    var rows: [StoreTable] = [StoreTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([StoreTable].self, forKey: .rows)
    }
}

class StoreTable: Table {
        
    var fb: String = ""
    var website: String = ""
    var email: String = ""
    var line: String = ""
    
    var open_time: String = ""
    var close_time: String = ""
    
    var area_id: Int = -1
    var road: String = ""
    var zip: Int = -1
    
    var open_time_show: String = ""
    var close_time_show: String = ""
    var interval_show: String = ""
    
    var managers: [[String: Any]] = [[String: Any]]()
    
    enum CodingKeys: String, CodingKey {
        case mobile
        case fb
        case website
        case email
        case line
        case open_time
        case close_time
        case area_id
        case road
        case zip
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {mobile = try container.decode(String.self, forKey: .mobile)}catch{mobile = ""}
        do {fb = try container.decode(String.self, forKey: .fb)}catch{fb = ""}
        do {website = try container.decode(String.self, forKey: .website)}catch{website = ""}
        do {email = try container.decode(String.self, forKey: .email)}catch{email = ""}
        do {line = try container.decode(String.self, forKey: .line)}catch{line = ""}
        do {open_time = try container.decode(String.self, forKey: .open_time)}catch{open_time = ""}
        do {close_time = try container.decode(String.self, forKey: .close_time)}catch{close_time = ""}
        do {area_id = try container.decode(Int.self, forKey: .area_id)}catch{area_id = -1}
        do {road = try container.decode(String.self, forKey: .road)}catch{road = ""}
        do {zip = try container.decode(Int.self, forKey: .zip)}catch{zip = -1}
    }
    
    override func filterRow() {
        super.filterRow()
        
        if self.city_id > 0 && area_id > 0 {
            let city_name = Global.instance.zoneIDToName(city_id)
            let area_name = Global.instance.zoneIDToName(area_id)
            address = String(zip) + city_name + area_name + road
        }
        
        if open_time.count > 0 {
            open_time_show = open_time.noSec()
        }
        
        if close_time.count > 0 {
            close_time_show = close_time.noSec()
        }
        
        if open_time.count > 0 && close_time.count > 0 {
            interval_show = "\(open_time)~\(close_time)"
        }
    }
}
