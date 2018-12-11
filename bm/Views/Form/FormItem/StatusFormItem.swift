//
//  StatusFormItem.swift
//  bm
//
//  Created by ives on 2018/12/9.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class StatusFormItem: FormItem {
    var oldStatus: STATUS?
    var status: STATUS?
    
    required init(title: String = "狀態", name: String = TT_STATUS) {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        segue = TO_SELECT_STATUS
        uiProperties.cellType = .status
        reset()
    }
    
    override func reset() {
        super.reset()
        status = STATUS.online
        make()
    }
    
    override func make() {
        if status != nil {
            show = (status?.rawValue)!
            value = status?.toString()
            sender = status
        } else {
            show = ""
            value = nil
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            status = STATUS(status: value!)
        }
    }
}
