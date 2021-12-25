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
    
    @IBOutlet weak var statusLbl: Tag!
    
    var mobile: String?
    var email: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nicknameLbl.setTextGeneral()
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
                signupTime.text = row!.created_at_show
                
                mobileBtn.setTitle(memberTable!.mobile)
                mobile = memberTable!.mobile
                
                emaileBtn.setTitle(memberTable!.email)
                email = memberTable!.email
            }
            
            statusLbl.text = row!.status_show
            if (row!.status == "cancel") {
                statusLbl.selectedStyle()
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
