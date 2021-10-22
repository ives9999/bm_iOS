//
//  OneRow.swift
//  bm
//
//  Created by ives on 2021/10/21.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OneSection {
    var title: String = ""
    var key: String = ""
    var isExpanded: Bool = true
    var items: [OneRow] = [OneRow]()
    
    init(title: String = "", key: String, isExpanded: Bool = true, items: [OneRow] = [OneRow]()) {
        self.title = title
        self.key = key
        self.isExpanded = isExpanded
        self.items = items
    }
}

class OneRow {
    
    var title: String = ""
    var value: String = ""
    var show: String = ""
    var key: String = ""
    var cell: String = ""
    var keyboard: KEYBOARD = .default
    var placeholder: String = ""
    var prompt: String = ""
    var isRequired: Bool = true
    var isClear: Bool = true
    var accessory: UITableViewCell.AccessoryType = UITableViewCell.AccessoryType.none
    
    var featured_path: String = ""
    var attribute: String = ""
    var amount: String = ""
    var quantity: String = ""
    var msg: String = ""
    
    init(
        title: String = "",
        value: String = "",
        show: String = "",
        key: String = "",
        cell: String = "",
        keyboard: KEYBOARD = .default,
        placeholder: String = "",
        isRequired: Bool = true,
        isClear: Bool = true,
        accessory: UITableViewCell.AccessoryType = UITableViewCell.AccessoryType.none
    ) {
        
        self.title = title
        self.value = value
        self.show = show
        self.key = key
        self.cell = cell
        self.keyboard = keyboard
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.isClear = isClear
        self.accessory = accessory
    }
}
