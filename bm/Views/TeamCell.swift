//
//  TeamCell.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class TeamCell: UICollectionViewCell {
    
    var title: UILabel!
    var featured: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _initSubview()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _initSubview() {
        let screenWidth = UIScreen.main.bounds.size.width
        self.contentView.backgroundColor = UIColor.white
        
        title = UILabel(frame: CGRect(x: CGFloat(CELL_EDGE_MARGIN), y: CGFloat(0.0), width: screenWidth-CGFloat(CELL_EDGE_MARGIN*2), height: CGFloat(TITLE_HEIGHT)))
        let myFont: UIFont! = UIFont(name: FONT_NAME, size: CGFloat(FONT_SIZE_TITLE))
        title.font = myFont.bold()
        title.textColor = UIColor("#265B03")
        self.addSubview(title)
        
        featured = UIImageView(frame: CGRect(x: CGFloat(CELL_EDGE_MARGIN), y: CGFloat(TITLE_HEIGHT), width: screenWidth-CGFloat(CELL_EDGE_MARGIN*2), height: 20))
        featured.contentMode = .scaleAspectFit
        self.addSubview(featured)
    }
    
    func updateViews(list: List) {
        title.text = list.title
        featured.image = list.featured
    }
}



