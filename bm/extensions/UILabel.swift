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
    
    func weight(_ value: CGFloat) {
        
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                    .strokeColor : UIColor.black,
                    .strokeWidth : value,
                ]
        let mutableString = NSMutableAttributedString.init(string: self.text ?? "", attributes: strokeTextAttributes)
        self.attributedText = mutableString
    }
    
}





































