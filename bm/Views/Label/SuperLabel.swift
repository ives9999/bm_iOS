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
    
    var indexPath: IndexPath?
    var key: String?
    
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
        self.backgroundColor = UIColor.clear
        self.font = UIFont(name: fontName, size: fontSize)
        self.textAlignment = NSTextAlignment.center
        
        self.numberOfLines = 1
    }
    
    func setTextSize(_ size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }

    func setTextColor(_ color: UIColor) {
        self.textColor = color
    }
}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
