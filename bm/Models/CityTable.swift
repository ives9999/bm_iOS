//
//  CityTable.swift
//  bm
//
//  Created by ives on 2021/3/20.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class CityTable: Table {
    
    var parent_id: Int = -1
    var name: String = ""
    var zip: Int = -1
    
    enum CodingKeys: String, CodingKey {
        case parent_id
        case name
        case zip
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {parent_id = try container.decode(Int.self, forKey: .parent_id)}catch{parent_id=0}
        do {name = try container.decode(String.self, forKey: .name)}catch{name = ""}
        do {zip = try container.decode(Int.self, forKey: .zip)}catch{zip = -1}
    }
    
    override func filterRow() {
        
        super.filterRow()
    }
    
    override public func printRow() {
        //super.printRow()
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            print("\(property.label ?? "")=>\(property.value)")
        }
    }
}
