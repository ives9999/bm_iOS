//
//  CycleUnitFormItem.swift
//  bm
//
//  Created by ives on 2019/6/7.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation
class CycleUnitFormItem: FormItem {
    var oldCycleUnit: CYCLE_UNIT?
    var cycleUnit: CYCLE_UNIT?
    
    required init(name: String = CYCLE_UNIT_KEY, title: String = "週期", tooltip: String?=nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip)
        segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        cycleUnit = nil
        make()
    }
    
    override func make() {
        valueToAnother()
        if cycleUnit != nil {
            value = cycleUnit!.toString()
            show = cycleUnit!.rawValue
            sender = cycleUnit
        } else {
            value = nil
            show = ""
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            cycleUnit = CYCLE_UNIT.enumFromString(string: value!)
        }
    }
}
