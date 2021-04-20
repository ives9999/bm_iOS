//
//  CourseListCell.swift
//  bm
//
//  Created by ives on 2021/4/17.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class CourseListCell: List2Cell {
    
    @IBOutlet weak var priceLbl: SuperLabel!
    @IBOutlet weak var weekendLbl: SuperLabel!
    @IBOutlet weak var intervalLbl: SuperLabel!
    @IBOutlet weak var people_limitLbl: SuperLabel!
    @IBOutlet weak var signup_countLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func updateViews(_ _row: Table) {
        
        super.updateViews(_row)
        
        let row: CourseTable? = _row as? CourseTable ?? nil
        if row != nil {
            if row!.price_text_short.count > 0 {
                priceLbl.text = row!.price_text_short
            } else {
                priceLbl.text = "未提供"
            }
            
            if row!.weekdays_show.count > 0 {
                weekendLbl.text = row!.weekdays_show
            } else {
                weekendLbl.text = "未提供"
            }

            if row!.interval_show.count > 0 {
                intervalLbl.text = row!.interval_show
            } else {
                intervalLbl.text = "未提供"
            }

            if row!.people_limit > 0 {
                people_limitLbl.text = "可報名：\(row!.people_limit_show)"
            } else {
                people_limitLbl.text = row!.people_limit_show
            }
            
            if row!.people_limit > 0 {
                signup_countLbl.text = "已報名：\(row!.signup_count_show)"
            } else {
                signup_countLbl.isHidden = true
            }

            if row!.coachTable != nil {
                if row!.coachTable!.mobile.isEmpty {
                    hiddenIcon(mobileIcon)
                }
            } else {
                hiddenIcon(mobileIcon)
            }
        }
    }
}
