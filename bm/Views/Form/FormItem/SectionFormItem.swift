//
//  SectionFormItem.swift
//  bm
//
//  Created by ives on 2019/5/31.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

class SectionFormItem: FormItem {
    
    required init(title: String) {
        super.init(name: "section", title: title, placeholder: nil, value: nil)
        uiProperties.cellType = .section
    }
}
