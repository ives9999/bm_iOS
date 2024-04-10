//
//  DataTable.swift
//  bm
//
//  Created by ives on 2024/4/9.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class DataTable<T: Codable>: Codable {
    var _meta: MetaTable = MetaTable()
    var rows: [T] = [T]()
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _meta = try container.decodeIfPresent(MetaTable.self, forKey: ._meta) ?? MetaTable()
        rows = try container.decodeIfPresent([T].self, forKey: .rows) ?? [T]()
        let i = 6
    }
}
