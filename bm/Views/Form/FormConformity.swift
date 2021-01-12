//
//  FormConformity.swift
//  form
//
//  Created by ives on 2018/12/3.
//  Copyright © 2018 BlueMobile. All rights reserved.
//

import Foundation

protocol FormUPdatable {
    func update(with formItem: FormItem)
}

protocol FormConformity {
    var formItem: FormItem? {get set}
}

protocol ValueChangedDelegate {
    func textFieldTextChanged(formItem: FormItem, text: String)
    func sexChanged(sex: String)
    func privacyChecked(checked: Bool)
    func tagChecked(checked: Bool, name: String, key: String, value: String)
    func stepperValueChanged(number: Int, name: String)
}
