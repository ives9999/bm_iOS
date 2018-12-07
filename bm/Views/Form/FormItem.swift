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
    var timeType: SELECT_TIME_TYPE?
    var segue: String?
    var show: String = ""
    
    //weekday is [Int]
    //time is ["type":timeType,"time":"09:00"]
    var sender: Any?
    
    var weekdays: [Int] = [Int]()
    var startTime: String = ""
    var endTime: String = ""
    var color: MYCOLOR?
    var status: STATUS?
    
    init(title: String, placeholder: String? = nil, value: String? = nil) {
        self.title = title
        if placeholder != nil {
            self.placeholder = placeholder!
        }
        self.value = value
    }
    
    func reset() {
        show = ""
        value = nil
        color = nil
        status = nil
        startTime = ""
        endTime = ""
        sender = nil
        weekdays = [Int]()
    }
    
    func checkValidity() {
        if self.isMandatory {
            self.isValid = self.value != nil && self.value?.isEmpty == false
        } else {
            self.isValid = true
        }
    }
}




















