//
//  ArenaReadDao.swift
//  bm
//
//  Created by ives on 2024/5/8.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaReadDao: Codable {
    
    var status: Int = 500
        //var data: ArenaData = ArenaData()
    
    class ArenaData {
        var rows: [Arena] = [Arena]()
        //var meta: Meta = Meta()
        
        enum CodingKeys: String, CodingKey {
            case rows
            //case meta = "_meta"
        }
        
        init(from decoder: Decoder) throws {
            
        }
    }
    
    class Arena {
        var id: Int = 0
        var name: String = ""
        var images: [Image] = [Image]()
        var zone: Zone = Zone()
        var member: Member = Member()
        var token: String = ""
        var pv: Int = 0
        var created_at: String = ""
    }
    
    class Meta {
        var totalCount: Int = 0
        var totalPage: Int = 0
        var currentPage: Int = 1
        var offset: Int = 0
        var perpage: Int = PERPAGE
    }
    
    class Image: Codable {
        var path: String = ""
        var upload_id: Int = 0
        var sort_order: Int = 0
        var isFeatured: Bool = false
    }
}


