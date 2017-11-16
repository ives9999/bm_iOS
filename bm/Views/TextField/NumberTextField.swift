//
//  NumberTextField.swift
//  bm
//
//  Created by ives on 2017/11/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class NumberTextField: SuperTextField {

    convenience init(align: NSTextAlignment) {
        self.init(frame: CGRect.zero)
        self.textAlignment = align
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .right
        self.keyboardType = UIKeyboardType.numberPad
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
