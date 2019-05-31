//
//  PriceCycleUnitFormItem.swift
//  bm
//
//  Created by ives on 2019/5/31.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

class PriceCycleUnitFormItem: FormItem {
    var oldPriceCycleUnit: PRICE_CYCLE_UNIT?
    var priceCycleUnit: PRICE_CYCLE_UNIT?
    
    required init(name: String = PRICE_CYCLE_UNIT_KEY, title: String = "收費週期", tooltip: String?=nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip)
        segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        priceCycleUnit = nil
        make()
    }
    
    override func make() {
        valueToAnother()
        if priceCycleUnit != nil {
            value = priceCycleUnit!.toString()
            show = priceCycleUnit!.rawValue
            sender = priceCycleUnit
        } else {
            value = nil
            show = ""
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            priceCycleUnit = PRICE_CYCLE_UNIT.enumFromString(string: value!)
        }
    }
}
