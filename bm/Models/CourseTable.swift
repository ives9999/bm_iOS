//
//  CourseTable.swift
//  bm
//
//  Created by ives on 2021/3/15.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class CoursesTable: Table {
    
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var rows: [CourseTable] = [CourseTable]()
    
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
        rows = try container.decode([CourseTable].self, forKey: .rows)
    }
}

class CourseTable: Table {
    
    var id: Int = -1
    var title: String = ""
    var channel: String = ""
    var slug: String = ""
    var coach_id: Int = -1
    var price: Int = -1
    var price_unit: String = ""
    var price_desc: String = ""
    var people_limit: Int = -1
    var kind: String = ""
    
    var cycle: Int = -1
    var cycle_unit: String = ""
    var start_date: String = ""
    var end_date: String = ""
    var weekday: Int = -1
    var weekday_text: String = ""
    var start_time: String = ""
    var end_time: String = ""
    var deadline: String = ""
    var youtube: String = ""

    var content: String = ""
    var status: String = "online"
    var token: String = ""
    var sort_order: Int = 0
    var pv: Int = 0
    var created_id: Int = 0
    var created_at: String = ""
    var updated_at: String = ""

    var featured_path: String = ""
    var city_id: Int = -1

    //var nextCourseTime: [String: String] = [String: String]()
    var isSignup: Bool = false
    var signup_id: Int = 0
    //var weekday_arr: [Int] = [Int]()

    var created_at_show: String = ""
    var start_time_show: String = ""
    var end_time_show: String = ""
    var city_show: String = ""
    var price_long_show: String = ""
    var price_short_show: String = ""
    var people_limit_show: String = ""
    var kind_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case channel
        case slug
        case coach_id
        case price
        case price_unit
        case price_desc
        case kind
        case cycle
        case cycle_unit
        case start_date
        case end_date
        case deadline
        case youtube
        case content
        case status
        case token
        case sort_order
        case pv
        case created_id
        case created_at
        case update_at
        case featured_path
        case thumb
        case city_id
        //case nextCourseTime
        case isSignup
        case signup_id
        case weekday_arr
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        do {channel = try container.decode(String.self, forKey: .channel)}catch{channel = ""}
        do {slug = try container.decode(String.self, forKey: .slug)}catch{slug = ""}
        do {coach_id = try container.decode(Int.self, forKey: .coach_id)}catch{coach_id = 0}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = 0}
        do {price_unit = try container.decode(String.self, forKey: .price_unit)}catch{price_unit = ""}
        do {price_desc = try container.decode(String.self, forKey: .price_desc)}catch{price_desc = ""}
        do {kind = try container.decode(String.self, forKey: .kind)}catch{kind = ""}
        do {cycle = try container.decode(Int.self, forKey: .cycle)}catch{cycle = 0}
        do {cycle_unit = try container.decode(String.self, forKey: .cycle_unit)}catch{cycle_unit = ""}
        do {start_date = try container.decode(String.self, forKey: .start_date)}catch{start_date = ""}
        do {end_date = try container.decode(String.self, forKey: .end_date)}catch{end_date = ""}
        do {deadline = try container.decode(String.self, forKey: .deadline)}catch{deadline = ""}
        do {youtube = try container.decode(String.self, forKey: .youtube)}catch{youtube = ""}
        do {content = try container.decode(String.self, forKey: .content)}catch{content = ""}
        do {status = try container.decode(String.self, forKey: .status)}catch{status = "online"}
        do {token = try container.decode(String.self, forKey: .token)}catch{token = ""}
        do {sort_order = try container.decode(Int.self, forKey: .sort_order)}catch{sort_order = 0}
        do {pv = try container.decode(Int.self, forKey: .pv)}catch{pv = 0}
        do {created_id = try container.decode(Int.self, forKey: .created_id)}catch{created_id = 0}
        do {created_at = try container.decode(String.self, forKey: .created_at)}catch{created_at = ""}
        do {updated_at = try container.decode(String.self, forKey: .update_at)}catch{updated_at = ""}
        do {featured_path = try container.decode(String.self, forKey: .featured_path)}catch{featured_path = ""}
        do {city_id = try container.decode(Int.self, forKey: .city_id)}catch{city_id = 0}
        do {isSignup = try container.decode(Bool.self, forKey: .isSignup)}catch{isSignup = false}
        do {signup_id = try container.decode(Int.self, forKey: .signup_id)}catch{signup_id = 0}
    }
    
    override func filterRow() {
        
        //super.filterRow()
        if featured_path.count > 0 {
            if !featured_path.hasPrefix("http://") || !featured_path.hasPrefix("https://") {
                featured_path = BASE_URL + featured_path
                //print(featured_path)
            }
        }
        created_at_show = created_at.noTime()
        
        if city_id > 0 {
            city_show = Global.instance.zoneIDToName(city_id)
        }
        
        if start_time.count > 0 {
            start_time_show = start_time.noSec()
        }
        
        if end_time.count > 0 {
            end_time_show = end_time.noSec()
        }
    }
}
