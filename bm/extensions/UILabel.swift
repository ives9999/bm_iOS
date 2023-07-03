//
//  UILabel.swift
//  bm
//
//  Created by ives on 2023/2/2.
//  Copyright © 2023 bm. All rights reserved.
//

//https://stackoverflow.com/questions/27459746/adding-space-padding-to-a-uilabel

import UIKit

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
    
    func setSpecialTextColor (fullText : String , changeText : String, color: UIColor) {
        
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attributedString = NSMutableAttributedString.init(string: fullText)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        
        attributedString.addAttributes(attributes, range: range)
        
        self.attributedText = attributedString
    }
    
    func setSpecialTextBold (fullText : String , changeText : String, ofSize: CGFloat) {
        
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attributedString = NSMutableAttributedString.init(string: fullText)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: ofSize)
        ]
        
        attributedString.addAttributes(attributes, range: range)
        
        self.attributedText = attributedString
    }
    
    func setSpecialTextColorAndBold (fullText : String , changeText : String, color: UIColor, ofSize: CGFloat) {
        
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attributedString = NSMutableAttributedString.init(string: fullText)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.boldSystemFont(ofSize: ofSize)
        ]
        
        attributedString.addAttributes(attributes, range: range)
        
        self.attributedText = attributedString
    }
    
    func weight(_ value: CGFloat) {
        
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                    .strokeColor : UIColor.black,
                    .strokeWidth : value,
                ]
        let mutableString = NSMutableAttributedString.init(string: self.text ?? "", attributes: strokeTextAttributes)
        self.attributedText = mutableString
    }
    
}





































