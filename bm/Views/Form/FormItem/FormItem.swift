//
//  FormItem.swift
//  form
//
//  Created by ives on 2018/12/3.
//  Copyright © 2018 BlueMobile. All rights reserved.
//

import Foundation

class FormItem: FormValidable {
    
    var isValid = false
    var msg: String?
    var isRequired = true
    var title: String = ""
    var name: String?
    var oldValue: String?
    var value: String?
    var placeholder = ""
    var indexPath: IndexPath?
    var valueCompletion: ((String?) -> Void)?
    var uiProperties = FormItemUIProperties()
    var segue: String?
    var show: String = ""
    
    //weekday is [Int]
    //time is ["type":SELECT_TIME_TYPE,"time":"09:00"]
    //color is [MYCOLOR]
    //status is STATUS
    //content is ["type":TEXT_INPUT_TYPE,"text":"課程說明"]
    var sender: Any?
    
    init(name: String, title: String, placeholder: String? = nil, value: String? = nil) {
        self.title = title
        self.name = name
        if placeholder != nil {
            self.placeholder = placeholder!
        }
        self.value = value
    }
    
    func reset() {
        show = ""
        value = nil
        sender = nil
    }
    
    func make() {}
    func valueToAnother() {}
    
    func checkValidity() {
        if isRequired {
            if value == nil {
                isValid = false
                msg = "\(title) 沒有填寫或選擇欄位值"
                return
            }
            if value != nil && (value?.isEmpty)! {
                isValid = false
                msg = "\(title) 欄位值不能為空白"
                return
            }
//            if (value != nil && oldValue != nil) && (value == oldValue) {
//                isValid = false
//                msg = "\(title) 沒有更改欄位值"
//                return
//            }
            isValid = true
        } else {
            self.isValid = true
        }
    }
}




















