//
//  MemberCoinListCell.swift
//  bm
//
//  Created by ives on 2022/6/7.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class MemberCoinListCell: BaseCell<MemberCoinTable> {
    
    @IBOutlet weak var noLbl: SuperLabel!
    @IBOutlet weak var priceSignLbl: SuperLabel!
    @IBOutlet weak var priceLbl: SuperLabel!
    @IBOutlet weak var balanceSignLbl: SuperLabel!
    @IBOutlet weak var balanceLbl: SuperLabel!
    @IBOutlet weak var balanceUnitLbl: SuperLabel!
    @IBOutlet weak var dateLbl: SuperLabel!
    @IBOutlet weak var able_typeLbl: SuperLabel!
    @IBOutlet weak var typeButton: SuperButton!
    
    //var row: MemberCoinTable?

    override func awakeFromNib() {
        super.awakeFromNib()
                
        if (noLbl != nil) {
            noLbl.setTextSize(15)
            noLbl.setTextColor(UIColor(CITY_BUTTON))
        }
        
        if (priceSignLbl != nil) {
            priceSignLbl.setTextSize(10)
            priceSignLbl.setTextColor(UIColor(MY_WHITE))
        }
        
        if (priceLbl != nil) {
            priceLbl.setTextSize(16)
            priceLbl.setTextColor(UIColor(MY_WHITE))
        }
        
        if (balanceSignLbl != nil) {
            balanceSignLbl.setTextSize(10)
            balanceSignLbl.setTextColor(UIColor(MY_WHITE))
        }
        
        if (balanceLbl != nil) {
            balanceLbl.setTextSize(16)
            balanceLbl.setTextColor(UIColor(MY_WHITE))
        }
        
        if (balanceUnitLbl != nil) {
            balanceUnitLbl.setTextSize(10)
            balanceUnitLbl.setTextColor(UIColor(MY_WHITE))
        }
        
        if (able_typeLbl != nil) {
            able_typeLbl.setTextSize(16)
            priceLbl.setTextColor(UIColor(TEXT_WHITE))
        }
        
        if (dateLbl != nil) {
            dateLbl.setTextSize(10)
            dateLbl.setTextColor(UIColor(MY_LIGHT_WHITE))
        }
    }
    
    override func configureSubViews() {
        
        super.configureSubViews()
        
        if (item != nil) {
            noLbl.text = String(item!.no + 1) + "."
            
            dateLbl.text = item!.created_at.noSec()
            
            balanceLbl.text = item!.balance.formattedWithSeparator
            
            if (item!.able_type_show.count > 0) {
                able_typeLbl.text = item!.able_type_show
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(able_action))
                tap.cancelsTouchesInView = false
                able_typeLbl.addGestureRecognizer(tap)
            }
            
            
            if (item!.in_out) {
                priceLbl.text = "+" + item!.coin.formattedWithSeparator
                typeButton.setTitle(item!.type_in_enum.rawValue)
                if (item!.type_in_enum == MEMBER_COIN_IN_TYPE.buy) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_BUY))
                } else if (item!.type_in_enum == MEMBER_COIN_IN_TYPE.gift) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_GIFT))
                } else {
                    typeButton.isHidden = true
                }
            } else {
                priceLbl.text = "-" + item!.coin.formattedWithSeparator
                priceLbl.setTextColor(UIColor(MY_RED))
                typeButton.setTitle(item!.type_out_enum.rawValue)
                if (item!.type_out_enum == MEMBER_COIN_OUT_TYPE.product) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
                } else if (item!.type_out_enum == MEMBER_COIN_OUT_TYPE.course) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
                } else {
                    typeButton.isHidden = true
                }
            }
            
            if (item!.name.count > 0) {
                able_typeLbl.text = item!.name
            }
        }
    }
    
    @objc func able_action(_ sender: UITapGestureRecognizer) {
        if (delegate != nil && item != nil) {
            delegate!.toPayment(order_token: item!.able_token)
        }
    }
    
}
