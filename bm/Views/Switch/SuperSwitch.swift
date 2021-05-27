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
        //backgroundColor = UIColor.red
        if #available(iOS 13.0, *) {
            subviews.first?.subviews.first?.backgroundColor = UIColor(MY_GRAY)
        } else if #available(iOS 12.0, *) {
            subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(MY_GRAY)
        }
        onTintColor = UIColor(MY_LIGHT_RED)
//        tintColor = UIColor.green
//        clipsToBounds = true
    }
}
