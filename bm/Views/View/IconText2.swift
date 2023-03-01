//
//  IconText2.swift
//  bm
//
//  Created by ives on 2023/3/1.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class IconText2: UIView {
    
    var icon: String = "noPhont"
    var text: String = "Add"
    
    var frameWidth: Int = 100
    var frameHeight: Int = 32
    var iconWidth: Int = 24
    var iconHeight: Int = 24
    var iconIV: UIImageView = UIImageView()
    var textLbl: UILabel = SuperLabel()
    
    var delegate: IconText2Delegate?
    
    init(icon: String, text: String, frameWidth: Int = 100, frameHeight: Int = 32, iconWidth: Int = 24, iconHeight: Int = 24) {
        
        self.icon = icon
        self.text = text
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
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        iconIV.image = UIImage(named: icon)
        textLbl.text = self.text

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
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func pressed(view: UITapGestureRecognizer) {
        delegate?.pressed(icon: icon)
    }
}

protocol IconText2Delegate {
    func pressed(icon: String)
}
