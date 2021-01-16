//
//  ClothesSizeFormItem.swift
//  bm
//
//  Created by ives on 2021/1/11.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ClothesSizeFormItem: TagFormItem {
    
    required init(name: String = CLOTHES_SIZE_KEY, title: String = "尺寸", isRequire: Bool = false, selected_idxs: [Int] = [0]) {
        super.init(name: name, title: title, isRequire: false)
        uiProperties.cellType = .clothesSize
    }
    
}
