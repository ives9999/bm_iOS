//
//  ReturnTable.swift
//  bm
//
//  Created by ives on 2022/5/23.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class ReturnTable: Table {
    
    var order_id: Int = -1
    var sn_id: String = ""
    var return_code: String = ""
    var expire_at: String = ""
    var error_msg: String = ""
    
    enum CodingKeys: String, CodingKey {
        case order_id
        case sn_id
        case return_code
        case expire_at
        case error_msg
    }
    
    override init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        order_id = try container.decodeIfPresent(Int.self, forKey: .order_id) ?? -1
        sn_id = try container.decodeIfPresent(String.self, forKey: .sn_id) ?? ""
        return_code = try container.decodeIfPresent(String.self, forKey: .return_code) ?? ""
        expire_at = try container.decodeIfPresent(String.self, forKey: .expire_at) ?? ""
        error_msg = try container.decodeIfPresent(String.self, forKey: .error_msg) ?? ""
    }
    
    override func filterRow() {
        super.filterRow()
        if created_at.count > 0 {
            created_at_show = created_at.noSec()
        }
    }
}
