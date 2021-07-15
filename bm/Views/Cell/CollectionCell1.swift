//
//  TeamCell.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class CollectionCell1: UICollectionViewCell {
    
    var titleLbl: UILabel!
    var featuredView: UIImageView!
    var pvLbl: UILabel!
    var createdAtLbl: UILabel!
    var idx: Int = 0
    
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
        
        let titleFont: UIFont! = UIFont(name: FONT_NAME, size: CGFloat(FONT_SIZE_TITLE))
        let otherFont: UIFont! = UIFont(name: FONT_NAME, size: CGFloat(FONT_SIZE_TABBAR))
        titleLbl = UILabel(frame: CGRect.zero)
        titleLbl.font = titleFont.bold()
        titleLbl.textColor = UIColor("#265B03")
        titleLbl.numberOfLines = 0
        contentView.addSubview(titleLbl)
        
        featuredView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(featuredView)
        
        pvLbl = UILabel(frame: CGRect.zero)
        pvLbl.font = otherFont
        pvLbl.textColor = UIColor("#265B03")
        contentView.addSubview(pvLbl)
        
        createdAtLbl = UILabel(frame: CGRect.zero)
        createdAtLbl.font = otherFont
        createdAtLbl.textColor = UIColor("#265B03")
        contentView.addSubview(createdAtLbl)
        
        _initSubview()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _initSubview() {
        let cellWidth = self.frame.width
        //let cellHeight = self.frame.height
        self.contentView.backgroundColor = UIColor.white
        
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint, c4: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: titleLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c2 = NSLayoutConstraint(item: titleLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c3 = NSLayoutConstraint(item: titleLbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cellWidth-(2*CELL_EDGE_MARGIN))
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3])
        
        //titleLbl = UILabel(frame: CGRect(x: CGFloat(CELL_EDGE_MARGIN), y: CGFloat(0.0), width: cellWidth-CGFloat(CELL_EDGE_MARGIN*2), height: CGFloat(TITLE_HEIGHT)))
        
        c1 = NSLayoutConstraint(item: featuredView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: featuredView, attribute: .top, relatedBy: .equal, toItem: titleLbl, attribute: .bottom, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c3 = NSLayoutConstraint(item: featuredView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cellWidth)
        //c4 = NSLayoutConstraint(item: featuredView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: FEATURED_HEIGHT)
        featuredView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3])
        
        c1 = NSLayoutConstraint(item: pvLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c2 = NSLayoutConstraint(item: pvLbl, attribute: .top, relatedBy: .equal, toItem: featuredView, attribute: .bottom, multiplier: 1, constant: CELL_EDGE_MARGIN)
        pvLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: createdAtLbl, attribute: .leading, relatedBy: .equal, toItem: pvLbl, attribute: .trailing, multiplier: 1, constant: CELL_EDGE_MARGIN)
        c2 = NSLayoutConstraint(item: createdAtLbl, attribute: .top, relatedBy: .equal, toItem: featuredView, attribute: .bottom, multiplier: 1, constant: CELL_EDGE_MARGIN)
        createdAtLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //featuredView.contentMode = .scaleAspectFit
        //featuredView.contentMode = .scaleAspectFill
        featuredView.layer.masksToBounds = true
        titleLbl.sizeToFit()
        pvLbl.sizeToFit()
        createdAtLbl.sizeToFit()
        //print("2.\(self.idx):\(titleLbl.frame.size.height)")
    }
    
//    func updateViews(data: SuperData, idx: Int) {
//        self.idx = idx
//        titleLbl.text = data.title
//        let featured = data.featured
//        featuredView.image = featured
//        pvLbl.text = "瀏覽數：" + (data.data[PV_KEY]!["show"] as! String)
//        var createdAt: String = (data.data[CREATED_AT_KEY]!["show"] as! String)
//        createdAt = createdAt.toDateTime().toString()
//        createdAtLbl.text = "建立時間：" + createdAt
//        
//        let aspect = featured.size.width / featured.size.height
//        //let constraint = NSLayoutConstraint(item: featuredView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: featuredView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0)
//        let constraint = NSLayoutConstraint(item: featuredView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.size.width/aspect)
//        constraint.priority = UILayoutPriority(rawValue: 999)
//        aspectConstraint = constraint
//        
//        //print("1.\(idx):\(self.frame.size.height)")
//        
//        setNeedsLayout()
//    }
}



