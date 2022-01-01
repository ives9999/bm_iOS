//
//  SignupListCell.swift
//  bm
//
//  Created by ives on 2019/10/1.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SignupListCell: List2Cell {
    
    @IBOutlet weak var weekendLbl: SuperLabel!
    @IBOutlet weak var intervalLbl: SuperLabel!
    @IBOutlet weak var signupLbl: SuperLabel!
    @IBOutlet weak var signupTime: SuperLabel!
    
    @IBOutlet weak var statusIV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        weekendLbl.setTextGeneral()
        intervalLbl.setTextGeneral()
        
        signupLbl.highlight()
        signupTime.highlight()
    }
    
    func update(_row: Table) {
        
        let row: SignupNormalTable? = _row as? SignupNormalTable ?? nil
        
        if (row != nil) {
            let ableTable: AbleTable?
            if let tmp: AbleTable = row?.ableTable {
                ableTable = tmp
            } else {
                ableTable = AbleTable()
            }
            
            if (ableTable != nil) {
                updateViews(ableTable!)
                
                if (ableTable!.name.count > 0) {
                    titleLbl.text = ableTable!.name
                }
                
                if (ableTable!.title.count > 0) {
                    titleLbl.text = ableTable!.title
                }
                
                if (ableTable!.city_id > 0) {
                    cityBtn.setTitle(ableTable!.city_show)
                    cityBtn.isHidden = false
                } else {
                    cityBtn.isHidden = true
                }
                
                if ableTable!.arena_name.count > 0 {
                    arenaBtn.setTitle(ableTable!.arena_name)
                    arenaBtn.isHidden = false
                } else {
                    arenaBtn.isHidden = true
                }
                
                if ableTable!.weekdays_show.count > 0 {
                    weekendLbl.text = ableTable!.weekdays_show
                } else {
                    weekendLbl.text = "未提供"
                }
                
                if ableTable!.interval_show.count > 0 {
                    intervalLbl.text = ableTable!.interval_show
                } else {
                    intervalLbl.text = ""
                }
                
//                let chevron = UIImage(named: "greater1")
//                self.accessoryType = .disclosureIndicator
//                self.accessoryView = UIImageView(image: chevron!)
            }
            
            let status_enum = SIGNUP_STATUS(status: row!.status)
            if (status_enum == SIGNUP_STATUS.normal) {
                statusIV.image = UIImage(named: "signup_normal")
            } else if (status_enum == SIGNUP_STATUS.cancel) {
                statusIV.image = UIImage(named: "cancel")
            } else if (status_enum == SIGNUP_STATUS.standby) {
                statusIV.image = UIImage(named: "signup_standby")
            }
            
            signupTime.text = row!.created_at_show
        }
    }
}
