//
//  StoreForm.swift
//  bm
//
//  Created by ives on 2020/11/22.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class StoreForm: BaseForm {
    
    override func configureItems() {
        
        let section1 = SectionFormItem(title: "一般")
        let nameItem = TextFieldFormItem(name: TITLE_KEY, title: "名稱", placeholder: "請輸入名稱")
        
        let section2 = SectionFormItem(title: "聯絡")
        let telItem = TextFieldFormItem(name: TEL_KEY, title: "市內電話", placeholder: "請輸入市內電話")
        let mobileItem = TextFieldFormItem(name: MOBILE_KEY, title: "行動電話", placeholder: "請輸入行動電話")
        let emailItem = TextFieldFormItem(name: EMAIL_KEY, title: "EMail", placeholder: "請輸入EMail")
        let weblItem = TextFieldFormItem(name: WEBSITE_KEY, title: "網站或部落格", placeholder: "請輸入網站或部落格網址")
        let fbItem = TextFieldFormItem(name: FB_KEY, title: "FB", placeholder: "請輸入FB網址")
        let lineItem = TextFieldFormItem(name: LINE_KEY, title: "Line", placeholder: "請輸入Line ID")
        
        let section3 = SectionFormItem(title: "住址")
        let cityItem = CityFormItem()
        let areaItem = AreaFormItem()
        let addressItem = TextFieldFormItem(name: ADDRESS_KEY, title: "住址", placeholder: "路街名、巷、弄、號")
        let openTimeFormItem = TimeFormItem(name: OPEN_TIME_KEY, title: "開始時間", timeType: SELECT_TIME_TYPE.play_start, tooltip: "", isRequired: false)
        let closeTimeFormItem = TimeFormItem(name: CLOSE_TIME_KEY, title: "結束時間", timeType: SELECT_TIME_TYPE.play_end, tooltip: "", isRequired: false)
        
        let section4 = SectionFormItem(title: "管理者")
        let managersItem = ManagersFormItem()
        
        let contentFormItem = ContentFormItem(name: CONTENT_KEY, title: "詳細介紹", type: TEXT_INPUT_TYPE.content)

        formItems = [section1,managersItem,nameItem,
                     section2,telItem,mobileItem,emailItem,weblItem,fbItem,lineItem,
                     section3,cityItem,areaItem,addressItem, openTimeFormItem,closeTimeFormItem,
                     section4,contentFormItem]
    }
}
