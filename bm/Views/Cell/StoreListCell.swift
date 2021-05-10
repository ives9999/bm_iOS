//
//  StoreListCell.swift
//  bm
//
//  Created by ives sun on 2021/4/21.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class StoreListCell: List2Cell {
    
    @IBOutlet weak var telLbl: SuperLabel!
    @IBOutlet weak var intervalLbl: SuperLabel!
    @IBOutlet weak var addressLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        telLbl.setTextGeneral()
        intervalLbl.setTextGeneral()
        addressLbl.setTextGeneral()
        
        let _icons = [likeIcon, mobileIcon, mapIcon]
        let _constraints = [likeConstraint, mobileConstraint, mapConstraint]
        for (idx,_icon) in _icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon!, "constraint": _constraints[idx]!, "constant": w])
        }
    }
    
    override func updateViews(_ _row: Table) {
        
        super.updateViews(_row)
        
        let row: StoreTable? = _row as? StoreTable ?? nil
        if row != nil {
            if row!.tel.count > 0 {
                telLbl.text = row!.tel_show
            } else {
                telLbl.text = "未提供"
            }

            if row!.interval_show.count > 0 {
                intervalLbl.text = row!.interval_show
            } else {
                intervalLbl.text = "未提供"
            }
            
            if row!.address.count > 0 {
                addressLbl.text = row!.address
            }
            
            if row!.address.isEmpty {
                hiddenIcon(mapIcon)
            }
        }
    }
}
