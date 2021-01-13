//
//  NumberFormItem.swift
//  bm
//
//  Created by ives on 2021/1/12.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class NumberFormItem: FormItem {
    
    var min: Int = 0
    var max: Int = 5
    
    required init(name: String = NUMBER_KEY, title: String = "數量", isRequire: Bool = false, min: Int = 1, max: Int = 5) {
        super.init(name: name, title: title, placeholder: nil, value: nil, isRequired: isRequire)
        //segue = TO_SINGLE_SELECT
        uiProperties.cellType = .number
        self.isRequired = isRequire
        self.min = min
        self.max = max
        
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        make()
    }
    
    override func make() {
        
        valueToAnother()
    }
    
    //parse value to array
    override func valueToAnother() {
        if value != nil && value!.count > 0 {
            
        }
    }
}
