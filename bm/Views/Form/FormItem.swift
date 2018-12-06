//
//  FormItem.swift
//  form
//
//  Created by ives on 2018/12/3.
//  Copyright © 2018 BlueMobile. All rights reserved.
//

import Foundation

class FormItem: FormValidable {
    var isValid = true
    var isMandatory = true
    var title: String = ""
    var value: String?
    var placeholder = ""
    var indexPath: IndexPath?
    var valueCompletion: ((String?) -> Void)?
    var uiProperties = FormItemUIProperties()
    var segue: String?
    var weekdays: [Int] = [Int]()
    var show: String = ""
    var sender: Any?
    
    init(title: String, placeholder: String? = nil, value: String? = nil) {
        self.title = title
        if placeholder != nil {
            self.placeholder = placeholder!
        }
        self.value = value
    }
    
    func checkValidity() {
        if self.isMandatory {
            self.isValid = self.value != nil && self.value?.isEmpty == false
        } else {
            self.isValid = true
        }
    }
}




















