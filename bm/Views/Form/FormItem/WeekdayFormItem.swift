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
        segue = TO_MULTI_SELECT
        uiProperties.cellType = .weekday
        reset()
    }
    
    override func reset() {
        super.reset()
        weekdays = [Int]()
        sender = [Int]()
    }
    
    override func make() {
        if value != nil {
            weekdays.removeAll()
            if value!.contains(",") {
                valueToAnother()
            } else {
                weekdays.append(Int(value!)!)
            }
            
            var texts: [String] = [String]()
            var senders: [String] = [String]()
            if weekdays.count > 0 {
                for weekday in weekdays {
//                    for gweekday in Global.instance.weekdays {
//                        if weekday == gweekday["value"] as! Int {
//                            let text = gweekday["simple_text"]
//                            texts.append(text! as! String)
//                            break
//                        }
//                    }
//                    values.append(String(weekday))
                    let text = WEEKDAY.intToString(weekday)
                    texts.append(text)
                    senders.append(String(weekday))
                }
                show = texts.joined(separator: ",")
                //value = values.joined(separator: ",")
                sender = senders
            } else {
                show = ""
            }
        }
    }
    
    override func valueToAnother() {
        let values: [String] = value!.components(separatedBy: ",")
        for v in values {
            weekdays.append(Int(v)!)
        }
    }
}
