//
//  OrderForm.swift
//  bm
//
//  Created by ives on 2021/1/8.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrderForm: BaseForm {
    
    var type: String = "clothes"
    
    override func configureItems() {
        
        let section1 = SectionFormItem(title: "商品名稱")
        let productItem = PlainFormItem(name: "Product_Name", title: "商品")
        formItems = [section1,productItem]
        
        let items: [FormItem] = setAttributesItem()
        formItems.append(contentsOf: items)

        let section3 = SectionFormItem(title: "款項")
        let subTotalItem = PlainFormItem(name: SUB_TOTAL_KEY, title: "小計", unit: "元")
        let shippingFeeItem = PlainFormItem(name: SHIPPING_FEE_KEY, title: "運費", unit: "元")
        let totalItem = PlainFormItem(name: TOTAL_KEY, title: "總計", unit: "元")
        
        let section4 = SectionFormItem(title: "寄件資料")
        let nameItem = PlainFormItem(name: NAME_KEY, title: "姓名")
        let mobileItem = PlainFormItem(name: MOBILE_KEY, title: "行動電話")
        let emailItem = PlainFormItem(name: EMAIL_KEY, title: "EMail")
        let addressItem = PlainFormItem(name: ADDRESS_KEY, title: "住址")

        formItems.append(contentsOf: [section3,subTotalItem,shippingFeeItem,totalItem,
                     section4,nameItem,mobileItem,emailItem,addressItem])
    }
    
    func setAttributesItem()-> [FormItem] {
        
        var formItems: [FormItem] = [FormItem]()
        let section2 = SectionFormItem(title: "商品選項")
        formItems.append(section2)
        if self.type == "clothes" {
            let colorItem = Color1FormItem(isRequire: true)
            let clothesSizeItem = ClothesSizeFormItem(isRequire: true)
            let numberItem = NumberFormItem(isRequire: true, max: 1)
            formItems.append(contentsOf: [colorItem, clothesSizeItem, numberItem])
            
        }
        
        return formItems
    }
}
