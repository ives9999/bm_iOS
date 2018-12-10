//
//  StatusCell.swift
//  bm
//
//  Created by ives on 2018/12/7.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class StatusCell: MoreCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.formItem = self.formItem as! StatusFormItem
    }

    override func update(with formItem: FormItem) {
        super.update(with: formItem)
        let _formItem = formItem as! StatusFormItem
        _formItem.make()
        if _formItem.status != nil {
            clearBtn.isHidden = false
        }
        detailLbl.text = _formItem.show
        self.formItem = _formItem
    }
    
    override func clear() {
        super.clear()
        if formItem != nil {
            let _formItem = formItem as! StatusFormItem
            _formItem.status = nil
            _formItem.make()
            self.formItem = _formItem
        }
    }
    
}
