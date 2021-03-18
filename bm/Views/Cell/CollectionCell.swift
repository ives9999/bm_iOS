//
//  CollectionCell.swift
//  bm
//
//  Created by ives on 2018/8/2.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: UIImageView!
    @IBOutlet weak var pvIcon: UIImageView!
    @IBOutlet weak var pvLbl: UILabel!
    @IBOutlet weak var createdAtIcon: UIImageView!
    @IBOutlet weak var createdAtLbl: UILabel!
    //@IBOutlet weak var featuredViewHeightConstraint: NSLayoutConstraint!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
//        let screenWidth = UIScreen.main.bounds.size.width
        titleLbl.numberOfLines = 0
        pvIcon.image = pvIcon.image!.withRenderingMode(.alwaysTemplate)
        pvIcon.tintColor = UIColor("#265B03")
        createdAtIcon.image = createdAtIcon.image!.withRenderingMode(.alwaysTemplate)
        createdAtIcon.tintColor = UIColor("#265B03")
    }
    
    func updateTeach(data: TeachTable, idx: Int) {
        self.idx = idx
        titleLbl.text = data.title
        
        if data.featured_path.count > 0 {
            //print(data.featured_path)
            featuredView.downloaded(from: data.featured_path)
        }
//        let featured = data.featured
//        let aspect = featured.size.width / featured.size.height
//        let constraint = NSLayoutConstraint(item: featuredView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: featuredView, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0)
        
//        constraint.priority = UILayoutPriority(rawValue: 999)
//        aspectConstraint = constraint
//        featuredView.image = featured
        
        pvLbl.text = "瀏覽數：" + String(data.pv)
        createdAtLbl.text = "建立時間：" + data.created_at_show
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        featuredView.layer.masksToBounds = true
        titleLbl.sizeToFit()
        //pvLbl.sizeToFit()
        //createdAtLbl.sizeToFit()
        //print("2.\(self.idx):\(titleLbl.frame.size.height)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }

}
