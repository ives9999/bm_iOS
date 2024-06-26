//
//  CoachListCell.swift
//  bm
//
//  Created by ives on 2021/4/20.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class CoachListCell: List2Cell {
    
    @IBOutlet weak var mobileLbl: SuperLabel!
    @IBOutlet weak var seniorityLbl: SuperLabel!
    @IBOutlet weak var lineLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mobileLbl.setTextGeneral()
        seniorityLbl.setTextGeneral()
        lineLbl.setTextGeneral()
        
        let _icons = [likeIcon, mobileIcon]
        let _constraints = [likeConstraint, mobileConstraint]
        for (idx,_icon) in _icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon!, "constraint": _constraints[idx]!, "constant": w])
        }
    }
    
    override func updateViews(_ _row: Table) {
        
        super.updateViews(_row)
        
        let row: CoachTable? = _row as? CoachTable ?? nil
        if row != nil {
            if row!.mobile.count > 0 {
                mobileLbl.text = row!.mobile_show
            } else {
                mobileLbl.text = "未提供"
            }
            
            if row!.seniority >= 0 {
                seniorityLbl.text = "年資:\(row!.seniority_show)"
            } else {
                seniorityLbl.text = "年資:未提供"
            }

            if row!.line.count > 0 {
                lineLbl.text = "Line ID:\(row!.line)"
            } else {
                lineLbl.text = "Line ID:未提供"
            }
            let chevron = UIImage(named: "greater1")
            self.accessoryType = .disclosureIndicator
            self.accessoryView = UIImageView(image: chevron!)
        }
    }
}
