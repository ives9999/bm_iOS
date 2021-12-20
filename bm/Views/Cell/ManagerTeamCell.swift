//
//  ManagerTeamCell.swift
//  bm
//
//  Created by ives on 2021/11/19.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class ManagerTeamCell: List2Cell {
        
    @IBOutlet weak var editIcon: SuperButton!
    @IBOutlet weak var deleteIcon: SuperButton!
    @IBOutlet weak var signupIcon: SuperButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func forRow(row: TeamTable) {
        
        editIcon.row = row
        deleteIcon.row = row
        refreshIcon.row = row
        signupIcon.row = row
        
        titleLbl.text = row.name
        if row.featured_path.count > 0 {
            listFeatured.downloaded(from: row.featured_path)
        }
    }
    
    @IBAction func signBtnPressed(sender: UIButton) {
        
        self._pressed(sender: sender) { row in
            if cellDelegate != nil {
                cellDelegate!.cellSignup(row: row)
            }
        }
    }
}
