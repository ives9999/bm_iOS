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
        let priceCycleUnitItem = PriceCycleUnitFormItem()
        
        formItems = [section1,titleItem,youtubeItem,section2,priceItem,priceCycleUnitItem]
    }
}
