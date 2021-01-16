//
//  WeightCell.swift
//  bm
//
//  Created by ives on 2021/1/14.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class WeightCell: TagCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func update(with formItem: FormItem) {
        
        let _formItem: WeightFormItem = formItem as! WeightFormItem
        if _formItem.tags != nil {
            self.tagDicts = _formItem.tags!
            super.update(with: formItem)
        }
    }
}
