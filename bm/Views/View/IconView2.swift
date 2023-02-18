//
//  IconView2.swift
//  bm
//
//  Created by ives on 2023/2/17.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class IconView2: UIView {
    
    var icon: String = "noPhont"
    var frameWidth: Int = 40
    var frameHeight: Int = 40
    var iconWidth: Int = 20
    var iconHeight: Int = 20
    var iconIV: UIImageView = UIImageView()
    
    var delegate: IconView2Delegate?
    
    init(icon: String, frameWidth: Int = 40, frameHeight: Int = 40, iconWidth: Int = 20, iconHeight: Int = 20) {
        
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
        
        //self.backgroundColor = UIColor(hex: MY_WHITE, alpha: 0.1)
        self.backgroundColor = UIColor(hex: MY_WHITE, alpha: 0.1)
        
        iconIV.image = UIImage(named: icon)

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
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.centerX.centerY.equalToSuperview()
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    @objc func pressed(_ sender: UITapGestureRecognizer) {
        delegate?.pressed(icon: icon)
    }
}

protocol IconView2Delegate {
    func pressed(icon: String)
}















