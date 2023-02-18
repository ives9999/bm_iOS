//
//  ShowButton2.swift
//  bm
//
//  Created by ives on 2023/2/17.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class ShowButton2: SuperButton {
    
    var delegate: ShowButton2Delegate?

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
        setTitle("內容", for: .normal)
        setColor(textColor: UIColor(MY_BLACK), bkColor: UIColor(MY_GREEN))
        frame.size = CGSize(width: 190, height: 40)
        self.cornerRadius = 20
        //contentEdgeInsets = UIEdgeInsets(top: 4, left: 36, bottom: 4, right: 36)
        
        self.addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }
    
    @objc func pressed(_ sender: UIButton) {
        delegate?.pressed()
    }
}

protocol ShowButton2Delegate {
    func pressed()
}
