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
    
    required init(name: String, title: String, timeType: SELECT_TIME_TYPE, tooltip: String?=nil, isRequired: Bool = true) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip)
        segue = TO_SINGLE_SELECT
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
            show = value!.noSec()
            sender = ["type":timeType!,"time":value!]
        } else {
            sender = ["type":timeType!,"time":""]
        }
    }
}
