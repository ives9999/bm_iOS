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
    
    @IBOutlet var orderAllProcessTitleLbl: SuperLabel!
    @IBOutlet var gatewayProcessTitleLbl: SuperLabel!
    @IBOutlet var shippingProcessTitleLbl: SuperLabel!
    @IBOutlet var gatewayMethodTitleLbl: SuperLabel!
    @IBOutlet var shippingMethodTitleLbl: SuperLabel!
    
    @IBOutlet var orderAllProcessLbl: SuperLabel!
    @IBOutlet var gatewayProcessLbl: SuperLabel!
    @IBOutlet var shippingProcessLbl: SuperLabel!
    @IBOutlet var gatewayMethodLbl: SuperLabel!
    @IBOutlet var shippingMethodLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLbl.numberOfLines = 0
        
        priceLbl.textAlignment = .right
        //priceLbl.textColor = UIColor(MY_RED)
        
        nameLbl.setTextTitle()
        orderNoLbl.setTextGeneral()
        dateLbl.setTextGeneral()
        priceLbl.highlight()
        
        orderAllProcessLbl.setTextGeneral()
        gatewayProcessLbl.setTextGeneral()
        shippingProcessLbl.setTextGeneral()
        gatewayMethodLbl.setTextGeneral()
        shippingMethodLbl.setTextGeneral()
        
        orderAllProcessTitleLbl.setTextGeneral()
        gatewayProcessTitleLbl.setTextGeneral()
        shippingProcessTitleLbl.setTextGeneral()
        gatewayMethodTitleLbl.setTextGeneral()
        shippingMethodTitleLbl.setTextGeneral()
    }
    
    func updateOrderViews(indexPath: IndexPath, row: OrderTable) {
        
        let items: [OrderItemTable] = row.items
        if (items.count > 0) {
            var name: String = ""
            let productTable = items[0].product
            if productTable != nil {
                name = productTable!.name
            }
            if (items.count > 1) {
                name += "..."
            }
            nameLbl.text = name
        } else {
            nameLbl.text = "無法取得商品名稱，請洽管理員"
        }
        
        dateLbl.text = row.created_at_show
        priceLbl.text = row.amount_show
        orderNoLbl.text = row.order_no
        noLbl.text = String(indexPath.row+1)
        
        orderAllProcessLbl.text = row.all_process_show
        gatewayProcessLbl.text = row.gateway?.process_show
        shippingProcessLbl.text = row.shipping?.process_show
        gatewayMethodLbl.text = row.gateway?.method_show
        shippingMethodLbl.text = row.shipping?.method_show
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
}
