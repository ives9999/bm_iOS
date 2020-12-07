//
//  PrivacyFormItem.swift
//  bm
//
//  Created by ives on 2020/12/5.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class PrivacyFormItem: FormItem {
    
    required init(title: String = "隱私權", name: String = PRIVACY_KEY) {
        super.init(name: name, title: title, placeholder: nil, value: "1")
        uiProperties.cellType = .privacy
        reset()
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
