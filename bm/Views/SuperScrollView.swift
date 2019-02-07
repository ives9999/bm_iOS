//
//  SuperScrollView.swift
//  bm
//
//  Created by ives on 2019/2/3.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SuperScrollView: UIScrollView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    func commonInit(){
        self.backgroundColor = UIColor.black
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
