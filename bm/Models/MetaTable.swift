//
//  Meta.swift
//  bm
//
//  Created by ives on 2024/4/7.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class MetaTable: Codable {
    var totalCount: Int = 0
    var totalPage: Int = 0
    var currentPage: Int = 1
    var offset: Int = 0
    var perPage: Int = 20
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        totalCount = try container.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
        totalPage = try container.decodeIfPresent(Int.self, forKey: .totalPage) ?? 0
        currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage) ?? 1
        offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 0
        perPage = try container.decodeIfPresent(Int.self, forKey: .perPage) ?? 20
    }
}
