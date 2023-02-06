//
//  ShowLike2.swift
//  bm
//
//  Created by ives on 2023/2/5.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class ShowLike2: UIView {
    
    
    var initCount: Int = 0
    var initLike: Bool = false
    var isLike: Bool = false
    var count: Int = 0
    
    let likeString: String = "like_in_svg"
    let unLikeString: String = "like_out_svg"
    
    let backgroundAlpha: CGFloat = 0.2
    
//    let likeContainer: UIView = {
//        let view = UIView()
//        return view
//    }()
    
    let likeHeartCircle: UIView = {
        let view = UIView()
        return view
    }()
    
    let likeIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let likeCountLbl: UILabel = {
        let view = SuperLabel()
        view.text = "16"
        //view.backgroundColor = UIColor.red
        view.textAlignment = .center
        return view
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        likeHeartCircle.backgroundColor = UIColor(hex: MY_GREEN, alpha: self.backgroundAlpha)
        likeIcon.image = UIImage(named: likeString)
        
        self.anchor()
    }

    func anchor() {
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.height.equalTo(50)
        }
        
        self.addSubview(likeHeartCircle)
        likeHeartCircle.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
            likeHeartCircle.addSubview(likeIcon)
            likeIcon.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.centerX.centerY.equalToSuperview()
            }
        
        self.addSubview(likeCountLbl)
        likeCountLbl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(likeHeartCircle.snp.bottom).offset(5)
        }
    }
    
    func backgroundCircle() {
        likeHeartCircle.circle()
    }
}
