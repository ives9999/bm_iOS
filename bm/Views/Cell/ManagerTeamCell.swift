//
//  ManagerTeamCell.swift
//  bm
//
//  Created by ives on 2021/11/19.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class ManagerTeamCell: SuperCell {
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func forRow(row: TeamTable) {
        titleLbl.text = row.name
        if row.featured_path.count > 0 {
            featured.downloaded(from: row.featured_path)
        }
    }
    
}
