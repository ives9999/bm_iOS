//
//  TempPlayTableHeaderView.swift
//  bm
//
//  Created by ives on 2017/12/14.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlayTableHeaderView: UIView {

    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func setup() {
        
    }
}
