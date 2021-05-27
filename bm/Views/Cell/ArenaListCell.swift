//
//  ArenaListCell.swift
//  bm
//
//  Created by ives sun on 2021/4/21.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class ArenaListCell: List2Cell {
    
    @IBOutlet weak var telLbl: SuperLabel!
    @IBOutlet weak var parkingLbl: SuperLabel!
    @IBOutlet weak var intervalLbl: SuperLabel!
    @IBOutlet weak var air_conditionLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        telLbl.setTextGeneral()
        intervalLbl.setTextGeneral()
        parkingLbl.setTextGeneral()
        air_conditionLbl.setTextGeneral()
        
        let _icons = [likeIcon, mobileIcon, mapIcon]
        let _constraints = [likeConstraint, mobileConstraint, mapConstraint]
        for (idx,_icon) in _icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon!, "constraint": _constraints[idx]!, "constant": w])
        }
    }
    
    override func updateViews(_ _row: Table) {
        
        super.updateViews(_row)
        
        let row: ArenaTable? = _row as? ArenaTable ?? nil
        if row != nil {
            if row!.area_id > 0 {
                areaBtn.setTitle(row!.area_show)
            } else {
                areaBtn.isHidden = true
            }
            
            if row!.interval_show.count > 0 {
                intervalLbl.text = row!.interval_show
            } else {
                intervalLbl.text = "未提供"
            }
            
            if (row!.air_condition >= 0) {
                air_conditionLbl.text = "空調：\(row!.air_condition_show)"
            } else {
                air_conditionLbl.text = "未提供"
            }
            parkingLbl.text = "停車:\(row!.parking_show)"
        }
    }
    
}
