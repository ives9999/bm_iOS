//
//  ManagersFormItem.swift
//  bm
//
//  Created by ives on 2020/11/28.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class ManagersFormItem: FormItem {
        
    required init(name: String = MANAGERS_KEY, title: String = "管理者") {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        uiProperties.cellType = .more
        reset()
    }
    
    override func reset() {
        super.reset()
        make()
    }
    
    override func make() {
        if value != nil {
            show = value!.truncate(length: 100, trailing: "...")
            sender = value
            //sender = ["type":contentType!,"text":value!]
        } else {
            sender = ""
            //sender = ["type":contentType!,"text":""]
        }
    }
}
