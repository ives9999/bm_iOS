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
    var thousand_mark: Bool = false
    
    required init(name: String, title: String, unit: String? = nil, thousand_mark: Bool = false) {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        uiProperties.cellType = .plain
        self.unit = unit
        self.thousand_mark = thousand_mark
    }
    
    override func make() {
        if value != nil {
            
            if thousand_mark {
                
                let m: Int = Int(value!) ?? 0
                show = m.formattedWithSeparator
            } else {
                show = value!
            }
            
        } else {
            show = ""
        }
        if unit != nil {
            show = show + " " + unit
        }
    }
}
