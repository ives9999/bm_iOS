//
//  WeekdayFormItem.swift
//  bm
//
//  Created by ives on 2018/12/10.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class WeekdayFormItem: FormItem {
    
    var oldWeekdays: [Int] = [Int]()
    var weekdays: [Int] = [Int]()
    
    required init(title: String = "星期幾", name: String = TT_WEEKDAY) {
        super.init(name: name, title: title, placeholder: nil, value: nil)
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
        var values: [String] = [String]()
        if weekdays.count > 0 {
            for weekday in weekdays {
                for gweekday in Global.instance.weekdays {
                    if weekday == gweekday["value"] as! Int {
                        let text = gweekday["simple_text"]
                        texts.append(text! as! String)
                        break
                    }
                }
                values.append(String(weekday))
            }
            show = texts.joined(separator: ",")
            value = values.joined(separator: ",")
            sender = weekdays
        } else {
            show = ""
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            let values: [String] = value!.components(separatedBy: ",")
            weekdays.removeAll()
            for v in values {
                weekdays.append(Int(v)!)
            }
        }
    }
}
