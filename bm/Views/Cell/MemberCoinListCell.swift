//
//  MemberCoinListCell.swift
//  bm
//
//  Created by ives on 2022/6/7.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class MemberCoinListCell: List2Cell {
    
    @IBOutlet weak var noLbl: SuperLabel!
    @IBOutlet weak var priceLbl: SuperLabel!
    @IBOutlet weak var dateLbl: SuperLabel!
    @IBOutlet weak var able_typeLbl: SuperLabel!
    
    var delegate: MemberCoinListVC?
    var row: MemberCoinTable?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if (noLbl != nil) {
            noLbl.setTextGeneral()
        }
        
        if (priceLbl != nil) {
            priceLbl.highlight()
        }
        
        if (able_typeLbl != nil) {
            able_typeLbl.setTextGeneral()
        }
        
        if (dateLbl != nil) {
            dateLbl.setTextGeneral()
        }
    }

    func update(_row: Table, no: Int) {
        
        row = _row as? MemberCoinTable ?? nil
        
        if (row != nil) {
            
            noLbl.text = String(no) + "."
            priceLbl.text = row!.coin_show
            dateLbl.text = row!.created_at.noSec()
            
            if (row!.able_type_show.count > 0) {
                able_typeLbl.text = row!.able_type_show
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(able_action))
                tap.cancelsTouchesInView = false
                able_typeLbl.addGestureRecognizer(tap)
            }
        }
        
    }
    
    @objc func able_action(_ sender: UITapGestureRecognizer) {
        if (delegate != nil && row != nil) {
            delegate!.toPayment(order_token: row!.able_token)
        }
    }
    
}
