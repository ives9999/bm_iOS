//
//  ClearButton.swift
//  bm
//
//  Created by ives on 2019/6/10.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ClearButton: SuperButton {

    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        setTitle("清除", for: .normal)
        setColor(textColor: UIColor.white, bkColor: UIColor(CLEAR_BUTTON))
        //self.cornerRadius = MY_BUTTON_CORNER
        //contentEdgeInsets = UIEdgeInsets(top: 8, left: 36, bottom: 8, right: 36)
    }

}
