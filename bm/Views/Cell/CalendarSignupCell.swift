//
//  CalendarSignupCell.swift
//  bm
//
//  Created by ives on 2019/11/17.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class CalendarSignupCell: SuperCell {
    
    @IBOutlet weak var dateTxt: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(date: String) {
        let d: Date = date.toDate()
        let weekday: String = d.dateToWeekdayForChinese()
        dateTxt.text = "\(date)(\(weekday))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
