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
        backgroundColor = UIColor(MY_GREEN)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func myAttach() {
        
    }
}
