//
//  CourseTable.swift
//  bm
//
//  Created by ives on 2021/3/15.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class CoursesTable: Tables {
    
    var rows: [CourseTable] = [CourseTable]()
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = try container.decode([CourseTable].self, forKey: .rows)
    }
}

class CourseTable: Table {
    
    //var id: Int = -1
    var title: String = ""
    var coach_id: Int = -1
    var price: Int = -1
    var price_unit: String = ""
    var price_desc: String = ""
    var price_text_short: String = ""
    var price_text_long: String = ""
    var people_limit: Int = -1
    var people_limit_text: String = ""
    var kind: String = ""
    var kind_text: String = ""
    
    var cycle: Int = -1
    var cycle_unit: String = ""
    var weekday: Int = -1
    var weekday_text: String = ""
    var start_date: String = ""
    var end_date: String = ""
    var start_time: String = ""
    var end_time: String = ""
    var deadline: String = ""
    var youtube: String = ""

    var content: String = ""
    var city_id: Int = -1
    
    var coachTable: CoachTable?
    var dateTable: DateTable?
    var signupNormalTables: [SignupNormalTable] = [SignupNormalTable]()
    var signupStandbyTables: [SignupStandbyTable] = [SignupStandbyTable]()

    //var nextCourseTime: [String: String] = [String: String]()
    var isSignup: Bool = false
    var signup_id: Int = 0
    //var weekday_arr: [Int] = [Int]()

    var start_time_show: String = ""
    var end_time_show: String = ""
    var city_show: String = ""
    var price_long_show: String = ""
    var price_short_show: String = ""
    var people_limit_show: String = ""
    var kind_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        case title
        case coach_id
        case price
        case price_unit
        case price_desc
        case price_text_short
        case price_text_long
        case people_limit
        case people_limit_text
        case kind
        case kind_text
        case cycle
        case cycle_unit
        case start_date
        case end_date
        case start_time
        case end_time
        case weekday
        case weekday_text
        case deadline
        case youtube
        case content
        case created_id
        case city_id
        //case nextCourseTime
        case isSignup
        case signup_id
        case weekday_arr
        
        case coachTable = "coach" // php json的key值
        case dateTable = "date_model"
        case signupNormalTables = "signup_normal_models"
        case signupStandbyTables = "signup_standby_models"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {title = try container.decode(String.self, forKey: .title)}catch{title=""}
        do {coach_id = try container.decode(Int.self, forKey: .coach_id)}catch{coach_id = 0}
        do {price = try container.decode(Int.self, forKey: .price)}catch{price = 0}
        do {price_unit = try container.decode(String.self, forKey: .price_unit)}catch{price_unit = ""}
        do {price_desc = try container.decode(String.self, forKey: .price_desc)}catch{price_desc = ""}
        do {price_text_short = try container.decode(String.self, forKey: .price_text_short)}catch{price_text_short = ""}
        do {price_text_long = try container.decode(String.self, forKey: .price_text_long)}catch{price_text_long = ""}
        do {kind = try container.decode(String.self, forKey: .kind)}catch{kind = ""}
        do {kind_text = try container.decode(String.self, forKey: .kind_text)}catch{kind_text = ""}
        do {people_limit = try container.decode(Int.self, forKey: .people_limit)}catch{people_limit = 0}
        do {people_limit_text = try container.decode(String.self, forKey: .people_limit_text)}catch{people_limit_text = ""}
        do {cycle = try container.decode(Int.self, forKey: .cycle)}catch{cycle = 0}
        do {cycle_unit = try container.decode(String.self, forKey: .cycle_unit)}catch{cycle_unit = ""}
        do {start_date = try container.decode(String.self, forKey: .start_date)}catch{start_date = ""}
        do {end_date = try container.decode(String.self, forKey: .end_date)}catch{end_date = ""}
        do {start_time = try container.decode(String.self, forKey: .start_time)}catch{start_time = ""}
        do {end_time = try container.decode(String.self, forKey: .end_time)}catch{end_time = ""}
        do {weekday = try container.decode(Int.self, forKey: .weekday)}catch{weekday = 0}
        do {weekday_text = try container.decode(String.self, forKey: .weekday_text)}catch{weekday_text = ""}
        do {deadline = try container.decode(String.self, forKey: .deadline)}catch{deadline = ""}
        do {youtube = try container.decode(String.self, forKey: .youtube)}catch{youtube = ""}
        do {content = try container.decode(String.self, forKey: .content)}catch{content = ""}
        do {created_id = try container.decode(Int.self, forKey: .created_id)}catch{created_id = 0}
        do {city_id = try container.decode(Int.self, forKey: .city_id)}catch{city_id = 0}
        do {isSignup = try container.decode(Bool.self, forKey: .isSignup)}catch{isSignup = false}
        do {signup_id = try container.decode(Int.self, forKey: .signup_id)}catch{signup_id = 0}
        
        do {coachTable = try container.decode(CoachTable.self, forKey: .coachTable)}catch{coachTable = nil}
        do {dateTable = try container.decode(DateTable.self, forKey: .dateTable)}catch{coachTable = nil}
        
        do {signupNormalTables = try container.decode([SignupNormalTable].self, forKey: .signupNormalTables)}catch{signupNormalTables = [SignupNormalTable]()}
        do {signupStandbyTables = try container.decode([SignupStandbyTable].self, forKey: .signupStandbyTables)}catch{signupStandbyTables = [SignupStandbyTable]()}
    }
    
    override func filterRow() {
        
        super.filterRow()
        
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
    
    override public func printRow() {
        //super.printRow()
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            print("\(property.label ?? "")=>\(property.value)")
        }
    }
}
