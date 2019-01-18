//
//  DateCell.swift
//  bm
//
//  Created by ives on 2019/1/17.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class DateCell: MoreCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func update(with formItem: FormItem) {
        super.update(with: formItem)
        let _formItem = formItem as! DateFormItem
        _formItem.make()
        if _formItem.value != nil {
            clearBtn.isHidden = false
        }
        detailLbl.text = _formItem.show
        self.formItem = _formItem
    }
    
    override func clear() {
        super.clear()
        if formItem != nil {
            let _formItem = formItem as! DateFormItem
            _formItem.reset()
            self.formItem = _formItem
        }
    }
    
}
