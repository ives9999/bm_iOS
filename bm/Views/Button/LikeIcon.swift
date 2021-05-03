//
//  LikeIcon.swift
//  bm
//
//  Created by ives on 2021/4/30.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class LikeIcon: SuperButton {
    
    var isLike: Bool = false
    
    let likeIcon: UIImage = UIImage(named: "like1")!
    let unLikeIcon: UIImage = UIImage(named: "like")!
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func commonInit() {
        
        //initStatus(isLike)
    }
    
//    func initStatus(_ initLike: Bool) {
//        isLike = initLike
//        if (isLike) {
//            setBackgroundImage(likeIcon, for: .normal)
//        } else {
//            setBackgroundImage(unLikeIcon, for: .normal)
//        }
//    }
    
    func setLike() {
        
        isLike = !isLike
        if (isLike) {
            setBackgroundImage(likeIcon, for: .normal)
        } else {
            setBackgroundImage(unLikeIcon, for: .normal)
        }
    }
}
