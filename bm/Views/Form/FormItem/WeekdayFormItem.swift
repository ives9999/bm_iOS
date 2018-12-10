//
//  WeekdayFormItem.swift
//  bm
//
//  Created by ives on 2018/12/10.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class WeekdayFormItem: FormItem {
    
    var weekdays: [Int] = [Int]()
    
    required init(title: String) {
        super.init(title: title, placeholder: nil, value: nil)
        segue = TO_SELECT_WEEKDAY
        uiProperties.cellType = .weekday
        reset()
    }
    
    override func reset() {
        super.reset()
        weekdays = [Int]()
        sender = [Int]()
    }
    
    override func make() {
        var texts: [String] = [String]()
        if weekdays.count > 0 {
            for weekday in weekdays {
                for gweekday in Global.instance.weekdays {
                    if weekday == gweekday["value"] as! Int {
                        let text = gweekday["simple_text"]
                        texts.append(text! as! String)
                        break
                    }
                }
            }
            show = texts.joined(separator: ",")
            sender = weekdays
        } else {
            show = ""
        }
    }
}
