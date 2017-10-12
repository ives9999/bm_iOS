//
//  HomeCell.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import TRVideoView

class HomeImageCell: UICollectionViewCell {
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func updateViews(home: Home) {
        featured.image = home.featured
        title.text = home.title
    }
    
}
