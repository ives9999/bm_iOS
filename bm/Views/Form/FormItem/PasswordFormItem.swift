//
//  PasswordFormItem.swift
//  bm
//
//  Created by ives on 2020/12/6.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class PasswordFormItem: FormItem {
    
    var re: Bool = false
    var passwordFormItem: PasswordFormItem? = nil
    
    required init(name: String, title: String, placeholder: String? = nil, value: String? = nil, re: Bool = false, passwordFormItem: PasswordFormItem? = nil, isRequire: Bool = false) {
        super.init(name: name, title: title, placeholder: placeholder, value: value, isRequired: isRequire)
        
        self.re = re
        if passwordFormItem != nil {
            self.passwordFormItem = passwordFormItem
        }
        uiProperties.cellType = .password
        reset()
    }
    
    override func checkValidity() {
        self.isValid = true
        if self.re {
            if self.isRequired {
                if value != nil && !value!.isEmpty {
                    if self.passwordFormItem != nil {
//                        print(self.passwordFormItem!.value)
//                        print(self.value)
                        if self.value != self.passwordFormItem!.value {
                            isValid = false
                            msg = "密碼不符合"
                        }
                    }
                } else {
                    isValid = false
                    msg = "\(title) 沒有填寫或選擇欄位值"
                }
            }
        } else {
            super.checkValidity()
        }
    }
    
//    override func reset() {
//        super.reset()
//        make()
//    }
//
//    override func make() {
//        if value != nil {
//            show = value!
//        } else {
//            show = ""
//        }
//    }
}
