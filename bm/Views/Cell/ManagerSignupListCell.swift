//
//  ManagerSignupListCell.swift
//  bm
//
//  Created by ives on 2021/12/23.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class ManagerSignupListCell: List2Cell {
    
    @IBOutlet weak var nicknameLbl: SuperLabel!
    @IBOutlet weak var emailLbl: SuperLabel!
    @IBOutlet weak var signupLbl: SuperLabel!
    @IBOutlet weak var signupTime: SuperLabel!
    @IBOutlet weak var mobileBtn: CityButton!
    @IBOutlet weak var emaileBtn: CityButton!
    
    @IBOutlet weak var statusIV: UIImageView!
    
    var mobile: String?
    var email: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nicknameLbl.setTextTitle()
        titleLbl.setTextGeneral()
        
        signupLbl.highlight()
        signupTime.highlight()
        
//        statusLbl.layer.cornerRadius = 5
//        statusLbl.backgroundColor = UIColor(TAG_UNSELECTED_BACKGROUND)
//        statusLbl.setBorder(width: 2, color: UIColor.clear)
//        statusLbl.setTextColor(UIColor(TAG_UNSELECTED_TEXTCOLOR))
    }

    func update(_row: Table) {
        
        let row: SignupNormalTable? = _row as? SignupNormalTable ?? nil
        
        if (row != nil) {
            let memberTable: MemberTable?
            if let tmp: MemberTable = row?.memberTable {
                memberTable = tmp
            } else {
                memberTable = MemberTable()
            }
            
            if (memberTable != nil) {
                updateViews(memberTable!)
                
                nicknameLbl.text = memberTable!.nickname
                titleLbl.text = memberTable!.name
                
                mobileBtn.setTitle(memberTable!.mobile)
                mobile = memberTable!.mobile
                
                emaileBtn.setTitle(memberTable!.email)
                email = memberTable!.email
            }
            
            signupTime.text = row!.created_at_show
            
            let status_enum: SIGNUP_STATUS = SIGNUP_STATUS(status: row!.status)
            if (status_enum == SIGNUP_STATUS.normal) {
                statusIV.image = UIImage(named: "signup_normal")
            } else if (status_enum == SIGNUP_STATUS.cancel) {
                statusIV.image = UIImage(named: "cancel")
            } else if (status_enum == SIGNUP_STATUS.standby) {
                statusIV.image = UIImage(named: "signup_standby")
            }
        }
    }
    
    @IBAction override func mobileBtnPressed(sender: UIButton) {
        
        if (mobile != nil) {
            mobile!.makeCall()
        }
    }
    
    @IBAction func emailBtnPressed(sender: UIButton) {
        if (email != nil) {
            email!.email()
        }
    }
}
