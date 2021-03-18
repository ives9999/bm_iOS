//
//  TeachTable.swift
//  bm
//
//  Created by ives on 2021/3/18.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class TeachesTable: Table {
    
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var rows: [TeachTable] = [TeachTable]()
    
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
