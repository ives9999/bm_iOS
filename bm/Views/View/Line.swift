//
//  line.swift
//  bm
//
//  Created by ives on 2024/5/27.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class Line: UIView {

    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.backgroundColor = UIColor(gray_700)
    }
}
