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
    
    init() {
        self.configureItems()
        self.title = "Amazing form"
    }
    
    @discardableResult
    func isValid() ->(Bool, String?) {
        var isValid = true
        for item in formItems {
            item.checkValidity()
            if !item.isValid {
                isValid = false
            }
        }
        return (isValid, nil)
    }
    
    func configureItems() {}
}

























