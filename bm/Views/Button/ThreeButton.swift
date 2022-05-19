//
//  ThreeButton.swift
//  bm
//
//  Created by ives on 2022/5/18.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class ThreeButton: SuperButton {

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
        setTitle("退貨", for: .normal)
        setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MY_PURPLE))
        frame.size = CGSize(width: 200, height: 35)
        //self.cornerRadius = MY_BUTTON_CORNER
        //contentEdgeInsets = UIEdgeInsets(top: 4, left: 36, bottom: 4, right: 36)
    }
}
