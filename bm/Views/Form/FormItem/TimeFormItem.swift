//
//  TimeFormItem.swift
//  bm
//
//  Created by ives on 2018/12/9.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class TimeFormItem: FormItem {
    
    var timeType: SELECT_TIME_TYPE?
    
    required init(name: String, title: String, timeType: SELECT_TIME_TYPE, tooltip: String?=nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip)
        segue = TO_SELECT_TIME
        uiProperties.cellType = .time
        self.timeType = timeType
        reset()
    }
    
    override func reset() {
        super.reset()
        make()
    }
    
    override func make() {
        if value != nil {
            show = value!
            sender = ["type":timeType!,"time":value!]
        } else {
            sender = ["type":timeType!,"time":""]
        }
    }
}
