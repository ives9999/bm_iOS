//
//  WeekdayCell.swift
//  bm
//
//  Created by ives on 2018/12/6.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class WeekdayCell: MoreCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl!.text = "星期幾"
    }
    
    override func update(with formItem: FormItem) {
        super.update(with: formItem)
        let _formItem = formItem as! WeekdayFormItem
        _formItem.make()
        if _formItem.weekdays.count > 0 {
            clearBtn.isHidden = false
        }
        detailLbl.text = _formItem.show
        self.formItem = _formItem
    }
    
    override func clear() {
        super.clear()
//        if formItem != nil {
//            formItem!.reset()
//            formItem!.sender = [Int]()
//        }
    }
}
