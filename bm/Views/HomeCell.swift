//
//  HomeCell.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func updateViews(home: Home) {
        featured.image = UIImage(named:home.featured)
        title.text = home.title
    }
    
}
