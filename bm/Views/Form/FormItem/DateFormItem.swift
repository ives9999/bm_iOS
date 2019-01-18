//
//  DateFormItem.swift
//  bm
//
//  Created by ives on 2019/1/17.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation
class DateFormItem: FormItem {
    
    var dateType: SELECT_DATE_TYPE?
    
    required init(name: String, title: String, dateType: SELECT_DATE_TYPE) {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        segue = TO_SELECT_DATE
        uiProperties.cellType = .date
        self.dateType = dateType
        reset()
    }
    
    override func reset() {
        super.reset()
        make()
    }
    
    override func make() {
        if value != nil {
            show = value!
            sender = ["type":dateType!,"date":value!]
        } else {
            sender = ["type":dateType!,"date":""]
        }
    }
}
