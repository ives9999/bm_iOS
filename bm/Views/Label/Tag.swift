//
//  Tag.swift
//  bm
//
//  Created by ives on 2017/12/7.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class Tag: SuperLabel {
    
    let topInset: CGFloat = 2
    let bottomInset: CGFloat = 2
    let leftInset: CGFloat = 24
    let rightInset: CGFloat = 24

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit1()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit1()
    }
    convenience init(frame: CGRect, bk: UIColor, textColor: UIColor) {
        self.init(frame: frame)
        setColor(bk: bk, textColor: textColor)
    }
    func commonInit1(){
        setTagStyle(bk: UIColor.clear)
    }
    func setTagStyle(bk: UIColor) {
        self.backgroundColor = bk
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    func setColor(bk: UIColor, textColor: UIColor) {
        self.backgroundColor = bk
        setTextColor(textColor)
    }
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
 
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 */
    

}