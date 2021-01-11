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
    
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

extension UILabel {
    func calculateMaxLines() -> Int {
        self.layoutIfNeeded()

                let myText = self.text! as NSString

                let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
                let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)

                return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
//        let textStorage = NSTextStorage(attributedString: self.attributedText!)
//                let layoutManager = NSLayoutManager()
//                textStorage.addLayoutManager(layoutManager)
//                let textContainer = NSTextContainer(size: self.bounds.size)
//                textContainer.lineFragmentPadding = 0
//                textContainer.lineBreakMode = self.lineBreakMode
//                layoutManager.addTextContainer(textContainer)
//
//                let numberOfGlyphs = layoutManager.numberOfGlyphs
//                var numberOfLines = 0, index = 0, lineRange = NSMakeRange(0, 1)
//
//                while index < numberOfGlyphs {
//                    layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
//                    index = NSMaxRange(lineRange)
//                    numberOfLines += 1
//                }
//                return numberOfLines
    }
}
