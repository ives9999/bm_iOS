//
//  CityButton.swift
//  bm
//
//  Created by ives on 2019/2/4.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class CityButton: SuperButton {

    init() {
        super.init(frame: .zero)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        setColor(textColor: UIColor.black, bkColor: UIColor(CITY_BUTTON))
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    }
    
    override func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }

}
