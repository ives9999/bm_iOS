//
//  PlainFormItem.swift
//  bm
//
//  Created by ives on 2021/1/8.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class PlainFormItem: FormItem {
    
    required init(title: String) {
        super.init(name: "section", title: title, placeholder: nil, value: nil)
        uiProperties.cellType = .plain
    }
}
