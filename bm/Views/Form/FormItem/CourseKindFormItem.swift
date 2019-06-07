//
//  CourseKindFormItem.swift
//  bm
//
//  Created by ives on 2019/6/7.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

class CourseKindFormItem: FormItem {
    var oldCourseKind: COURSE_KIND?
    var courseKind: COURSE_KIND?
    
    required init(name: String = COURSE_KIND_KEY, title: String = "課程週期", tooltip: String?=nil) {
        super.init(name: name, title: title, placeholder: nil, value: nil, tooltip: tooltip)
        segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        courseKind = nil
        make()
    }
    
    override func make() {
        valueToAnother()
        if courseKind != nil {
            value = courseKind!.toString()
            show = courseKind!.rawValue
            sender = courseKind
        } else {
            value = nil
            show = ""
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil {
            courseKind = COURSE_KIND.enumFromString(string: value!)
        }
    }
}
