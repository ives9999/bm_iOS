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
        
        var newIcons: [SuperButton] = [SuperButton]()
        for tmp in icons {
            newIcons.append(tmp["icon"] as! SuperButton)
        }
        newIcons.insert(icon, at: iconIdx)
        
        icons.removeAll()
        icons = [[String: Any]]()
        for (idx,_icon) in newIcons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon, "constraint": _constraints[idx], "constant": w])
        }
        
        for (idx, _) in icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons[idx]["constant"] = w
            let constraint: NSLayoutConstraint = icons[idx]["constraint"] as! NSLayoutConstraint
            constraint.constant = w
        }
        icon.visibility = .visible
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
            
            temp_qnantityLbl.text = row!.people_limit_show
            signup_countLbl.text = row!.temp_signup_count_show
            
            if row!.mobile.isEmpty && mobileIcon.visibility == .visible {
                hiddenIcon(mobileIcon)
            } else {
                if mobileIcon.visibility == .gone {
                    showIcon(mobileIcon)
                }
            }
            
            let chevron = UIImage(named: "greater1")
            self.accessoryType = .disclosureIndicator
            self.accessoryView = UIImageView(image: chevron!)
        }
    }
}
