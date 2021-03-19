//
//  TeachCell.swift
//  bm
//
//  Created by ives on 2021/3/18.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class TeachCell: SuperCell {

    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var pvLbl: SuperLabel!
    @IBOutlet weak var dateLbl: SuperLabel!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    @IBOutlet weak var featuredHConstraint: NSLayoutConstraint!
    @IBOutlet weak var featuredWConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        titleLbl.setTextSize(24)
    }
    
    func updateTeachViews(indexPath: IndexPath, data: TeachTable) {
        
        titleLbl.text = data.title
        
        let w: CGFloat = frame.width
        let h: CGFloat = (w/16)*9
        featuredWConstraint.constant = w
        featuredHConstraint.constant = h
        if data.featured_path.count > 0 {
            featuredImageView.downloaded(from: data.featured_path)
        }
        pvLbl.text = String(data.pv)
        dateLbl.text = data.created_at_show
        
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
}
