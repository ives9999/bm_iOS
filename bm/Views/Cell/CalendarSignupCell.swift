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
    
    func update(date: String, superModels: [SuperModel], course_width: Int, course_height: Int) {
        let d: Date = date.toDate()
        let weekday_i = d.dateToWeekday()
        let weekday_c: String = d.dateToWeekdayForChinese()
        dateTxt.text = "\(date)(\(weekday_c))"
        
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
        
        
//        let v: CourseView = CourseView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
//        v.containerView.backgroundColor = background_color
//        courseContainer.addSubview(v)
        
//        let v1: CourseView = CourseView(frame: CGRect(x: 0, y: 110, width: 100, height: 200))
//        v1.containerView.backgroundColor = background_color
//        courseContainer.addSubview(v1)
        
        
        //print(superModels.count)
        var course_count = 0
        let gap: Int = 10
        for superModel in superModels {
            if let superCourse = superModel as? SuperCourse {
                //superCourse.printRow()
                for weekday in superCourse.weekday_arr {
                    if weekday == weekday_i {
                        var height: Int = course_count*course_height
                        if course_count > 0 {
                            height = height + gap
                        }
                        let v: CourseView = CourseView(frame: CGRect(x: 0, y: height, width: course_width, height: course_height))
                        v.containerView.backgroundColor = background_color
                        courseContainer.addSubview(v)
                        course_count = course_count+1
                    }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
