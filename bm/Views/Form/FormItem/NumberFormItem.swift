//
//  NumberFormItem.swift
//  bm
//
//  Created by ives on 2021/1/12.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class NumberFormItem: FormItem {
    
    required init(name: String = NUMBER_KEY, title: String = "數量", isRequire: Bool = false) {
        super.init(name: name, title: title, placeholder: nil, value: nil, isRequired: isRequire)
        //segue = TO_SINGLE_SELECT
        uiProperties.cellType = .number
        self.isRequired = isRequire
        
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
