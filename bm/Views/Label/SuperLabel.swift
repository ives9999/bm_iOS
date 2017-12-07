//
//  SuperLabel.swift
//  bm
//
//  Created by ives on 2017/12/5.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class SuperLabel: UILabel {

    var fontName: String = FONT_NAME
    var fontSize: CGFloat = FONT_SIZE_TITLE
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.textColor = UIColor.white
        self.font = UIFont(name: fontName, size: fontSize)
        self.numberOfLines = 1
        self.textAlignment = NSTextAlignment.center
    }
    
    func setTextSize(_ size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
    
    func setTagStyle(bk: UIColor) {
        self.backgroundColor = bk
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

    func setTextColor(_ color: UIColor) {
        self.textColor = color
    }
}
