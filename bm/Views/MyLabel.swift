//
//  MyLabel.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

@IBDesignable
class MyLabel: UILabel {
    var fontName: String = FONT_NAME
    var fontSize: CGFloat = FONT_SIZE_TITLE

    convenience init(frame: CGRect, fontName: String, fontSize: CGFloat) {
        self.init(frame: frame)
        self.fontName = fontName
        self.fontSize = fontSize
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.textColor = UIColor.white
        self.font = UIFont(name: fontName, size: fontSize)
        self.numberOfLines = 0
        self.sizeToFit()
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
