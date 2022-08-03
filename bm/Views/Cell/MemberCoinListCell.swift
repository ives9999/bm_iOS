//
//  MemberCoinListCell.swift
//  bm
//
//  Created by ives on 2022/6/7.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class MemberCoinListCell: BaseTableViewCell<MemberCoinTable> {
    
    @IBOutlet weak var noLbl: SuperLabel!
    @IBOutlet weak var priceSignLbl: SuperLabel!
    @IBOutlet weak var priceLbl: SuperLabel!
    @IBOutlet weak var balanceSignLbl: SuperLabel!
    @IBOutlet weak var balanceLbl: SuperLabel!
    @IBOutlet weak var balanceUnitLbl: SuperLabel!
    @IBOutlet weak var dateLbl: SuperLabel!
    @IBOutlet weak var able_typeLbl: SuperLabel!
    @IBOutlet weak var typeButton: SuperButton!
    
    var delegate: MemberCoinListVC?
    var row: MemberCoinTable?

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
    
    override var item: MemberCoinTable? {
        
        didSet {
            update2(row: item)
        }
    }
    
    func update2(row: MemberCoinTable?) {
        
        row?.filterRow()
        
        if (no != nil) {
            noLbl.text = String(no! + 1) + "."
        }
        
        dateLbl.text = row!.created_at.noSec()
        
        balanceLbl.text = row!.balance.formattedWithSeparator
        
        if (row!.able_type_show.count > 0) {
            able_typeLbl.text = row!.able_type_show
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(able_action))
            tap.cancelsTouchesInView = false
            able_typeLbl.addGestureRecognizer(tap)
        }
        
        
        if (row!.in_out) {
            priceLbl.text = "+" + row!.coin.formattedWithSeparator
            typeButton.setTitle(row!.type_in_enum.rawValue)
            if (row!.type_in_enum == MEMBER_COIN_IN_TYPE.buy) {
                typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_BUY))
            } else if (row!.type_in_enum == MEMBER_COIN_IN_TYPE.gift) {
                typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_GIFT))
            } else {
                typeButton.isHidden = true
            }
        } else {
            priceLbl.text = "-" + row!.coin.formattedWithSeparator
            priceLbl.setTextColor(UIColor(MY_RED))
            typeButton.setTitle(row!.type_out_enum.rawValue)
            if (row!.type_out_enum == MEMBER_COIN_OUT_TYPE.product) {
                typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
            } else if (row!.type_out_enum == MEMBER_COIN_OUT_TYPE.course) {
                typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
            } else {
                typeButton.isHidden = true
            }
        }
        
        if (row!.name.count > 0) {
            able_typeLbl.text = row!.name
        }
    }

    func update(_row: Table, no: Int) {
        
        row = _row as? MemberCoinTable ?? nil
        
        if (row != nil) {
            
            noLbl.text = String(no) + "."
            
            dateLbl.text = row!.created_at.noSec()
            
            balanceLbl.text = row!.balance.formattedWithSeparator
            
            if (row!.able_type_show.count > 0) {
                able_typeLbl.text = row!.able_type_show
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(able_action))
                tap.cancelsTouchesInView = false
                able_typeLbl.addGestureRecognizer(tap)
            }
            
            
            if (row!.in_out) {
                priceLbl.text = "+" + row!.coin.formattedWithSeparator
                typeButton.setTitle(row!.type_in_enum.rawValue)
                if (row!.type_in_enum == MEMBER_COIN_IN_TYPE.buy) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_BUY))
                } else if (row!.type_in_enum == MEMBER_COIN_IN_TYPE.gift) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_GIFT))
                } else {
                    typeButton.isHidden = true
                }
            } else {
                priceLbl.text = "-" + row!.coin.formattedWithSeparator
                priceLbl.setTextColor(UIColor(MY_RED))
                typeButton.setTitle(row!.type_out_enum.rawValue)
                if (row!.type_out_enum == MEMBER_COIN_OUT_TYPE.product) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
                } else if (row!.type_out_enum == MEMBER_COIN_OUT_TYPE.course) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
                } else {
                    typeButton.isHidden = true
                }
            }
            
            if (row!.name.count > 0) {
                able_typeLbl.text = row!.name
            }
//            typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MY_BUY))
//            if row!.type_enum == MEMBER_COIN.buy {
//                typeButton.setTitle(row!.type_enum)
//                typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MY_BUY))
//            } else {
//                typeButton.setTitle("支出")
//                typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MY_PAY))
//            }
        }
        
    }
    
    @objc func able_action(_ sender: UITapGestureRecognizer) {
        if (delegate != nil && row != nil) {
            delegate!.toPayment(order_token: row!.able_token)
        }
    }
    
}
