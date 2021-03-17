//
//  StoreTable.swift
//  bm
//
//  Created by ives sun on 2021/3/17.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class StoresTable: Table {
    
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var rows: [StoreTable] = [StoreTable]()
    
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
        rows = try container.decode([StoreTable].self, forKey: .rows)
    }
}

class StoreTable: Table {
    
    var name: String = ""
    
    var tel: String = ""
    var mobile: String = ""
    var fb: String = ""
    var website: String = ""
    var email: String = ""
    var line: String = ""
    
    var open_time: String = ""
    var close_time: String = ""
    
    var city_id: Int = -1
    var area_id: Int = -1
    var road: String = ""
    var zip: Int = -1
    
    var content: String = ""
    
    var address: String = ""
    var tel_show: String = ""
    var mobile_show: String = ""
    var open_time_show: String = ""
    var close_time_show: String = ""
    var city_show: String = ""
    
    var managers: [[String: Any]] = [[String: Any]]()
    
    enum CodingKeys: String, CodingKey {
        case name
        case tel
        case mobile
        case fb
        case website
        case email
        case line
        case open_time
        case close_time
        case city_id
        case area_id
        case road
        case zip
        case content
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {name = try container.decode(String.self, forKey: .name)}catch{name=""}
        do {tel = try container.decode(String.self, forKey: .tel)}catch{tel = ""}
        do {mobile = try container.decode(String.self, forKey: .mobile)}catch{mobile = ""}
        do {fb = try container.decode(String.self, forKey: .fb)}catch{fb = ""}
        do {website = try container.decode(String.self, forKey: .website)}catch{website = ""}
        do {email = try container.decode(String.self, forKey: .email)}catch{email = ""}
        do {line = try container.decode(String.self, forKey: .line)}catch{line = ""}
        do {content = try container.decode(String.self, forKey: .content)}catch{content = ""}
        do {open_time = try container.decode(String.self, forKey: .open_time)}catch{open_time = ""}
        do {close_time = try container.decode(String.self, forKey: .close_time)}catch{close_time = ""}
        do {city_id = try container.decode(Int.self, forKey: .city_id)}catch{city_id = -1}
        do {area_id = try container.decode(Int.self, forKey: .area_id)}catch{area_id = -1}
        do {road = try container.decode(String.self, forKey: .road)}catch{road = ""}
        do {zip = try container.decode(Int.self, forKey: .zip)}catch{zip = -1}
    }
    
    override func filterRow() {
        super.filterRow()
        
        if city_id > 0 && area_id > 0 {
            let city_name = Global.instance.zoneIDToName(city_id)
            let area_name = Global.instance.zoneIDToName(area_id)
            address = String(zip) + city_name + area_name + road
        }
        
        if city_id > 0 {
            city_show = Global.instance.zoneIDToName(city_id)
        }
        
        if tel.count > 0 {
            tel_show = tel.telShow()
        }
        
        if mobile.count > 0 {
            mobile_show = mobile.mobileShow()
        }
        
        if open_time.count > 0 {
            open_time_show = open_time.noSec()
        }
        
        if close_time.count > 0 {
            close_time_show = close_time.noSec()
        }
    }
}
