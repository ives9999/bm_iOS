//
//  CartListCell.swift
//  bm
//
//  Created by ives on 2021/7/25.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class CartListCell: List2Cell {
    
    @IBOutlet weak var attributeLbl: SuperLabel!
    @IBOutlet weak var amountLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews(indexPath: IndexPath, row: CartTable) {
        
//        if row.product != nil {
//            nameLbl.text = row.product!.name
//        } else {
//            nameLbl.text = "無法取得商品名稱，請洽管理員"
//        }
//        dateLbl.text = row.created_at_show
//        priceLbl.text = row.amount_show
//        orderNoLbl.text = row.order_no
//        noLbl.text = String(indexPath.row+1)
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
    
}
