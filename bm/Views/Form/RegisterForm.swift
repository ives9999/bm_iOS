//
//  RegisterForm.swift
//  bm
//
//  Created by ives on 2020/12/4.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class RegisterForm: BaseForm {
    
    override func configureItems() {
        
        let section1 = SectionFormItem(title: "登入資料")
        let emailItem = TextFieldFormItem(name: EMAIL_KEY, title: "EMail", placeholder: "請輸入EMail", isRequire: true)
        let passwordItem = PasswordFormItem(name: PASSWORD_KEY, title: "密碼", placeholder: "請輸入密碼", isRequire: true)
        let repasswordItem = PasswordFormItem(name: REPASSWORD_KEY, title: "密碼確認", placeholder: "再次輸入密碼", re: true, passwordFormItem: passwordItem, isRequire: true)

        let section2 = SectionFormItem(title: "個人資料")
        let nameItem = TextFieldFormItem(name: NAME_KEY, title: "姓名", placeholder: "真實姓名，寄送物品時使用", isRequire: true)
        let nicknameItem = TextFieldFormItem(name: NICKNAME_KEY, title: "暱稱", placeholder: "網站上出現的名稱", isRequire: true)
        let dobItem = DateFormItem(name: DOB_KEY, title: "生日", dateType: .start)

        let section3 = SectionFormItem(title: "聯絡資料")
        let mobileItem = TextFieldFormItem(name: MOBILE_KEY, title: "行動電話", placeholder: "請輸入行動電話", keyboardType: .numberPad, isRequire: true)
        let telItem = TextFieldFormItem(name: TEL_KEY, title: "市內電話", placeholder: "請輸入市內電話", keyboardType: .numberPad)
        let cityItem = CityFormItem(isRequire: true)
        let areaItem = AreaFormItem(isRequire: true)
        let roadItem = TextFieldFormItem(name: ROAD_KEY, title: "住址", placeholder: "路街名、巷、弄、號", isRequire: true)

        let section4 = SectionFormItem(title: "社群資料")
        let fbItem = TextFieldFormItem(name: FB_KEY, title: "FB", placeholder: "請輸入FB網址")
        let lineItem = TextFieldFormItem(name: LINE_KEY, title: "Line", placeholder: "請輸入Line ID")

        let section5 = SectionFormItem(title: "隱私權")
        let privacyItem = PrivacyFormItem(delegate: self.delegate)

        formItems = [section1,emailItem,passwordItem,repasswordItem,
                     section2,nameItem,nicknameItem,dobItem,
                     section3,mobileItem,telItem,cityItem,areaItem,roadItem,
                     section4,fbItem,lineItem,
                     section5,privacyItem
        ]
    }
}
