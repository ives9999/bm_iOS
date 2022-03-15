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
    
    var oneRow: OneRow = OneRow()
    var sectionIdx: Int = 0
    var rowIdx: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        amountLbl.highlight()
    }

    //for member cart list cell
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
    
//    func update(sectionKey: String, rowKey: String, title: String, featured_path: String, attribute: String, amount: String, quantity: String) {
//
//
//        featured_h = listFeatured.heightForUrl(url: featured_path, width: 90)
//        listFeatured.downloaded(from: featured_path)
//
//        titleLbl.text = title
//
//        attributeLbl.text = attribute
//
//        amountLbl.text = amount
//
//        quantityLbl.text = "數量：\(quantity)"
//
//        if (iconView != nil) {
//            iconView.isHidden = true
//            iconViewConstraint.constant = 0
//        }
//    }
    
    //for orderVC
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        featured_h = listFeatured.heightForUrl(url: row.featured_path, width: 90)
        listFeatured.downloaded(from: row.featured_path)
        
        titleLbl.text = row.title
        
        attributeLbl.text = row.attribute
        
        amountLbl.text = row.amount
        
        quantityLbl.text = "數量：\(row.quantity)"
        
        if (iconView != nil) {
            iconView.isHidden = true
            iconViewConstraint.constant = 0
        }
    }
}
