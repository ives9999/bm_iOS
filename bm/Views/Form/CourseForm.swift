//
//  CourseForm.swift
//  bm
//
//  Created by ives on 2019/5/28.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

class CourseForm: BaseForm {
    
    override func configureItems() {
        
        let section1 = SectionFormItem(title: "一般")
        let titleItem = TextFieldFormItem(name: TITLE_KEY, title: "標題", placeholder: "請輸入標題")
        let youtubeItem = TextFieldFormItem(name: YOUTUBE_KEY, title: "youtube代碼", placeholder: "請輸入youtube影片代碼")
        let section2 = SectionFormItem(title: "收費")
        let priceItem = TextFieldFormItem(name: PRICE_KEY, title: "收費標準", placeholder: "請輸入收費費用")
        let priceCycleUnitItem = PriceUnitFormItem()
        let priceDescItem = TextFieldFormItem(name: PRICE_DESC_KEY, title: "補充說明", placeholder: "收費標準的補充說明")
        let section3 = SectionFormItem(title: "課程")
        let courseKindItem = CourseKindFormItem()
        let cycleUnitItem = CycleUnitFormItem()
        let weekdayFormItem = WeekdayFormItem()
        let startTimeFormItem = TimeFormItem(name: START_TIME_KEY, title: "開始時間", timeType: SELECT_TIME_TYPE.play_start, tooltip: "", isRequired: false)
        let endTimeFormItem = TimeFormItem(name: END_TIME_KEY, title: "結束時間", timeType: SELECT_TIME_TYPE.play_end, tooltip: "", isRequired: false)
        let contentFormItem = ContentFormItem(name: CONTENT_KEY, title: "詳細介紹", type: TEXT_INPUT_TYPE.content)

        formItems = [section1,titleItem,youtubeItem,section2,priceItem,priceCycleUnitItem,priceDescItem,section3,courseKindItem,cycleUnitItem,weekdayFormItem,startTimeFormItem,endTimeFormItem,contentFormItem]
    }
}
