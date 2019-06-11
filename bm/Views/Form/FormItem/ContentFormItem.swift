//
//  ContentFormItem.swift
//  bm
//
//  Created by ives on 2018/12/10.
//  Copyright © 2018 bm. All rights reserved.
//

import Foundation

class ContentFormItem: FormItem {
    
    var contentType: TEXT_INPUT_TYPE?
    
    required init(name: String, title: String, type: TEXT_INPUT_TYPE, isRequired: Bool = false) {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        self.contentType = type
        self.isRequired = isRequired
        segue = TO_CONTENT_EDIT
        uiProperties.cellType = .content
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
