//
//  FormBaseClass.swift
//  form
//
//  Created by ives on 2018/12/3.
//  Copyright © 2018 BlueMobile. All rights reserved.
//

import Foundation

class BaseForm {
    var formItems = [FormItem]()
    var title: String?
    var values: [String: String]?
    var id: Int?
    var isChange: Bool = false
    
    init(id: Int? = nil, values: [String: String]? = nil, title: String = "") {
        self.id = id
        self.values = values
        self.title = title
        self.configureItems()
        self.fillValue()
    }
    
    @discardableResult
    func isValid() ->(Bool, String?) {
        var isValid = true
        var msg: String?
        for item in formItems {
            item.checkValidity()
            if !item.isValid {
                isValid = false
                msg = item.msg
                break
            }
            if (!isChange) {
                isChange = item.updateCheckChange()
            }
        }
        if (isValid && !isChange) {
            isValid = false
            msg = "沒有更改任何值，所以不用送出更新"
        }
        
        return (isValid, msg)
    }
    
    func configureItems() {}
    func fillValue() {
        for formItem in formItems {
            if formItem.name != nil && values?[formItem.name!] != nil {
                formItem.value = values?[formItem.name!]
                formItem.oldValue = formItem.value
                formItem.valueToAnother()
                formItem.make()
            }
        }
    }
}

























