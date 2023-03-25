//
//  SubmitButton.swift
//  bm
//
//  Created by ives on 2018/10/20.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class SubmitButton: SuperButton {
    
    var delegate: SubmitButtonDelegate?

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
        super.commonInit()
        setTitle("送出", for: .normal)
        setColor(textColor: UIColor(MY_BLACK), bkColor: UIColor(MY_GREEN))
        frame.size = CGSize(width: 200, height: 35)
        //self.cornerRadius = MY_BUTTON_CORNER
        //contentEdgeInsets = UIEdgeInsets(top: 4, left: 36, bottom: 4, right: 36)
        
        self.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }
    
    @objc func submit() {
        delegate?.submit2()
    }
}

protocol SubmitButtonDelegate {
    func submit2()
}

