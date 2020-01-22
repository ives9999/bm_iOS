//
//  File.swift
//  bm
//
//  Created by ives on 2019/5/26.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

@objc(SuperCourse)
class SuperCourse: SuperModel {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var title: String = ""
    @objc dynamic var channel: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var coach_id: Int = -1
    @objc dynamic var price: Int = -1
    @objc dynamic var price_unit: String = ""
    //var price_uint1: PRICE_UNIT = PRICE_UNIT.month
    @objc dynamic var price_desc: String = ""
    @objc dynamic var price_text_long: String = ""
    @objc dynamic var price_text_short: String = ""
    @objc dynamic var people_limit: Int = -1
    @objc dynamic var people_limit_text: String = ""
    @objc dynamic var kind: String = ""
    @objc dynamic var kind_text: String = ""
    @objc dynamic var cycle: Int = -1
    @objc dynamic var cycle_unit: String = ""
    @objc dynamic var start_date: String = ""
    @objc dynamic var end_date: String = ""
    @objc dynamic var weekday: Int = -1
    @objc dynamic var weekday_text: String = ""
    @objc dynamic var start_time: String = ""
    @objc dynamic var end_time: String = ""
    @objc dynamic var deadline: String = ""
    @objc dynamic var start_time_text: String = ""
    @objc dynamic var end_time_text: String = ""
    @objc dynamic var youtube: String = ""
    
    
    @objc dynamic var content: String = ""
    @objc dynamic var status: String = "online"
    @objc dynamic var token: String = ""
    @objc dynamic var sort_order: Int = 0
    @objc dynamic var pv: Int = 0
    @objc dynamic var created_id: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var created_at_text: String = ""
    @objc dynamic var featured_path: String = ""
    @objc dynamic var thumb: String = ""
    
    @objc dynamic var featured: UIImage = UIImage(named: "nophoto")!
    @objc dynamic var coach: SuperCoach = SuperCoach()
    @objc dynamic var nextCourseTime: [String: String] = [String: String]()
    @objc dynamic var signups: SuperSignups = SuperSignups()
    @objc dynamic var isSignup: Bool = false
    @objc dynamic var signup_id: Int = 0
    @objc dynamic var weekday_arr: [Int] = [Int]()
    @objc dynamic var date_model: SuperDate = SuperDate()
    @objc dynamic var signup_normal_models: [SuperSignupNormal] = [SuperSignupNormal]()
    @objc dynamic var signup_standby_models: [SuperSignupStandby] = [SuperSignupStandby]()
    
    override func filterRow() {
        created_at_text = created_at.noTime()
        if featured_path.count > 0 {
            if !featured_path.hasPrefix("http://") || !featured_path.hasPrefix("https://") {
                featured_path = BASE_URL + featured_path
                //print(featured_path)
            }
        }
    }
    
    override func getFeaturedPath() -> String {
        return featured_path
    }
    
    override func setFeatured(_ image: UIImage) {
        featured = image
    }
}

class SuperCourses: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var page: Int = 0
    @objc dynamic var totalCount: Int = 0
    @objc dynamic var perPage: Int = 0
    @objc dynamic var rows: [SuperCourse] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
    
    override func getRows<SuperCourse>() -> [SuperCourse]? {
        return (rows as! [SuperCourse])
    }
    
    override func getRowFromIdx<T>(_ idx: Int) -> T? where T : SuperModel {
        if rows.count >= idx {
            return (rows[idx] as! T)
        } else {
            return nil
        }
    }
}
