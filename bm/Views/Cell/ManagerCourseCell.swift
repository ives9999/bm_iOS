//
//  ManagerCourseCell.swift
//  bm
//
//  Created by ives on 2019/5/26.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ManagerCourseCell: SuperCell {
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func forRow(row: SuperCourse) {
        titleLbl.text = row.title
        if row.featured_path.count > 0 {
            featured.downloaded(from: row.featured_path)
        }
    }
    
}
