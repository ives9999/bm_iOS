//
//  DateTable.swift
//  bm
//
//  Created by ives on 2021/3/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class DateTable: Table {
    
    var signupable_id: Int = -1
    var signupable_type: String = ""
    var date: String = ""
    
    enum CodingKeys: String, CodingKey {
        case signupable_id
        case signupable_type
        case date
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {signupable_id = try container.decode(Int.self, forKey: .signupable_id)}catch{signupable_id = 0}
        do {signupable_type = try container.decode(String.self, forKey: .signupable_type)}catch{signupable_type = ""}
        do {date = try container.decode(String.self, forKey: .date)}catch{date = ""}
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
