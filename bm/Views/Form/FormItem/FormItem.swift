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
    var isRequired = false
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
    var tooltip: String?
    var delegate: BaseViewController?
    
    //weekday is [Int]
    //time is ["type":SELECT_TIME_TYPE,"time":"09:00"]
    //color is [MYCOLOR]
    //status is STATUS
    //content is ["type":TEXT_INPUT_TYPE,"text":"課程說明"]
    var sender: Any?
    
    init(name: String, title: String, placeholder: String? = nil, value: String? = nil, tooltip: String?=nil, isRequired: Bool = false, delegate: BaseViewController? = nil) {
        
        self.title = title
        self.name = name
        self.isRequired = isRequired
        if placeholder != nil {
            self.placeholder = placeholder!
        }
        if tooltip != nil {
            self.tooltip = tooltip
        }
        if delegate != nil {
            self.delegate = delegate
        }
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
    
    func updateCheckChange()-> Bool {
        if ((value != nil && oldValue != nil) && (value == oldValue)) {
            isValid = false
            msg = "${title} 沒有更改欄位值"
            return false
        }
        return true
    }
}




















