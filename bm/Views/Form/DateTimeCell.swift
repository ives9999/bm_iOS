//
//  DateTimeCell.swift
//  bm
//
//  Created by ives on 2018/12/5.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class DateTimeCell: SuperCell {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var dateTime: UIDatePicker!
    var formItem: FormItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}

extension DateTimeCell: FormUPdatable {
    
    func update(with formItem: FormItem) {
        self.formItem = formItem
        
        self.titleLbl.text = self.formItem?.title
    }
}
