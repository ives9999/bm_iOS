//
//  tag_search.swift
//  bm
//
//  Created by ives on 2022/3/17.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit
import Starscream

class _tab_search: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var text: SuperLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //commonInit()
    }
    
//    override var intrinsicContentSize: CGSize {
//
//        var intrinsicSuperViewContentSize = super.intrinsicContentSize
//        intrinsicSuperViewContentSize.width = 20
//
//        return intrinsicSuperViewContentSize
//    }
    
//    override func draw(_ rect: CGRect) {
//
//        return
//    }

}
