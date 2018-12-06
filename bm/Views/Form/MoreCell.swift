//
//  MoreCell.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class MoreCell: SuperCell, FormUPdatable {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var detailLbl: SuperLabel!
    @IBOutlet weak var clearBtn: SubmitButton!
    var formItem: FormItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.textAlignment = NSTextAlignment.left
        detailLbl.textAlignment = NSTextAlignment.right
        detailLbl.text = ""
        clearBtn.isHidden = true
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        clear()
    }
    
    func clear() {
        clearBtn.isHidden = true
        detailLbl.text = ""
    }
    
    func update(with formItem: FormItem) {
        self.formItem = formItem
        
        //titleLbl.text = self.formItem?.title
        detailLbl.text = self.formItem?.show
    }
}
