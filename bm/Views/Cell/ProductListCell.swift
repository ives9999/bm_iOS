//
//  ProductListCell.swift
//  bm
//
//  Created by ives sun on 2021/4/21.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class ProductListCell: List2Cell {
    
    @IBOutlet weak var priceLbl: SuperLabel!
    @IBOutlet weak var buyBtn: SuperButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLbl.highlight()
        
//        let _icons = [likeIcon]
//        let _constraints = [likeConstraint]
//        for (idx,_icon) in _icons.enumerated() {
//            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
//            icons.append(["icon": _icon!, "constraint": _constraints[idx]!, "constant": w])
//        }
    }

    override func updateViews(_ _row: Table) {
        
        super.updateViews(_row)
        
        let row: ProductTable? = _row as? ProductTable ?? nil
        if row != nil {
            if row!.prices.count > 0 {
                let tmp: String = (row!.prices[0].price_member).formattedWithSeparator
                //let tmp = m.formattedWithSeparator
                let price: String = "NT$ \(tmp)"
                priceLbl.text = "價格:\(price) 元"
            } else {
                priceLbl.text = "未提供"
            }
            
            cityBtn.isHidden = true
            
            let chevron = UIImage(named: "greater1")
            self.accessoryType = .disclosureIndicator
            self.accessoryView = UIImageView(image: chevron!)
        }
    }
    
}
