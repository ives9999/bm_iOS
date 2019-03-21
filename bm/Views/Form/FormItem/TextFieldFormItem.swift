//
//  TextFieldFormItem.swift
//  bm
//
//  Created by ives on 2018/12/10.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class TextFieldFormItem: FormItem {
    required init(name: String, title: String, placeholder: String? = nil, value: String? = nil, keyboardType: UIKeyboardType = .default, isRequire: Bool = true, tooltip: String?=nil) {
        
        super.init(name: name, title: title, placeholder: placeholder, value: value, tooltip: tooltip)
        self.isRequired = isRequired
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
            show = value!
        } else {
            show = ""
        }
    }
}