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
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        setColor(textColor: UIColor.black, bkColor: UIColor(CITY_BUTTON))
//        var configuration = Configuration.filled()
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
        //contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    override func setTitle(_ title: String) {
        
        let newTitle: String = title.truncate(length: 5)
        
        setTitle(newTitle, for: .normal)
    }

}
