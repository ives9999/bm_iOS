//
//  SuperButton.swift
//  bm
//
//  Created by ives on 2017/12/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class SuperButton: UIButton {

    var fontName: String = FONT_NAME
    var fontSize: CGFloat = FONT_SIZE_TITLE
    
    var indexPath: IndexPath?
    var key: String?
    
    convenience init(frame: CGRect, textColor: UIColor, bkColor: UIColor) {
        self.init(frame: frame)
        setColor(textColor: textColor, bkColor: bkColor)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.titleLabel?.font = UIFont(name: fontName, size: fontSize)
        self.alignH = .left
        self.alignV = .center
        self.cornerRadius = 12
        self.padding(top: 3, left: 8, bottom: 3, right: 8)
    }
    open var alignH: UIControlContentHorizontalAlignment = UIControlContentHorizontalAlignment.left {
        didSet {
            contentHorizontalAlignment = alignH
        }
    }
    open var alignV: UIControlContentVerticalAlignment = UIControlContentVerticalAlignment.center {
        didSet {
            contentVerticalAlignment = alignV
        }
    }
    open var cornerRadius: CGFloat = 3.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    func setColor(textColor: UIColor, bkColor: UIColor) {
        self.setTitleColor(textColor, for: UIControlState.normal)
        self.backgroundColor = bkColor
    }
    func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    func cornerRadius(_ value: CGFloat) {
        self.layer.cornerRadius = value
    }
    func setTextSize(_ size: CGFloat) {
        self.titleLabel?.font = UIFont(name: fontName, size: size)
    }

}
