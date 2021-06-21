//
//  Tag.swift
//  bm
//
//  Created by ives on 2017/12/7.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

@IBDesignable class Tag: SuperLabel {
    
//    var topInset: CGFloat = 8
//    var bottomInset: CGFloat = 8
//    var leftInset: CGFloat = 16
//    var rightInset: CGFloat = 16
//    var radius: CGFloat = 5
    
    @IBInspectable var topInset: CGFloat = 8
    @IBInspectable var bottomInset: CGFloat = 8
    @IBInspectable var leftInset: CGFloat = 16
    @IBInspectable var rightInset: CGFloat = 16
    
    @IBInspectable var radius: CGFloat = 5
    
    var value: String = ""
    var selected: Bool = false
    
    var unSelected_background = UIColor(TAG_UNSELECTED_BACKGROUND)
    var unSelected_textColor = UIColor(TAG_UNSELECTED_TEXTCOLOR)
    var unSelected_borderColor = UIColor.clear
    var selected_background = UIColor(TAG_SELECTED_BACKGROUND)
    var selected_textColor = UIColor(TAG_SELECTED_TEXTCOLOR)
    var selected_borderColor = UIColor(TAG_SELECTED_BOLDCOLOR)
    var border_width: CGFloat = 2
    var font_size: CGFloat = 16

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit1()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit1()
    }
    
//    convenience init(frame: CGRect, bk: UIColor, textColor: UIColor) {
//        self.init(frame: frame)
//        setColor(bk: bk, textColor: textColor)
//    }
    
    func commonInit1(){
        setTextSize(font_size)
        self.layer.masksToBounds = true
        unSelectedStyle()
        setSelectedStyle()
        isUserInteractionEnabled = true
    }
    
//    func setTagStyle() {
//        setTextSize(font_size)
//        self.layer.masksToBounds = true
//        unSelectedStyle()
//    }
    
//    func setColor(bk: UIColor, textColor: UIColor) {
//        self.backgroundColor = bk
//        setTextColor(textColor)
//    }
    
    func setSelectedStyle() {
        if selected {
            selectedStyle()
        } else {
            unSelectedStyle()
        }
    }
    
    func selectedStyle() {
        layer.cornerRadius = radius
        self.backgroundColor = self.selected_background
        setBorder(width: border_width, color: self.selected_borderColor)
        setTextColor(self.selected_textColor)
    }
    
    func unSelectedStyle() {
        layer.cornerRadius = radius
        self.backgroundColor = self.unSelected_background
        setBorder(width: border_width, color: self.unSelected_borderColor)
        setTextColor(self.unSelected_textColor)
    }
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
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

