//
//  NumberTextField.swift
//  bm
//
//  Created by ives on 2017/11/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class NumberTextField: SuperTextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardType = UIKeyboardType.numberPad
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
