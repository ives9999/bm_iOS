//
//  SuperLabel.swift
//  bm
//
//  Created by ives on 2017/12/5.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class SuperLabel: UILabel {
    
    var indexPath: IndexPath?
    var key: String?
    
    var padding: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
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
        //self.backgroundColor = UIColor.gray
        self.font = UIFont(name: FONT_NAME, size: FONT_SIZE_GENERAL)
        self.textAlignment = NSTextAlignment.left
        
        self.numberOfLines = 0
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -padding.top, left: -padding.left, bottom: -padding.bottom, right: -padding.right)
        
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    func setTextSize(_ size: CGFloat) {
        self.font = UIFont(name: FONT_NAME, size: size)
    }
    
    func setTextTitle() {
        self.font = UIFont(name: FONT_BOLD_NAME, size: FONT_SIZE_TITLE)
        self.textColor = UIColor(MY_WHITE)
    }
    
    func setTextSectionTitle() {
        self.font = UIFont(name: FONT_BOLD_NAME, size: FONT_SIZE_TITLE)
        self.textColor = UIColor(MY_WHITE)
        self.textAlignment = NSTextAlignment.center
    }
    
    func setTextGeneral() {
        self.font = UIFont(name: FONT_NAME, size: FONT_SIZE_GENERAL)
        self.textColor = UIColor(TEXT_WHITE)
    }
    
    func setTextGeneralV2() {
        self.font = UIFont(name: FONT_BOLD_NAME, size: FONT_SIZE_GENERAL)
        self.textColor = UIColor(TEXT_WHITE)
    }
    
    func setTextDateTime() {
        self.font = UIFont(name: FONT_NAME, size: FONT_SIZE_GENERAL)
        self.textColor = UIColor(TEXTDATETIME)
    }
    
    func highlight() {
        self.font = UIFont(name: FONT_NAME, size: FONT_SIZE_GENERAL)
        self.textColor = UIColor(MY_WEIGHT_RED)
    }

    func setTextColor(_ color: UIColor) {
        self.textColor = color
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func corner(_ value: CGFloat) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
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
