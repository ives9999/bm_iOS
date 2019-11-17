//
//  EMailTextField.swift
//  bm
//
//  Created by ives on 2017/11/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class EMailTextField: SuperTextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardType = UIKeyboardType.emailAddress
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.keyboardType = UIKeyboardType.emailAddress
        setupView()
    }

}
