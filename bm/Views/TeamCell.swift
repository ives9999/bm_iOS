//
//  TeamCell.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var featured: UIImageView!
    
    func updateViews(team: Team) {
        title.text = team.ti
    }
}
