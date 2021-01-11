//
//  OrderForm.swift
//  bm
//
//  Created by ives on 2021/1/8.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrderForm: BaseForm {
    
    override func configureItems() {
        
        let section1 = SectionFormItem(title: "商品資料")
        let productItem = PlainFormItem(name: "Product_Name", title: "商品")
        
        let section2 = SectionFormItem(title: "個人資料")
        let colorItem = Color1FormItem(name: COLOR_KEY, title: "顏色", isRequire: true)
        let sizeItem = PasswordFormItem(name: PASSWORD_KEY, title: "密碼", placeholder: "請輸入密碼", isRequire: true)
        let countItem = PasswordFormItem(name: PASSWORD_KEY, title: "密碼", placeholder: "請輸入密碼", isRequire: true)

        let section3 = SectionFormItem(title: "寄件資料")
        let nameItem = PlainFormItem(name: NAME_KEY, title: "姓名")
        let mobileItem = PlainFormItem(name: MOBILE_KEY, title: "行動電話")
        let emailItem = PlainFormItem(name: EMAIL_KEY, title: "EMail")
        let addressItem = PlainFormItem(name: ADDRESS_KEY, title: "住址")

        formItems = [section1,productItem,
                     section2,colorItem,sizeItem,countItem,
                     section3,nameItem,mobileItem,emailItem,addressItem
        ]
    }
}
