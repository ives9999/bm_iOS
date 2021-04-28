//
//  LikeButton.swift
//  bm
//
//  Created by ives on 2021/4/27.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class LikeButton: SuperButton {

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
        
        let likeIcon: UIImage = UIImage(named: "like")!
        setImage(likeIcon, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
        setTitle("xx人", for: .normal)
        setColor(textColor: UIColor.white, bkColor: UIColor(LIKE_BUTTON))
        cornerRadius = 12
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        tintColor = .white
    }
}
