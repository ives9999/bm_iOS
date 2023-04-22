//
//  MemberRow.swift
//  bm
//
//  Created by ives on 2021/11/7.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import UIKit

class IconTextSection {
    
    var title: String = ""
    var isExpanded: Bool = true
    var items: [IconTextRow] = [IconTextRow]()
    
    init(title: String = "", isExpanded: Bool = true, items: [IconTextRow] = [IconTextRow]()) {
        self.title = title
        self.isExpanded = isExpanded
        self.items = items
    }
}

class IconTextRow {
    
    var title: String = ""
    var icon: String = ""
    var show: String = ""
    var segue: String = ""
    var able_type: String = ""
    
    var validate_type: String = ""
    var color: UIColor = UIColor(MY_WHITE)
    var showGreater: Bool = true
    
    init(
        title: String = "",
        icon: String = "",
        show: String = "",
        segue: String = "",
        able_type: String = ""
    ) {
        
        self.title = title
        self.icon = icon
        self.show = show
        self.segue = segue
        self.able_type = able_type
    }
}
