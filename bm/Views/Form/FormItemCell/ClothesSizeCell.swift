//
//  ClothesSizeCell.swift
//  bm
//
//  Created by ives on 2021/1/11.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class ClothesSizeCell: TagCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func update(with formItem: FormItem) {
        
        let _formItem: ClothesSizeFormItem = formItem as! ClothesSizeFormItem
        if _formItem.tags != nil {
            self.tagDicts = _formItem.tags!
            super.update(with: formItem)
        }
    }
}
