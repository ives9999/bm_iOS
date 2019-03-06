//
//  SubmitButton.swift
//  bm
//
//  Created by ives on 2018/10/20.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class SubmitButton: SuperButton {

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
        setTitle("送出", for: .normal)
        setColor(textColor: UIColor.white, bkColor: UIColor(MY_RED))
        self.cornerRadius = 12
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 36, bottom: 4, right: 36)
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
}
