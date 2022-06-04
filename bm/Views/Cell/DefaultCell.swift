//
//  DefaultCell.swift
//  bm
//
//  Created by ives on 2022/5/30.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class DefaultCell: List2Cell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(featured_path: String, title: String) {
        
        self.backgroundColor = UIColor.clear
        
        if featured_path.count > 0 {
            
            //print(row.featured_path)
            featured_h = listFeatured.heightForUrl(url: featured_path, width: 90)
            listFeatured.downloaded(from: featured_path)
        }
        
        titleLbl.text = title
        titleLbl.textColor = UIColor(MY_GREEN)
        
    }
    
}
