//
//  MoreCell.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class MoreCell: SuperCell {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var detailLbl: SuperLabel!
    @IBOutlet weak var clearBtn: SubmitButton!
    var formItem: FormItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailLbl.textAlignment = NSTextAlignment.right
        detailLbl.text = ""
        clearBtn.isHidden = true
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        print("clear")
    }
}

extension MoreCell: FormUPdatable {
    
    func update(with formItem: FormItem) {
        self.formItem = formItem
        
        titleLbl.text = self.formItem?.title
        detailLbl.text = self.formItem?.show
        self.formItem?.sender = self.formItem?.weekdays
        if (self.formItem?.weekdays.count)! > 0 {
            clearBtn.isHidden = false
        }
    }
}
