//
//  SuperSwitch.swift
//  bm
//
//  Created by ives on 2018/10/24.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class SuperSwitch: UISwitch {

    var indexPath: IndexPath?
    var key: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()  {
        onTintColor = UIColor(MY_RED)
        tintColor = UIColor.gray
    }
}
