//
//  SearchRow.swift
//  bm
//
//  Created by ives on 2021/10/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class SearchSection {
    
    var title: String = ""
    var isExpanded: Bool = true
    var items: [SearchRow] = [SearchRow]()
    
    init(title: String = "", isExpanded: Bool = true, items: [SearchRow] = [SearchRow]()) {
        self.title = title
        self.isExpanded = isExpanded
        self.items = items
    }
}

class SearchRow {
    
    var title: String = ""
    var value: String = ""
    var show: String = ""
    var key: String = ""
    var cell: String = ""
    var keyboard: UIKeyboardType = .default
    var placeholder: String = ""
    var accessory: UITableViewCell.AccessoryType = UITableViewCell.AccessoryType.none
    
    init(
        title: String = "",
        value: String = "",
        show: String = "",
        key: String = "",
        cell: String = "",
        keyboard: UIKeyboardType = .default,
        placeholder: String = "",
        accessory: UITableViewCell.AccessoryType = UITableViewCell.AccessoryType.none
    ) {
        
        self.title = title
        self.value = value
        self.show = show
        self.key = key
        self.cell = cell
        self.keyboard = keyboard
        self.placeholder = placeholder
        self.accessory = accessory
    }
}
