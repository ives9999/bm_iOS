//
//  SuperTextView.swift
//  bm
//
//  Created by ives on 2019/6/9.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SuperTextView: UITextView {
    
    var fontName: String = FONT_NAME
    var fontSize: CGFloat = FONT_SIZE_TITLE
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }

    func commonInit(){
        self.textColor = UIColor.white
        self.backgroundColor = UIColor(TEXTBACKGROUND)
        self.layer.borderColor = UIColor(MY_GREEN).cgColor
        self.layer.borderWidth = 1
        self.font = UIFont(name: fontName, size: fontSize)
        self.textAlignment = NSTextAlignment.center
    }
}
