//
//  CalendarSignupCell.swift
//  bm
//
//  Created by ives on 2019/11/17.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class CalendarSignupCell: SuperCell {
    
    @IBOutlet weak var dateTxt: SuperLabel!
    @IBOutlet weak var courseContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        courseContainer.layoutIfNeeded()
//
//    }
    
    func update(_ dateCourse: [String: Any], course_width width: Int, course_height height: Int=300, course_gap gap: Int=10) {
        var date: String = "錯誤"
        if dateCourse["date"] != nil {
            date = dateCourse["date"] as? String ?? "錯誤"
        }
        var weekday_c: String = "錯誤"
        if dateCourse["weekday_c"] != nil {
            weekday_c = dateCourse["weekday_c"] as? String ?? "錯誤"
        }
        dateTxt.text = "\(date)(\(weekday_c))"
        
        var weekday_i: Int = -1
        if dateCourse["weekday_i"] != nil {
            weekday_i = dateCourse["weekday_i"] as? Int ?? -1
        }
        
        var background_color = UIColor.clear
        if weekday_i == 1 {
            background_color = UIColor(MONDAY_COLOR)
        } else if weekday_i == 2 {
            background_color = UIColor(TUESDAY_COLOR)
        } else if weekday_i == 3 {
            background_color = UIColor(WEDNESDAY_COLOR)
        } else if weekday_i == 4 {
            background_color = UIColor(THURSDAY_COLOR)
        } else if weekday_i == 5 {
            background_color = UIColor(FRIDAY_COLOR)
        } else if weekday_i == 6 {
            background_color = UIColor(SATURDAY_COLOR)
        } else if weekday_i == 7 {
            background_color = UIColor(SUNDAY_COLOR)
        }
        
        if let rows: [SuperCourse] = dateCourse["rows"] as? [SuperCourse] {
            
            if rows.count > 0 {
                var y: Int = 0
                let x: Int = 0
                for row in rows {
                    let v: CourseView = CourseView(frame: CGRect(x: x, y: y, width: width, height: height))
                    v.update(row, background_color)
                    courseContainer.addSubview(v)
                    y = y + height + gap
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
