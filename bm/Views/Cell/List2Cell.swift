//
//  List2Cell.swift
//  bm
//
//  Created by ives sun on 2021/4/16.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class List2Cell: UITableViewCell {
    
    @IBOutlet weak var listFeatured: UIImageView!
    
    var featured_h: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func _updateViews<T: Table>(indexPath: IndexPath, row: T) {
        
        self.backgroundColor = UIColor.clear
        
        if row.featured_path.count > 0 {
            
            featured_h = listFeatured.heightForUrl(url: row.featured_path, width: 90)
            listFeatured.downloaded(from: row.featured_path)
        }
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
}
