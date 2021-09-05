//
//  TeachCell.swift
//  bm
//
//  Created by ives on 2021/3/18.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class TeachListCell: List2Cell {

    @IBOutlet weak var pvLbl: SuperLabel!
    @IBOutlet weak var dateLbl: SuperLabel!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    @IBOutlet weak var featuredHConstraint: NSLayoutConstraint!
    @IBOutlet weak var featuredWConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.setTextTitle()
        pvLbl.setTextGeneral()
        dateLbl.setTextGeneral()
        
        let _icons = [likeIcon]
        let _constraints = [likeConstraint]
        for (idx,_icon) in _icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon!, "constraint": _constraints[idx]!, "constant": w])
        }
    }
    
    override func updateViews(_ _row: Table) {
        
        super.updateViews(_row)
        
        let row: TeachTable? = _row as? TeachTable ?? nil
        if (row != nil) {
            //titleLbl.text = data.title
            
    //        let w: CGFloat = frame.width
    //        let h: CGFloat = (w/16)*9
    //        featuredWConstraint.constant = w
    //        featuredHConstraint.constant = h
//            if row.featured_path.count > 0 {
//                featuredImageView.downloaded(from: data.featured_path)
//            }
            pvLbl.text = String(row!.pv)
            dateLbl.text = row!.created_at_show
        }
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
}
