//
//  Color1Cell.swift
//  bm
//
//  Created by ives on 2021/1/9.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class Color1Cell: TagCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func update(with formItem: FormItem) {
        
        let _formItem: Color1FormItem = formItem as! Color1FormItem
        if _formItem.tags != nil {
            self.tagDicts = _formItem.tags!
            super.update(with: formItem)
        }
    }
}
