//
//  TextFieldFormItem.swift
//  bm
//
//  Created by ives on 2018/12/10.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class TextFieldFormItem: FormItem {
    required init(name: String, title: String, placeholder: String? = nil, value: String? = nil, keyboardType: UIKeyboardType = .default, isRequire: Bool = false, tooltip: String?=nil) {
        
        super.init(name: name, title: title, placeholder: placeholder, value: value, tooltip: tooltip, isRequired: isRequire)
        uiProperties.keyboardType = keyboardType
        uiProperties.cellType = .textField
        reset()
    }
    
    override func reset() {
        super.reset()
        make()
    }
    
    override func make() {
        if value != nil {
            //如果資料庫的值是null，Int值，Table會轉為-1，但前端欄位必須是無值
            if let tmp: Int = Int(value!) {
                if (tmp < 0) {
                    value = ""
                    show = ""
                }
            } else {
                show = value!
            }
        } else {
            show = ""
        }
    }
}
