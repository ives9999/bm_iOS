//
//  CancelButton.swift
//  bm
//
//  Created by ives on 2019/3/16.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class CancelButton: SuperButton {

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
        setTitle("取消", for: .normal)
        setColor(textColor: UIColor.white, bkColor: UIColor(CANCEL_BUTTON))
        //self.cornerRadius = MY_BUTTON_CORNER
        //contentEdgeInsets = UIEdgeInsets(top: 4, left: 36, bottom: 4, right: 36)
    }

}
