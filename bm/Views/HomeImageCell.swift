//
//  HomeCell.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class HomeImageCell: UICollectionViewCell {
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var title: UILabel!
    //var bUpdate: Bool = true
    
    func updateViews(home: Home) {
        //if bUpdate {
            featured.image = home.featured
            title.text = home.title
            //bUpdate = false
        //}
    }
    
}
