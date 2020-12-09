//
//  SexFormItem.swift
//  bm
//
//  Created by ives on 2020/12/9.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SexFormItem: FormItem {
    
    required init(name: String = SEX_KEY, title: String = "性別", tooltip: String?=nil, isRequired: Bool = false) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip, isRequired: isRequired)
        uiProperties.cellType = .sex
        reset()
        self.value = "M"
    }
}
