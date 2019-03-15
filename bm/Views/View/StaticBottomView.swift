//
//  StaticBottomView.swift
//  bm
//
//  Created by ives on 2019/2/21.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class StaticBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()  {
        backgroundColor = UIColor(MY_GREEN)
    }
    
    func myAttach() {
        
    }
}
