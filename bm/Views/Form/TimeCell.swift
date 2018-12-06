//
//  TimeCell.swift
//  bm
//
//  Created by ives on 2018/12/6.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class TimeCell: MoreCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func update(with formItem: FormItem) {
        super.update(with: formItem)
        if self.formItem?.value != nil {
            if self.formItem!.value!.count > 0 {
                clearBtn.isHidden = false
            }
        }
    }
    
    override func clear() {
        super.clear()
        if formItem != nil {
            formItem!.reset()
            formItem!.sender = ["type":formItem!.timeType!,"time":""]
        }
    }
    
}
