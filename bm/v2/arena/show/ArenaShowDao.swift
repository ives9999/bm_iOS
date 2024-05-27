//
//  ArenaShowDao.swift
//  bm
//
//  Created by ives on 2024/5/26.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaShowDao: BaseDao {
    var status: Int = 0
    var data: ArenaData = ArenaData()
    
    class ArenaData: Codable {
        var id: Int = 0
        var name: String = ""
        var zone: Zone? = nil
        var zip: Int = 0
        var road: String = ""
        var tel: String = ""
        var open_time: String = ""
        var close_time: String = ""
        var block: Int = 0
        var bathroom: Int = 0
        var air_condition: Int = 0
        var parking: Int = 0
        var fb: String = ""
        var youtube: String = ""
        var line: String = ""
        var website: String = ""
        var charge: String = ""
        var content: String = ""
        var token: String = ""
        var pv: Int = 0
        var created_at: String = ""
        var updated_at: String = ""
        var images: [Image] = [Image]()
        
        class Zone: Codable {
            var city_id: Int = 0
            var area_id: Int = 0
            var city_name: String = ""
            var area_name: String = ""
        }
        
        class Image: Codable {
            var path: String = ""
        }
    }
}
