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
    var isRequired = true
    var title: String = ""
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
    
    var timeType: SELECT_TIME_TYPE?
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
        if self.isRequired {
            self.isValid = self.value != nil && self.value?.isEmpty == false
        } else {
            self.isValid = true
        }
    }
}




















