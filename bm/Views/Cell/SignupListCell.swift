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
    @IBOutlet weak var signupTime: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(_row: Table) {
        
        let row: TeamTable? = _row as? TeamTable ?? nil
        if row != nil {
            if (row!.arena != nil) {
                if row!.arena!.name.count > 0 {
                    arenaBtn.setTitle(row!.arena!.name)
                    cityBtn.setTitle(row!.arena!.city_show)
                    cityBtn.isHidden = false
                    arenaBtn.isHidden = false
                } else {
                    cityBtn.isHidden = true
                    arenaBtn.isHidden = true
                }
            }
            
            if row!.weekdays_show.count > 0 {
                weekendLbl.text = row!.weekdays_show
            } else {
                weekendLbl.text = "未提供"
            }
            
//            if row!.interval_show.count > 0 {
//                intervalLbl.text = row!.interval_show
//            } else {
//                intervalLbl.text = "未提供"
//            }
            
            let chevron = UIImage(named: "greater1")
            self.accessoryType = .disclosureIndicator
            self.accessoryView = UIImageView(image: chevron!)
        }
    }
}
