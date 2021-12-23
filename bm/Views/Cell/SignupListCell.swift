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
            let teamTable: TeamTable?
            if let tmp: TeamTable = row?.teamTable {
                teamTable = tmp
            } else {
                teamTable = TeamTable()
            }
            
            if (teamTable != nil) {
                updateViews(teamTable!)
                
                if (teamTable!.arena != nil) {
                    if teamTable!.arena!.name.count > 0 {
                        arenaBtn.setTitle(teamTable!.arena!.name)
                        cityBtn.setTitle(teamTable!.arena!.city_show)
                        cityBtn.isHidden = false
                        arenaBtn.isHidden = false
                    } else {
                        cityBtn.isHidden = true
                        arenaBtn.isHidden = true
                    }
                }
                
                if teamTable!.weekdays_show.count > 0 {
                    weekendLbl.text = teamTable!.weekdays_show
                } else {
                    weekendLbl.text = "未提供"
                }
                
                if teamTable!.interval_show.count > 0 {
                    intervalLbl.text = teamTable!.interval_show
                } else {
                    intervalLbl.text = ""
                }
                
//                let chevron = UIImage(named: "greater1")
//                self.accessoryType = .disclosureIndicator
//                self.accessoryView = UIImageView(image: chevron!)
            }
        }
    }
}
