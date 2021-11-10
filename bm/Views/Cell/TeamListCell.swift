//
//  TeamListCell.swift
//  bm
//
//  Created by ives on 2021/4/15.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class TeamListCell: List2Cell {
    
    @IBOutlet weak var weekendLbl: SuperLabel!
    @IBOutlet weak var intervalLbl: SuperLabel!
    @IBOutlet weak var temp_qnantityLbl: SuperLabel!
    @IBOutlet weak var signup_countLbl: SuperLabel!
    
    var _icons: [SuperButton] = [SuperButton]()
    var _constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        weekendLbl.setTextGeneral()
        intervalLbl.setTextGeneral()
        temp_qnantityLbl.setTextGeneral()
        signup_countLbl.setTextGeneral()
        
        _icons = [likeIcon, mobileIcon, mapIcon]
        _constraints = [likeConstraint, mobileConstraint, mapConstraint]
        for (idx,_icon) in _icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon, "constraint": _constraints[idx], "constant": w])
        }
    }
    
    func showIcon(_ icon: SuperButton) {
        
        var iconIdx: Int = 0
        for (idx, _icon) in _icons.enumerated() {
            if _icon == icon {
                iconIdx = idx
            }
        }
    }

    override func updateViews(_ _row: Table) {
        
        super.updateViews(_row)
        
        let row: TeamTable? = _row as? TeamTable ?? nil
        if row != nil {
            if (row!.arena != nil) {
                if row!.arena!.name.count > 0 {
                    arenaBtn.setTitle(row!.arena!.name)
                    cityBtn.setTitle(row!.arena!.city_show)
                    cityBtn.isHidden = false
                    arenaBtn.isHidden = false
                } else {
                    cityBtn.isHidden = true
                    arenaBtn.isHidden = true
                }
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
            
            temp_qnantityLbl.text = row!.temp_quantity_show
            signup_countLbl.text = row!.temp_signup_count_show
            
            if row!.mobile.isEmpty {
                hiddenIcon(mobileIcon)
                //mobileIcon.isHidden = true
            } else {
                mobileIcon.isHidden = false
            }
            
            let chevron = UIImage(named: "greater1")
            self.accessoryType = .disclosureIndicator
            self.accessoryView = UIImageView(image: chevron!)
        }
    }
    
}
