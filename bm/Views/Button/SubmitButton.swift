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
        setTitle("送出", for: .normal)
        backgroundColor = UIColor(MY_RED)
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 36, bottom: 4, right: 36)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
}
