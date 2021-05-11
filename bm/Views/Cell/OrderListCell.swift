//
//  OrderListCell.swift
//  bm
//
//  Created by ives on 2021/2/21.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class OrderListCell: SuperCell {
    
    @IBOutlet var nameLbl: SuperLabel!
    @IBOutlet var dateLbl: SuperLabel!
    @IBOutlet var priceLbl: SuperLabel!
    @IBOutlet var orderNoLbl: SuperLabel!
    @IBOutlet var noLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLbl.numberOfLines = 0
        
        priceLbl.textAlignment = .right
        //priceLbl.textColor = UIColor(MY_RED)
        
        nameLbl.setTextTitle()
        orderNoLbl.setTextGeneral()
        dateLbl.setTextGeneral()
        priceLbl.highlight()
    }
    
    func updateOrderViews(indexPath: IndexPath, row: OrderTable) {
        
        if row.product != nil {
            nameLbl.text = row.product!.name
        } else {
            nameLbl.text = "無法取得商品名稱，請洽管理員"
        }
        dateLbl.text = row.created_at_show
        priceLbl.text = row.amount_show
        orderNoLbl.text = row.order_no
        noLbl.text = String(indexPath.row+1)
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
}
