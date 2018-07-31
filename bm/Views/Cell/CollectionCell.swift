//
//  TeamCell.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class CollectionCell: UICollectionViewCell {
    
    var titleLbl: UILabel!
    var featuredView: UIImageView!
    
    internal var aspectConstraint: NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                featuredView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                featuredView.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLbl = UILabel(frame: CGRect.zero)
        contentView.addSubview(titleLbl)
        featuredView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(featuredView)
        _initSubview()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _initSubview() {
        let cellWidth = self.bounds.width
        let cellHeight = self.bounds.height
        self.contentView.backgroundColor = UIColor.white
        
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint, c4: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: titleLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c2 = NSLayoutConstraint(item: titleLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c3 = NSLayoutConstraint(item: titleLbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cellWidth-(2*CELL_EDGE_MARGIN))
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3])
        
        //titleLbl = UILabel(frame: CGRect(x: CGFloat(CELL_EDGE_MARGIN), y: CGFloat(0.0), width: cellWidth-CGFloat(CELL_EDGE_MARGIN*2), height: CGFloat(TITLE_HEIGHT)))
        let myFont: UIFont! = UIFont(name: FONT_NAME, size: CGFloat(FONT_SIZE_TITLE))
        titleLbl.font = myFont.bold()
        titleLbl.textColor = UIColor("#265B03")
        titleLbl.numberOfLines = 0
        
        c1 = NSLayoutConstraint(item: featuredView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: featuredView, attribute: .top, relatedBy: .equal, toItem: titleLbl, attribute: .bottom, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c3 = NSLayoutConstraint(item: featuredView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cellWidth)
        //c4 = NSLayoutConstraint(item: featuredView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: FEATURED_HEIGHT)
        featuredView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3])
        
        //featured = UIImageView(frame: CGRect.zero)
        //featured = UIImageView(frame: CGRect(x: CGFloat(CELL_EDGE_MARGIN), y: CGFloat(TITLE_HEIGHT), width: cellWidth-CELL_EDGE_MARGIN*2, height: self.bounds.height))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //featuredView.contentMode = .scaleAspectFit
        //featuredView.contentMode = .scaleAspectFill
        featuredView.layer.masksToBounds = true
        titleLbl.sizeToFit()
    }
    
    func updateViews(data: SuperData) {
        titleLbl.text = data.title
        let featured = data.featured
        featuredView.image = featured
        
        let aspect = featured.size.width / featured.size.height
        let constraint = NSLayoutConstraint(item: featuredView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: featuredView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        aspectConstraint = constraint
        
        setNeedsLayout()
    }
}



