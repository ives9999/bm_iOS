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
        if self.formItem?.color != nil {
            detailLbl.isHidden = false
            detailLbl.backgroundColor = self.formItem?.color?.toColor()
            self.formItem?.sender = self.formItem?.color
            clearBtn.isHidden = false
        }
    }
    
    override func clear() {
        super.clear()
        detailLbl.isHidden = true
        if formItem != nil {
            formItem!.reset()
        }
    }
    
}
