//
//  ManagerCourseCell.swift
//  bm
//
//  Created by ives on 2019/5/26.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ManagerCourseCell: List2Cell {
    
    @IBOutlet weak var editIcon: SuperButton!
    @IBOutlet weak var deleteIcon: SuperButton!
    @IBOutlet weak var signupIcon: SuperButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func forRow(row: CourseTable) {
        
        editIcon.row = row
        deleteIcon.row = row
        refreshIcon.row = row
        signupIcon.row = row
        
        titleLbl.text = row.title
        if row.featured_path.count > 0 {
            listFeatured.downloaded(from: row.featured_path)
        }
    }
    
    func forStoreRow(row: StoreTable) {
        
        editIcon.row = row
        deleteIcon.row = row
        refreshIcon.row = row
        
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
