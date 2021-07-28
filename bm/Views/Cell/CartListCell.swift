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
    @IBOutlet weak var quantityLbl: SuperLabel!
    
    @IBOutlet weak var editIcon: SuperButton!
    @IBOutlet weak var deleteIcon: SuperButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        amountLbl.highlight()
    }

    func updateViews(indexPath: IndexPath, row: CartItemTable) {
        
        super.updateViews(row)
        
        if row.product != nil && row.product!.featured_path.count > 0 {
            
            //print(row.featured_path)
            featured_h = listFeatured.heightForUrl(url: row.product!.featured_path, width: 90)
            listFeatured.downloaded(from: row.product!.featured_path)
        }
        
        if (row.product != nil) {
            titleLbl.text = row.product!.name
        }
        
        var attribute_text: String = ""
        if (row.attributes.count > 0) {
            
            for (idx, attribute) in row.attributes.enumerated() {
                attribute_text += attribute["name"]! + ":" + attribute["value"]!
                if (idx < row.attributes.count - 1) {
                    attribute_text += " | "
                }
            }
        }
        attributeLbl.text = attribute_text
        
        amountLbl.text = row.amount_show
        
        quantityLbl.text = "數量：\(row.quantity)"
        
        editIcon.row = row
        deleteIcon.row = row
    }
    
    @IBAction func editBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { (row) in
            if cellDelegate != nil {
                cellDelegate!.cellEdit(row: row)
            }
        }
    }
    
    @IBAction func deleteBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { (row) in
            if cellDelegate != nil {
                cellDelegate!.cellDelete(row: row)
            }
        }
    }
}
