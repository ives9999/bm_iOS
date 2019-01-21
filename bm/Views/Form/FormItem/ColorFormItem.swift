//
//  ColorFormItem.swift
//  bm
//
//  Created by ives on 2018/12/9.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class ColorFormItem: FormItem {
    
    var oldColor: MYCOLOR?
    var color: MYCOLOR?
    
    required init(title: String = "顏色", name: String = TT_COLOR, tooltip: String?=nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip)
        segue = TO_SELECT_COLOR
        uiProperties.cellType = .color
        reset()
    }
    
    override func reset() {
        super.reset()
        color = nil
        make()
    }
    
    override func make() {
        if color != nil {
            value = color?.toString()
            sender = [color]
        } else {
            value = nil
            show = ""
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            color = MYCOLOR(color: value!)
        }
    }
}
