//
//  IconText2.swift
//  bm
//
//  Created by ives on 2023/3/1.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class IconWithBGRoundCorner: UIView {
    
    var icon: String = "noPhont"
    
    var frameWidth: Int = 100
    var frameHeight: Int = 32
    var iconWidth: Int = 24
    var iconHeight: Int = 24
    var iconIV: UIImageView = UIImageView()
    
    var delegate: IconWithBGRoundCornerDelegate?
    
    init(icon: String = "", frameWidth: Int = 48, frameHeight: Int = 48, iconWidth: Int = 24, iconHeight: Int = 24) {
        
        self.icon = icon
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
        
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
        
        self.backgroundColor = UIColor(hex: MY_WHITE, alpha: 0.13)
        //self.backgroundColor = UIColor(hex: MY_WHITE, alpha: 0.8)
        self.layer.cornerRadius = CGFloat(frameWidth / 2)
        self.clipsToBounds = true
        
        if icon.count > 0 {
            setIcon(icon)
        }

        self.anchor()

        let tap = UITapGestureRecognizer(target: self, action: #selector(pressed))
        self.addGestureRecognizer(tap)
    }
    
    func anchor() {
        
        self.snp.makeConstraints { make in
            make.width.equalTo(frameWidth)
            make.height.equalTo(frameHeight)
        }
        
        self.addSubview(iconIV)
        iconIV.snp.makeConstraints { make in
            make.width.height.equalTo(iconWidth)
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func setIcon(_ icon: String) {
        iconIV.image = UIImage(named: icon)
    }
    
    @objc func pressed(view: UITapGestureRecognizer) {
        delegate?.pressed(icon: icon)
    }
}

protocol IconWithBGRoundCornerDelegate {
    func pressed(icon: String)
}
