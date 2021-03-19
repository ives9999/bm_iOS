//
//  CoachTable.swift
//  bm
//
//  Created by ives on 2021/3/17.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class CoachesTable: Tables {
    var rows: [CoachTable] = [CoachTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([CoachTable].self, forKey: .rows)
    }
}

class CoachTable: Table {
    var name: String = ""
    var mobile: String = ""
    var email: String = ""
    var website: String = ""
    var fb: String = ""
    var youtube: String = ""
    var line: String = ""
    var seniority: Int = -1
    var exp: String = ""
    var feat: String = ""
    var license: String = ""
    var charge: String = ""
    var content: String = ""
    var manager_id: Int = -1
    var color: String = ""
    var city_id: Int = -1
    
    var city_show: String = ""
    var mobile_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case mobile
        case email
        case website
        case fb
        case youtube
        case line
        case seniority
        case exp
        case feat
        case license
        case charge
        case content
        case manager_id
        case color
        case city_id
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {name = try container.decode(String.self, forKey: .name)}catch{name=""}
        do {mobile = try container.decode(String.self, forKey: .mobile)}catch{mobile = ""}
        do {email = try container.decode(String.self, forKey: .email)}catch{email = ""}
        do {website = try container.decode(String.self, forKey: .website)}catch{website = ""}
        do {fb = try container.decode(String.self, forKey: .fb)}catch{fb = ""}
        do {youtube = try container.decode(String.self, forKey: .youtube)}catch{youtube = ""}
        do {line = try container.decode(String.self, forKey: .line)}catch{line = ""}
        do {seniority = try container.decode(Int.self, forKey: .seniority)}catch{seniority = -1}
        do {exp = try container.decode(String.self, forKey: .exp)}catch{exp = ""}
        do {feat = try container.decode(String.self, forKey: .feat)}catch{feat = ""}
        do {license = try container.decode(String.self, forKey: .license)}catch{license = ""}
        do {charge = try container.decode(String.self, forKey: .charge)}catch{charge = ""}
        do {content = try container.decode(String.self, forKey: .content)}catch{content = ""}
        do {manager_id = try container.decode(Int.self, forKey: .manager_id)}catch{manager_id = 0}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        do {city_id = try container.decode(Int.self, forKey: .city_id)}catch{city_id = 0}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        if city_id > 0 {
            city_show = Global.instance.zoneIDToName(city_id)
        }
        
        if mobile.count > 0 {
            mobile_show = mobile.mobileShow()
        }
    }
}
