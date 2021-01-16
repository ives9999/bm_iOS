//
//  Color1FormItem.swift
//  bm
//
//  Created by ives on 2021/1/9.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class Color1FormItem: TagFormItem {
    
    required init(name: String = COLOR_KEY, title: String = "顏色", isRequire: Bool = false, selected_idxs: [Int] = [0]) {
        super.init(name: name, title: title, isRequire: false)
        uiProperties.cellType = .color1
    }
    
}
