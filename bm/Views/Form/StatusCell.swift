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
        // Initialization code
    }

    override func update(with formItem: FormItem) {
        super.update(with: formItem)
        if self.formItem?.status != nil {
            self.formItem?.sender = self.formItem?.status
            self.formItem?.show = (self.formItem?.status?.rawValue)!
            clearBtn.isHidden = false
        }
        if self.formItem?.show != nil {
            detailLbl.text = self.formItem?.show
        }
    }
    
    override func clear() {
        super.clear()
        if formItem != nil {
            formItem!.reset()
        }
    }
    
}
