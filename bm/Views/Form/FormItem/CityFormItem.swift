//
//  CityFormItem.swift
//  bm
//
//  Created by ives on 2020/11/22.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class CityFormItem: FormItem {
    
    var city_id = 0
    
    required init(name: String = CITY_KEY, title: String = "縣市") {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        make()
    }
    
    override func make() {
        valueToAnother()
        if city_id != 0 {
            value = String(city_id)
            show = value!
            sender = city_id
        } else {
            value = nil
            show = ""
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            city_id = 0
        }
    }
    
}
