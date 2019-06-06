//
//  PriceCycleUnitFormItem.swift
//  bm
//
//  Created by ives on 2019/5/31.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

class PriceUnitFormItem: FormItem {
    var oldPriceUnit: PRICE_UNIT?
    var priceUnit: PRICE_UNIT?
    
    required init(name: String = PRICE_UNIT_KEY, title: String = "收費週期", tooltip: String?=nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip)
        segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        priceUnit = nil
        make()
    }
    
    override func make() {
        valueToAnother()
        if priceUnit != nil {
            value = priceUnit!.toString()
            show = priceUnit!.rawValue
            sender = priceUnit
        } else {
            value = nil
            show = ""
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            priceUnit = PRICE_UNIT.enumFromString(string: value!)
        }
    }
}
