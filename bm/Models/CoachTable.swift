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
    var manager_id: Int = -1
    var color: String = ""
    var citys: [CityTable] = [CityTable]()
    
    var seniority_show: String = ""
        
    enum CodingKeys: String, CodingKey {
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
        case manager_id
        case color
        case citys
    }
    
    override init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
        do {manager_id = try container.decode(Int.self, forKey: .manager_id)}catch{manager_id = 0}
        do {color = try container.decode(String.self, forKey: .color)}catch{color = ""}
        do {citys = try container.decode([CityTable].self, forKey: .citys)}catch{citys = [CityTable]()}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        if seniority >= 0 {
            seniority_show = "\(seniority)年"
        }
    }
}
