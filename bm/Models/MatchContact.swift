//
//  MatchTable.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchContactsTable: Tables {
    
    var rows: [MatchContactTable] = [MatchContactTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([MatchContactTable].self, forKey: .rows)
    }
}

class MatchContactTable: Table {
    var contact_name: String = ""
    var contact_tel: String = ""
    var contact_email: String = ""
    var contact_line: String = ""
    
    enum CodingKeys: String, CodingKey {
        case contact_name
        case contact_tel
        case contact_email
        case contact_line
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {contact_name = try container.decode(String.self, forKey: .contact_name)}catch{contact_name = ""}
        do {contact_tel = try container.decode(String.self, forKey: .contact_tel)}catch{contact_tel = ""}
        do {contact_email = try container.decode(String.self, forKey: .contact_email)}catch{contact_email = ""}
        do {contact_line = try container.decode(String.self, forKey: .contact_line)}catch{contact_line = ""}
    }
    
    override func filterRow() {
        
        super.filterRow()
    }
}
