//
//  SexFormItem.swift
//  bm
//
//  Created by ives on 2020/12/9.
//  Copyright © 2020 bm. All rights reserved.
///Users/ives/iOS/bm/bm/Views/Form/FormItemCell/SexCell.swift

import Foundation

class SexFormItem: FormItem {
    
    required init(name: String = SEX_KEY, title: String = "性別", tooltip: String? = nil, isRequired: Bool = false, delegate: BaseViewController? = nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip, isRequired: isRequired, delegate: delegate)
        uiProperties.cellType = .sex
        reset()
        self.value = "M"
    }
}
