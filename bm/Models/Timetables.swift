//
//  TimeTable.swift
//  bm
//
//  Created by ives on 2018/11/28.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation
class Timetables: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var rows: [Timetable] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
}

@objc(Timetable)
class Timetable: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var title: String = ""
    @objc dynamic var weekday: Int = -1
    @objc dynamic var weekday_text: String = ""
    @objc dynamic var start_date: String = ""
    @objc dynamic var end_date: String = ""
    @objc dynamic var start_time: String = ""
    @objc dynamic var start_time_text: String = ""
    @objc dynamic var end_time: String = ""
    @objc dynamic var end_time_text: String = ""
    @objc dynamic var charge: Int = 0
    @objc dynamic var charge_text: String = ""
    @objc dynamic var limit: Int = -1
    @objc dynamic var limit_text: String = ""
    @objc dynamic var signup_count: Int = 0
    @objc dynamic var count: Int = 0
    @objc dynamic var content: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var content_style: String = ""
    @objc dynamic var status: String = "online"
    @objc dynamic var pv: Int = 0
    @objc dynamic var created_id: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    var _start_hour: Int = 0
    var _start_minute: Int = 0
    var _end_hour: Int = 0
    var _end_minute: Int = 0
    var _color: MYCOLOR = .success
    
    override func filterRow() {
        _start_hour = start_time.toDateTime(format:"HH:mm:ss").getH()
        _end_hour = end_time.toDateTime(format:"HH:mm:ss").getH()
        _start_minute = start_time.toDateTime(format:"HH:mm:ss").getm()
        _end_minute = end_time.toDateTime(format:"HH:mm:ss").getm()
        _color = MYCOLOR(color: color)
    }
}
