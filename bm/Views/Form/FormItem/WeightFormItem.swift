//
//  WeightFormItem.swift
//  bm
//
//  Created by ives on 2021/1/14.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class WeightFormItem: TagFormItem {
    
    required init(name: String = WEIGHT_KEY, title: String = "重量", isRequire: Bool = false, selected_idxs: [Int] = [0]) {
        super.init(name: name, title: title, isRequire: false)
        uiProperties.cellType = .weight
    }
    
}
