//
//  Table.swift
//  bm
//
//  Created by ives on 2021/3/15.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class Table: Codable {
    
    var id: Int = -1
    var channel: String = ""
    var slug: String = ""
    var status: String = "online"
    var token: String = ""
    var sort_order: Int = 0
    var pv: Int = 0
    var created_id: Int = 0
    var featured_path: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    
    var created_at_show: String = ""
    var updated_at_show: String = ""
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {id = try container.decode(Int.self, forKey: .id)}catch{id = 0}
        do {channel = try container.decode(String.self, forKey: .channel)}catch{channel = ""}
        do {slug = try container.decode(String.self, forKey: .slug)}catch{slug = ""}
        do {status = try container.decode(String.self, forKey: .status)}catch{status = "online"}
        do {token = try container.decode(String.self, forKey: .token)}catch{token = ""}
        do {featured_path = try container.decode(String.self, forKey: .featured_path)}catch{featured_path = ""}
        do {sort_order = try container.decode(Int.self, forKey: .sort_order)}catch{sort_order = 0}
        do {pv = try container.decode(Int.self, forKey: .pv)}catch{pv = 0}
        do {created_at = try container.decode(String.self, forKey: .created_at)}catch{created_at = ""}
        do {updated_at = try container.decode(String.self, forKey: .updated_at)}catch{updated_at = ""}
    }
    
    public func filterRow(){
        
        if featured_path.count > 0 {
            if !featured_path.hasPrefix("http://") && !featured_path.hasPrefix("https://") {
                featured_path = BASE_URL + featured_path
                //print(featured_path)
            }
        }
        
        if created_at.count > 0 {
            created_at_show = created_at.noTime()
        }
        
        if updated_at.count > 0 {
            updated_at_show = updated_at.noTime()
        }
    }
    
    public func printRow() {
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            print("\(property.label ?? "")=>\(property.value)")
        }
    }
}
