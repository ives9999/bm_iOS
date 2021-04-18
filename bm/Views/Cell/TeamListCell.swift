//
//  TeamListCell.swift
//  bm
//
//  Created by ives on 2021/4/15.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class TeamListCell: List2Cell {
    
    @IBOutlet weak var cityBtn: CityButton!
    @IBOutlet weak var areanBtn: CityButton!
    @IBOutlet weak var weekendLbl: SuperLabel!
    @IBOutlet weak var intervalLbl: SuperLabel!
    @IBOutlet weak var temp_qnantityLbl: SuperLabel!
    @IBOutlet weak var signup_countLbl: SuperLabel!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        let _icons = [mapIcon, mobileIcon, likeIcon]
        let _constraints = [mapConstraint, mobileConstraint, likeConstraint]
        for (idx,_icon) in _icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon!, "constraint": _constraints[idx]!, "constant": w])
        }
    }

    func updateViews(indexPath: IndexPath, row: TeamTable) {
        
        _updateViews(indexPath: indexPath, row: row.self)
        titleLbl.text = row.name
        cityBtn.setTitle(row.city_show)
        if row.arena != nil {
            areanBtn.setTitle(row.arena!.name)
        } else {
            areanBtn.isHidden = true
        }
        
        if row.weekdays_show.count > 0 {
            weekendLbl.text = row.weekdays_show
        } else {
            weekendLbl.text = "未提供"
        }
        
        if row.interval_show.count > 0 {
            intervalLbl.text = row.interval_show
        } else {
            intervalLbl.text = "未提供"
        }
        
        temp_qnantityLbl.text = row.temp_quantity_show
        signup_countLbl.text = row.temp_signup_count_show
        
        if row.mobile.isEmpty {
            hiddenIcon(mobileIcon)
        }
        
        refreshIcon.indexPath = indexPath
        cityBtn.indexPath = indexPath
        mapIcon.indexPath = indexPath
        mobileIcon.indexPath = indexPath
        likeIcon.indexPath = indexPath
    }
    
}
