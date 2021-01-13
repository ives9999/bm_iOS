//
//  PlainFormItem.swift
//  bm
//
//  Created by ives on 2021/1/8.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class PlainFormItem: FormItem {
    
    var unit: String! = nil
    
    required init(name: String, title: String, unit: String? = nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        uiProperties.cellType = .plain
        self.unit = unit
    }
    
    override func make() {
        if value != nil {
            show = value!
        } else {
            show = ""
        }
        if unit != nil {
            show = show + " " + unit
        }
    }
}
