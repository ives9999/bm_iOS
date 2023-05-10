//
//  Attriubtes.swift
//  bm
//
//  Created by ives on 2023/5/10.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class AttributesView: UIView {

    var count: Int = 0
    var column: Int = 3
    var row: Int = 1
    
    var labelWidth: CGFloat = 80
    let labelHeight: CGFloat = 30
    let horizonMergin: CGFloat = 30
    let vericalMergin: CGFloat = 16
    
    //var parent: UIView = UIView()
    var attributes: [String] = [String]()
    
    var tagLabels: [Tag] = [Tag]()
    
//    required init() {
//        super.init(frame: CGRect.zero)
//        setupView()
//    }
    
    required init(attributes: [String], column: Int = 3) {
        super.init(frame: CGRect.zero)
        
        //self.parent = parent
        self.attributes = attributes
        self.column = column
        
        self.count = attributes.count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setAttributes() {
        
        var tmp: (quotient: Int, remainder: Int) = count.quotientAndRemainder(dividingBy: column)
        row = (tmp.remainder > 0) ? tmp.quotient + 1 : tmp.quotient
        
        for (idx, attribute) in attributes.enumerated() {
            let tag: Tag = Tag(key: attribute, value: attribute, text: attribute, tag: idx)
            self.addSubview(tag)
            
            let leftPadding: Int = idx*Int((labelWidth + horizonMergin))
            tag.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(leftPadding)
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
            }
//            tmp = idx.quotientAndRemainder(dividingBy: column)
//            self.setMargin(tag: tag, row_count: tmp.quotient + 1, column_count: tmp.remainder + 1)
            
            tagLabels.append(tag)
        }
    }
    
    //    (1, 1)  (1, 2)  (1, 3)
    //    (2, 1)  (2, 2)  (2, 3)
    //    (3, 1)  (3, 2)  (3, 3)
        
    func setMargin(tag: Tag, row_count: Int, column_count: Int) {
        
        
        
        let leading: CGFloat = CGFloat(column_count-1)*labelWidth + CGFloat(column_count-1)*horizonMergin
        let top: CGFloat = CGFloat(row_count-1)*labelHeight + CGFloat(row_count)*vericalMergin
        
        var left: NSLayoutConstraint, up: NSLayoutConstraint
            //h: NSLayoutConstraint, w: NSLayoutConstraint
        
        //左邊
        left = NSLayoutConstraint(item: tag, attribute: .leading, relatedBy: .equal, toItem: tag.superview, attribute: .leading, multiplier: 1, constant: leading)
        
        //上面
        up = NSLayoutConstraint(item: tag, attribute: .top, relatedBy: .equal, toItem: tag.superview, attribute: .top, multiplier: 1, constant: top)
        
        //寬度
        //w = NSLayoutConstraint(item: block, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: labelWidth)
        
        //高度
        //h = NSLayoutConstraint(item: block, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: labelHeight)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([left, up])
    }
}
