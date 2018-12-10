//
//  ColorCell.swift
//  bm
//
//  Created by ives on 2018/12/6.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class ColorCell: MoreCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        detailLbl.isHidden = true
    }

    override func update(with formItem: FormItem) {
        super.update(with: formItem)
        //print("color=>\(formItem.color)")
        let _formItem = formItem as! ColorFormItem
        _formItem.make()
        if _formItem.color != nil {
            detailLbl.isHidden = false
            detailLbl.backgroundColor = _formItem.color?.toColor()
            clearBtn.isHidden = false
        }
        detailLbl.text = _formItem.show
        self.formItem = _formItem
    }
    
    override func clear() {
        super.clear()
        detailLbl.isHidden = true
        if formItem != nil {
            let _formItem = formItem as! ColorFormItem
            _formItem.reset()
            self.formItem = _formItem
        }
    }
    
}
