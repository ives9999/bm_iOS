//
//  TeachTable.swift
//  bm
//
//  Created by ives on 2021/3/18.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class TeachesTable: Tables {
    
    var rows: [TeachTable] = [TeachTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([TeachTable].self, forKey: .rows)
    }
}

class TeachTable: Table {
    
    var title: String = ""
    var content: String = ""
    var youtube: String = ""
    var provider: String = ""
    var provider_url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case youtube
        case provider
        case provider_url
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {title = try container.decode(String.self, forKey: .title)}catch{title=""}
        do {content = try container.decode(String.self, forKey: .content)}catch{content = ""}
        do {youtube = try container.decode(String.self, forKey: .youtube)}catch{youtube = ""}
        do {provider = try container.decode(String.self, forKey: .provider)}catch{provider = ""}
        do {provider_url = try container.decode(String.self, forKey: .provider_url)}catch{provider_url = ""}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
        
    }
}
