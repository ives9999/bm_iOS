//
//  TimeTable.swift
//  bm
//
//  Created by ives on 2018/11/28.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation
class TimeTable: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var rows: [TimeTableRow] = Array()
    
    @objc(TimeTableRow)
    class TimeTableRow: SuperModel {
        @objc dynamic var id: Int = -1
        @objc dynamic var title: String = ""
        @objc dynamic var day: Int = -1
        @objc dynamic var start: String = ""
        @objc dynamic var end: String = ""
        @objc dynamic var limit: Int = -1
        @objc dynamic var count: Int = 0
        @objc dynamic var content: String = ""
        @objc dynamic var color: String = ""
        @objc dynamic var status: String = "online"
        @objc dynamic var created_id: Int = 0
        @objc dynamic var created_at: String = ""
        @objc dynamic var updated_at: String = ""
        var _start: Int = 0
        var _end: Int = 0
        var _color: MYCOLOR = .success
        
        override func filterRow() {
            _start = start.toDateTime(format:"HH:mm:ss").getH()
            _end = end.toDateTime(format:"HH:mm:ss").getH()
            _color = MYCOLOR(color: color)
        }
    }
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
}
