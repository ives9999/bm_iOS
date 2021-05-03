//
//  LikeButton.swift
//  bm
//
//  Created by ives on 2021/4/27.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class LikeButton: SuperButton {
    
    var likeIcon: UIImage?
    
    var initCount: Int = 0
    var initLike: Bool = false
    var isLike: Bool = false
    var count: Int = 0
    
    let likeString: String = "like1"
    let unLikeString: String = "like"

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
        
        setColor(textColor: UIColor.white, bkColor: UIColor(LIKE_BUTTON))
        cornerRadius = 12
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        tintColor = .white
        imageView?.contentMode = .scaleAspectFit
    }
    
    func initStatus(_ initLike: Bool, _ initCount: Int) {
        self.initLike = initLike
        self.initCount = initCount
        self.isLike = initLike
        self.count = initCount
        
        if (initLike) {
            likeIcon = UIImage(named: likeString)
            tintColor = .red
        } else {
            likeIcon = UIImage(named: unLikeString)
            tintColor = .white
        }
        setImage(likeIcon, for: .normal)
        setTitle("\(initCount)人", for: .normal)
    }
    
    func setLike(_ _like: Bool, _ _count: Int? = nil) {
        isLike = _like
        if (_count != nil) {
            count = _count!
        }
        setIcon()
        setCount()
    }
    
    private func setIcon() {
        if (isLike) {
            likeIcon = UIImage(named: likeString)
            tintColor = .red
        } else {
            likeIcon = UIImage(named: unLikeString)
            tintColor = .white
        }
        setImage(likeIcon, for: .normal)
    }
    
    private func setCount() {
        if (initLike) {
            if (isLike) {
                count = initCount
            } else {
                count = initCount - 1
            }
        } else {
            if (isLike) {
                count = initCount + 1
            } else {
                count = initCount
            }
        }
        
        setTitle("\(count)人", for: .normal)
    }
}
