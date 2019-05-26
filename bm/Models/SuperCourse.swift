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
    @objc dynamic var price_desc: String = ""
    @objc dynamic var limit: Int = -1
    @objc dynamic var kind: String = ""
    @objc dynamic var cycle: Int = -1
    @objc dynamic var cycle_unit: String = ""
    @objc dynamic var start_date: String = ""
    @objc dynamic var end_date: String = ""
    @objc dynamic var weekday: Int = -1
    @objc dynamic var start_time: String = ""
    @objc dynamic var end_time: String = ""
    @objc dynamic var youtube: String = ""
    
    
    @objc dynamic var content: String = ""
    @objc dynamic var status: String = "online"
    @objc dynamic var token: String = ""
    @objc dynamic var sort_order: Int = 0
    @objc dynamic var pv: Int = 0
    @objc dynamic var created_id: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var featured_path: String = ""
    @objc dynamic var thumb: String = ""
    
    @objc dynamic var featured: UIImage = UIImage(named: "nophoto")!
    
    override func filterRow() {
        
    }
}

class SuperCourses: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var rows: [SuperCourse] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
}
